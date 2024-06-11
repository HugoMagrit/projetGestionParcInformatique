import 'package:flutter/material.dart';
import 'package:projetp4_flutter/metier/ConsulterLesMesuresActuelles.dart';

class PanelSector extends StatefulWidget
{
  final ConsulterLesMesuresActuelles consulterLesMesuresActuelles;
  final int sector;

  const PanelSector
      (
      {
    super.key,
    required this.consulterLesMesuresActuelles,
    required this.sector,
  }
  );

  @override
  PanelSectorState createState() => PanelSectorState();
}


class PanelSectorState extends State<PanelSector>
{
  bool isButtonDisabled = false;
  bool? askedState;

  void isButtonPress(bool newState)
  {
    setState(
            ()
    {
      isButtonDisabled = true;
      askedState = newState;
    }
    );
    widget.consulterLesMesuresActuelles.updateState(widget.sector, newState, 'secteur');
    widget.consulterLesMesuresActuelles.verificationMachine(newState, widget.sector);
    messageMachine(context, widget.consulterLesMesuresActuelles.verificationMachine(newState, widget.sector) as List<String>);
  }

  void checkSectorState() async
  {
    while (isButtonDisabled)
    {
      final sectorData = await widget.consulterLesMesuresActuelles.getSectorData(widget.sector);
      if (sectorData.sectorState == askedState)
      {
        setState(
                ()
        {
          isButtonDisabled = false;
          askedState = null;
        }
        );
      }
      await Future.delayed(const Duration(seconds: 60));
    }
  }

  void messageMachine(BuildContext context, List<String> message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Liste de Textes'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: message.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(message[index]),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

    @override
    Widget build(BuildContext context)
    {
      Icon getIcon(bool? state)
      {
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

      String setMessage(String? adresseMAC, double conso, String? typeModule) {
        String message = '';
        if (conso == -(1.0))
        {
          message =
          'Module $typeModule: $adresseMAC, Consommation: Aucune valeur';
        }
        else
        {
          message = 'Module $typeModule: $adresseMAC, Consommation: $conso';
        }
        return message;
      }
      return Container(
        width: 1000,
        height: double.infinity,
        color: Colors.grey[300],
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: Column(
                  children: [
                    const Text('Séléction du graphique'),
                    FutureBuilder(
                      future: widget.consulterLesMesuresActuelles.getSectorData(
                          widget.sector),
                      builder: (context, snapshot)
                      {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting)
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
                          if (sectorDataList.moduleMachineState.isEmpty &&
                              sectorDataList.moduleScreenState.isEmpty) {
                          }

                          List<Widget> buttons = [];

                          // Boutons pour les modules machines
                          sectorDataList.moduleMachineState.forEach((key, value)
                          {
                            final conso = sectorDataList.moduleMachineConso[key] ?? -1.0;
                            buttons.add(
                                Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                            setMessage(key, conso, 'machine')),
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
                                        child: Text(
                                            setMessage(key, conso, 'écran')),
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

            FutureBuilder(
              future: widget.consulterLesMesuresActuelles.getSectorData(
                  widget.sector),
              builder: (context, snapshot) {
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
                  final sectorData = snapshot.data!;
                  bool isSectorActive = sectorData.sectorState;
                  bool askedSector = sectorData.sectorAskedState;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Secteur ${widget.sector}: '),
                      ElevatedButton(
                        onPressed: isButtonDisabled || isSectorActive ? null : ()
                        {
                          isButtonPress(true);
                          checkSectorState();
                        },
                        child: const Text('Activer', selectionColor: Colors.black,),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            askedSector ? Colors.grey : Colors.blue,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: isButtonDisabled || !isSectorActive ? null : ()
                        {
                          isButtonPress(false);
                          checkSectorState();
                        },
                        child: const Text('Désactiver', selectionColor: Colors
                            .black,),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            askedSector ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      );
    }
  }