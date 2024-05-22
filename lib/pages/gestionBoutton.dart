import 'package:flutter/material.dart';
import 'package:projetp4_flutter/pages/bdd.dart';
import 'dart:async';

class ButtonSector extends StatelessWidget {
  final TimerManager timerManager;
  final VoidCallback onPressed;
  final Widget child;

  ButtonSector({super.key, required this.timerManager, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }

  DataBase bdd = DataBase();

  createButton(int numSector, double sectorConso, bool sectorState) {
    return ElevatedButton(
        style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(0),
    ))), onPressed: () async { bdd.getStateSector(1).then((sector) {
      print('Etat du secteur $numSector: $sector');
    }); }, child: null,);
  }
}

class TimerManager {
  Timer? _timer;
  final int id;
  final Function getConso;
  final Function getStateSector;

  TimerManager({
    required this.id,
    required this.getConso,
    required this.getStateSector,
  });

  void startTimer(Duration interval, Function callback) {
    _timer = Timer.periodic(interval, (timer) {
      callback();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }
}