import 'package:flutter/material.dart';
import 'package:projetp4_flutter/metier/ConsulterLesMesuresActuelles.dart';

class PanelSector extends StatelessWidget {
  final ConsulterLesMesuresActuelles consulterLesMesuresActuelles;
  final int sector;

  const PanelSector(
      {
        super.key,
        required this.consulterLesMesuresActuelles,
        required this.sector,
      }
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      height: double.infinity,
      color: Colors.grey[300],
      child: Column(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
                  child: Center(
                    child: Column(
                      children: [
                        const Text('Séléction du graphique'),
                        FutureBuilder(
                        future: consulterLesMesuresActuelles.getSectorData(sector),
                        builder: (context, snapshot)
                        {
                          if (snapshot.connectionState == ConnectionState.waiting)
                          {
                            return const CircularProgressIndicator();
                          }
                          else if (snapshot.hasError)
                          {
                            return Text('Erreur : ${snapshot.error}');
                          }
                          else if (!snapshot.hasData)
                          {
                            return const Text('Aucune donnée disponible');
                          }
                          else
                          {
                            final sectorDataList = snapshot.data!;
                            if (sectorDataList.moduleMachineState.isEmpty && sectorDataList.moduleScreenState.isEmpty) {
                              return const Text('Aucun module disponible');
                            }

                            List<Widget> buttons = [];

                            Icon getIcon(bool? state) {
                              if (state == null)
                              {
                                return const Icon(Icons.hourglass_empty, color: Colors.grey);
                              }
                              else if (state)
                              {
                                return const Icon(Icons.check_circle, color: Colors.green);
                              }
                              else
                              {
                                return const Icon(Icons.cancel, color: Colors.red);
                              }
                            }

                            // Boutons pour les modules machines
                            sectorDataList.moduleMachineState.forEach((key, value)
                            {
                              final conso = sectorDataList.moduleMachineConso[key] ?? -1.0;
                              buttons.add(
                                  Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Module machine: $key, Consommation: $conso'),
                                        ),
                                        ElevatedButton(
                                            onPressed: ()
                                            {
                                              //TODO
                                            },
                                            child: getIcon(value)
                                        )
                                      ]
                                  )
                              );
                            }
                            );

                            // Boutons pour les modules écrans
                            sectorDataList.moduleScreenState.forEach((key, value)
                            {
                              final conso = sectorDataList.moduleScreenConso[key] ?? -1.0;
                              buttons.add(
                                Row(
                                  children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Module écran: $key, Consommation: $conso'),
                                  ),
                                  ElevatedButton(
                                      onPressed: ()
                                      {
                                        //TODO
                                      },
                                      child: getIcon(value)
                                  )
                              ]
                                )
                              );
                            });

                            return Wrap(
                              spacing: 8, // espace entre les boutons
                              runSpacing: 4, // espace entre les lignes
                              children: buttons,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  ),
            ),

          Container(
              child: Text('Activer modules machines', style: TextStyle(color: Colors.blueGrey),)
          ),

          Container(
              child: Text('Activer modules écrans', style: TextStyle(color: Colors.blueGrey),)
          ),

          Container(
              child: Text('Activer secteur', style: TextStyle(color: Colors.blueGrey),)
          ),
        ],
      ),
    );
  }
}