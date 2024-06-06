import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetp4_flutter/pages/avecPanel/panelSector.dart';
import 'package:projetp4_flutter/metier/ConsulterLesMesuresActuelles.dart';

// Classe du bouton secteur
class ButtonSector extends StatefulWidget
{
  final ConsulterLesMesuresActuelles consulterLesMesuresActuelles;
  final int sector;
  final VoidCallback onPressed;

  const ButtonSector(
      {
    super.key,
    required this.consulterLesMesuresActuelles,
    required this.sector,
    required this.onPressed,
    }
  );

  @override
  ButtonSectorState createState() => ButtonSectorState();
}

// Etat du bouton repésentant un secteur
class ButtonSectorState extends State<ButtonSector>
{
  late Timer timer;

  @override
  void initState()
  {
    super.initState();
    // Démarrage du timer pour obtenir et rafraichir les mesures du secteur
    widget.consulterLesMesuresActuelles.startTimer(
        const Duration(seconds: 300),
            (List<SectorData> newSectorDataList)
        {
          if (mounted) {
            setState(() {});
          }
        }
    );
  }

  Future<void> _openPanelSector(BuildContext context, int sector) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PanelSector(
          consulterLesMesuresActuelles: widget.consulterLesMesuresActuelles,
          sector: sector,
        );
      },
    );
  }

  @override
  void dispose() {
    // Arrête le timer lors de la fermeture de la page
    widget.consulterLesMesuresActuelles.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    // Affiche le bouton avec les informations du secteur
    return ElevatedButton(
      onPressed: ()
      {
        // Ouverture du panel lorsque l'on appuie sur le bouton
        _openPanelSector(context, widget.sector);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        minimumSize: MaterialStateProperty.all<Size>(const Size(250, 350)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Affichage du numéro du secteur
          Text('Secteur ${widget.sector}', style: TextStyle(color: Colors.grey[300])),

          // Affichage de l'état du secteur
          FutureBuilder<bool>(
            future: widget.consulterLesMesuresActuelles.getStateSector(widget.sector),
            builder: (context, snapshot)
            {
              if (snapshot.connectionState == ConnectionState.waiting)
              {
                return const CircularProgressIndicator();
              }
              /*else if (snapshot.hasError)
              {
                return Text('Problème de base de données', style: TextStyle(color: Colors.grey[300]));
              }*/
              else
              {
                final state = snapshot.data!;
                return Text('État : ${state ? 'Allumé' : 'Éteint'}', style: TextStyle(color: Colors.grey[300]));
              }
            },
          ),

          //Affichage de la consommation globale du secteur
          FutureBuilder<double>(
            future: widget.consulterLesMesuresActuelles.getConso(widget.sector),
            builder: (context, snapshot)
            {
              if (snapshot.connectionState == ConnectionState.waiting)
              {
                return const CircularProgressIndicator();
              }
              /*else if (snapshot.hasError)
              {
                print('Erreur lors de la récupération de la consommation du secteur ${widget.sector}: ${snapshot.error}');
                return Text('Erreur: ${snapshot.error}', style: TextStyle(color: Colors.grey[300]));
              }*/
              else
              {
                final conso = snapshot.data!;
                if(conso==-1)
                {
                  return const Text('Aucune données');
                }
                else
                {
                  return Text('Consommation : ${conso}W', style: TextStyle(color: Colors.grey[300]));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}