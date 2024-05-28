import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetp4_flutter/metier/bdd.dart';
import 'package:projetp4_flutter/pages/home/gestionBoutton.dart';
import 'package:projetp4_flutter/metier/timer.dart' as timer;
import 'package:projetp4_flutter/pages/avecPanel/panelSector.dart';
import 'package:projetp4_flutter/metier/ConsulterLesMesuresActuelles.dart';

class HomePage extends StatefulWidget {
  final timer.TimerManager timerManager;

  const HomePage({super.key, required this.timerManager});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer timer;
  List<List<Widget>> pages = [];
  int currentPage = 0;
  List<SectorData> sectorDataList = [];

  @override
  void initState() {
    super.initState();
    sectorButtons();
    timer = Timer.periodic(const Duration(seconds: 300), (timer) {
      setState(() {});
    });
    loadData();
  }

  Future<void> loadData() async {
    ConsulterLesMesuresActuelles consulter = ConsulterLesMesuresActuelles();
    sectorDataList = await consulter.consulterLesMesuresActelles();
    setState(() {});
  }

  @override
  void dispose() {
    widget.timerManager.stopTimer();
    super.dispose();
  }

  Future<void> sectorButtons() async {
    final sectorCount = await DataBase().getSector();
    final pageCount = (sectorCount / 4).ceil();

    for (int i = 0; i < pageCount; i++) {
      List<Widget> pageButtons = [];
      for (int j = i * 4; j < (i + 1) * 4 && j < sectorCount; j++) {
        final button = ButtonSector(
          timerManager: widget.timerManager,
          onPressed: () {},
          sector: j + 1,
        );

        double x = 120.0, y = 300.0;
        switch (j % 4) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: PanelSector(),
      body: Column(
        children: [
          Container(
            color: Colors.blueAccent,
            height: 150,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(pages.length, (index) {
                return Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
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

          Container(
            color: Colors.blueAccent,
            height: 125,
            width: double.infinity,
            child: Center(
              child: Text('Les logs', style: TextStyle(color: Colors.grey[300])),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: sectorDataList.length,
              itemBuilder: (context, index) {
                SectorData sectorData = sectorDataList[index];
                return Card(
                  child: Column(
                    children: [
                      Text('Secteur ${sectorData.sectorId}'),
                      Text('État : ${sectorData.sectorState? 'Allumé' : 'Éteint'}'),
                      Text('Consommation : ${sectorData.consos.join(', ')}W'),
                      Text('États des machines : ${sectorData.moduleMachineState.keys.map((key) => '$key : ${(sectorData.moduleMachineState[key]?? false)? 'Allumé' : 'Éteint'}').join(', ')}'),
                      Text('États des écrans : ${sectorData.moduleScreenState.keys.map((key) => '$key : ${(sectorData.moduleScreenState[key]?? false)? 'Allumé' : 'Éteint'}').join(', ')}'),
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
