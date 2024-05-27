import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetp4_flutter/pages/bdd.dart';
import 'package:projetp4_flutter/pages/home/gestionBoutton.dart';
import 'package:projetp4_flutter/pages/timer.dart' as timer;

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

  @override
  void initState() {
    super.initState();
    sectorButtons();
    timer = Timer.periodic(const Duration(seconds: 300), (timer) {
      setState(() {});
    });
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
      body: Column(
        children: [
          Container(
            color: Colors.blueGrey,
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
            child: Stack(
              children: <Widget>[
                Image.asset('assets/Images/planSalle.png'),
                Stack(
                  children: pages.isNotEmpty ? pages[currentPage] : [],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            height: 125,
            width: double.infinity,
            child: const Center(
              child: Text('Les logs'),
            ),
          ),
        ],
      ),
    );
  }
}
