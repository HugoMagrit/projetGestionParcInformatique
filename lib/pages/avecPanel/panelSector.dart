import 'package:flutter/material.dart';
import 'package:projetp4_flutter/metier/ConsulterLesMesuresActuelles.dart';

class PanelSector extends StatelessWidget {
  final ConsulterLesMesuresActuelles consulterLesMesuresActuelles;
  final int sector;

  const PanelSector({
    super.key,
    required this.consulterLesMesuresActuelles,
    required this.sector,
  });

  @override
  Widget build(BuildContext context)
  {
    return Container
        (
        width: 1000,
        height: double.infinity,
        color: Colors.grey[300],
        child: Column
          (
          children:
          [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: FutureBuilder(
                future: consulterLesMesuresActuelles.getSectorData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('Aucune donnée disponible');
                  } else {
                    final sectorDataList = snapshot.data!;
                    if (sectorDataList.isEmpty) {
                      return const Text('Aucun secteur disponible');
                    }

                    final sectorData = sectorDataList.firstWhere((element) => element.sectorId == sector);

                    if (sectorData.moduleMachineState.isEmpty && sectorData.moduleScreenState.isEmpty) {
                      return const Text('Aucun module disponible');
                    }

                    List<Widget> buttons = [];

                    // Boutons pour les modules machines
                    sectorData.moduleMachineState.forEach((key, value) {
                      buttons.add(ElevatedButton(
                        onPressed: () {},
                        child: Text('Machine: $key'),
                      ));
                    });

                    // Boutons pour les modules écrans
                    sectorData.moduleScreenState.forEach((key, value) {
                      buttons.add(ElevatedButton(
                        onPressed: () {},
                        child: Text('Écran: $key'),
                      ));
                    });

                    return Wrap(
                      spacing: 8, // espace entre les boutons
                      runSpacing: 4, // espace entre les lignes
                      children: buttons,
                    );
                  }
                },
              ),
            ),

                  Container(
                      child: const Column(
                          children:
                          [
                            //TODO
                            Text('Consommation des différents modules',
                              style: TextStyle(color: Colors.blueGrey),)
                          ]
                      )
                  ),

                  Container(
                    //TODO
                      child: Text('Activer modules machines',
                        style: TextStyle(color: Colors.blueGrey),)
                  ),

                  Container(
                    //TODO
                      child: Text('Activer modules écrans',
                        style: TextStyle(color: Colors.blueGrey),)
                  ),

                  Container(
                    //TODO
                      child: Text('Activer secteur',
                        style: TextStyle(color: Colors.blueGrey),)
                  ),
                ],
              ),
        );
  }
}