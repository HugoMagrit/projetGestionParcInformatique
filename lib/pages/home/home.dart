import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetp4_flutter/pages/bdd.dart';
import 'package:projetp4_flutter/pages/gestionBoutton.dart';

class HomePage extends StatefulWidget {
  final TimerManager timerManager;

  const HomePage({super.key, required this.timerManager});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  List<Widget> buttons = [];

  @override
  void initState() {
    sectorButtons();
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
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
    for (int i = 1; i <= sectorCount; i++) {
      final button = ButtonSector(
        timerManager: widget.timerManager,
        onPressed: () {},
        sector: i,
      );
      double x=120.0;
      double y=300.0;
      switch (i) {
        case 1:
          x=20.0;
          y=20.0;
        case 2:
          x = 370.0;
          y=70.0;
          break;
        case 3:
          x = 660.0;
          y=70.0;
          break;
        case 4:
          x = 1010.0;
          y=70.0;
          break;
      }
      buttons.add(
        Positioned(
          top: y,
          left: x,
          child: button,
        ),
      );
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
            width: 9000,
            child: const Center(
              child: Text(''),
            ),
          ),

          SizedBox(
              height: 465,
              width: 1280,
              child: Stack(
                  children: <Widget>[
                    Image.asset('assets/Images/planSalle.png'),
                    Stack(
                        children: buttons
                    ),
                  ]
              )
          ),

          Container(
            color: Colors.grey,
            height: 125,
            width: 9000,
            child: const Center(
              child: Text('Les logs'),
            ),
          )
        ],
      ),
    );
  }
}
