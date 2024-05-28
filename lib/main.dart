import 'package:flutter/material.dart';
import 'package:projetp4_flutter/pages/home/gestionBoutton.dart';
import 'package:projetp4_flutter/pages/home/home.dart';
import 'package:projetp4_flutter/metier/bdd.dart';
import 'package:projetp4_flutter/metier/ConsulterLesMesuresActuelles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DataBase bdd = DataBase();
    ConsulterLesMesuresActuelles consulterLesMesuresActuelles = ConsulterLesMesuresActuelles(bdd);
    return MaterialApp(
      title: 'Projet Gestion Energetique',
      debugShowCheckedModeBanner: false,
      home: HomePage(consulterLesMesuresActuelles: consulterLesMesuresActuelles, timerManager: 1,),
    );
  }
}