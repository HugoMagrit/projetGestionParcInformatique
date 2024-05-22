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

  @override
  void initState() {
    super.initState();
    widget.timerManager.startTimer(const Duration(seconds: 30), () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.timerManager.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataBase bdd = DataBase();
    return Scaffold(
      body: Column(
        children: [

          Container(
            color: Colors.blueGrey,
            height: 150,
            width: 9000,
            child: const Center(
              child: Text('Les pages'),
            ),
          ),

          SizedBox(
            height: 450,
            width: 9000,
            child: Stack(
              children: <Widget>[
                Image.asset('assets/planSalle.png'),
              SizedBox(
                  width: 300,
                  height: 300,
                child: Stack(
                  children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: ButtonSector(
                      timerManager: widget.timerManager,
                      onPressed: () {},
                      child: const Text('Fluttering Button'),
                    ).createButton(1, 12, true),
                  ),
                  ]
                )
              )
              ]
              )
          ),
        ],
      ),
    );
  }
}
