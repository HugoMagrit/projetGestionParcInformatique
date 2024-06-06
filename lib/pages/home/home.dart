import 'package:flutter/material.dart';
import 'package:projetp4_flutter/pages/home/gestionBoutton.dart';
import 'package:projetp4_flutter/metier/bdd.dart';
import 'package:projetp4_flutter/metier/timer.dart';
import 'package:projetp4_flutter/metier/ConsulterLesMesuresActuelles.dart';

// Page d'accueil de l'application
class HomePage extends StatefulWidget
{
  final ConsulterLesMesuresActuelles consulterLesMesuresActuelles;
  final TimerManager timerManager;

  const HomePage(
      {
        super.key,
        required this.consulterLesMesuresActuelles,
        required this.timerManager
      }
      );

  @override
  State<HomePage> createState() => _HomePageState();
}

// Etat de la page d'accueil
class _HomePageState extends State<HomePage>
{
  List<List<Widget>> pages = [];
  int currentPage = 0;
  List<SectorData> sectorDataList = [];

  @override
  void initState()
  {
    super.initState();
    sectorButtons();
    // Démarre le timer pour obtenir les mesures actuelles et les rafraichir toutes les 5 min
    widget.consulterLesMesuresActuelles.startTimer(const Duration(seconds: 300), (List<SectorData> newSectorDataList)
    {
      setState(()
      {
        sectorDataList = newSectorDataList;
      }
      );
    }
    );
  }

  @override
  void dispose()
  {
    // Arrête le timer une fois la page fermée
    widget.consulterLesMesuresActuelles.stopTimer();
    super.dispose();
  }

  // Méthode qui créé autant de boutons qu'il y a de secteurs
  Future<void> sectorButtons() async
  {
    final sectorCount = await DataBase().getSector();

    // Calcul du nombre de page à créer
    final pageCount = (sectorCount / 4).ceil();

    for (int i = 0; i < pageCount; i++)
    {
      List<Widget> pageButtons = [];
      // Création et placement des boutons
      for (int j = i * 4; j < (i + 1) * 4 && j < sectorCount; j++)
      {
        final button = ButtonSector(
          consulterLesMesuresActuelles: widget.consulterLesMesuresActuelles,
          onPressed: () {},
          sector: j + 1,
        );

        double x = 120.0, y = 300.0;
        switch (j % 4)
        {
          case 0:
            x = 20.0;
            y = 20.0;
            break;
          case 1:
            x = 370.0;
            y = 70.0;
            break;
          case 2:
            x = 660.0;
            y = 70.0;
            break;
          case 3:
            x = 1010.0;
            y = 70.0;
            break;
        }
        // Ajout du bouton à la page actuelle
        pageButtons.add(
          Positioned(
            top: y,
            left: x,
            child: button,
          ),
        );
      }
      pages.add(pageButtons);
    }
    setState(() {});
  }

  // Construction de l'interface utilisateur de la page d'accueil
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      // Corps de page
      body: Column(
        children: [
          // En-tête qui contient les différentes pages de secteurs
          Container(
            color: Colors.blueAccent,
            height: 150,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(pages.length, (index)
              {
                return Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: ()
                      {
                        setState(()
                        {
                          currentPage = index;
                        });
                      },
                      child: Text(
                        'Salle ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[300],
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Zone d'affichage des boutons des 4 secteurs de la page
          SizedBox(
            height: 465,
            width: 1280,
            child: Container(
              color: Colors.grey[300],
              child: Stack(
                children: <Widget>[
                  Stack(
                    children: pages.isNotEmpty ? pages[currentPage] : [],
                  ),
                ],
              ),
            ),
          ),

          // Pieds de la page qui affichera les logs
          Container(
            color: Colors.blueAccent,
            height: 125,
            width: double.infinity,
            child: Center(
              child: Text('Les logs', style: TextStyle(color: Colors.grey[300])),
            ),
          ),

          // Affichage des données de secteur
          Expanded(
            child: ListView.builder(
              itemCount: sectorDataList.length,
              itemBuilder: (context, index) {
                SectorData sectorData = sectorDataList[index];
                return Card(
                  child: Column(
                    children: [
                      Text('Secteur ${sectorData.sectorId}'),
                      Text('État : ${sectorData.sectorState ? 'Allumé' : 'Éteint'}'),
                      Text('Consommation : ${sectorData.consos.join(', ')}W'),
                      Text('États des machines : ${sectorData.moduleMachineState.keys.map((key) => '$key : ${(sectorData.moduleMachineState[key] ?? false) ? 'Allumé' : 'Éteint'}').join(', ')}'),
                      Text('États des écrans : ${sectorData.moduleScreenState.keys.map((key) => '$key : ${(sectorData.moduleScreenState[key] ?? false) ? 'Allumé' : 'Éteint'}').join(', ')}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
