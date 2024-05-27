import 'package:flutter/material.dart';
import 'package:projetp4_flutter/pages/home/gestionBoutton.dart';
import 'package:projetp4_flutter/pages/home/home.dart';
import 'package:projetp4_flutter/pages/bdd.dart';
import 'package:projetp4_flutter/pages/timer.dart' as timer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DataBase bdd = DataBase();
    return MaterialApp(
      title: 'Projet Gestion Energetique',
      debugShowCheckedModeBanner: false,
      home: HomePage(timerManager: timer.TimerManager(id: 1, getConso: bdd.getConso, getStateSector: bdd.getStateSector)),
    );
  }
}