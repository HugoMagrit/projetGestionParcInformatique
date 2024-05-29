import 'package:flutter/material.dart';
import 'package:projetp4_flutter/metier/timer.dart';
import 'package:projetp4_flutter/pages/home/home.dart';
import 'package:projetp4_flutter/metier/bdd.dart';
import 'package:projetp4_flutter/metier/ConsulterLesMesuresActuelles.dart';

// Fonction principale qui démarre l'application Flutter
void main()
{
  runApp(const MyApp());
}

// Classe principale de l'application Flutter
class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    // Initialisation de l'objet BdD et consulterLesMesuresActuelles
    DataBase bdd = DataBase();
    ConsulterLesMesuresActuelles consulterLesMesuresActuelles = ConsulterLesMesuresActuelles(bdd);

    // Affichage de l'application
    return MaterialApp(
      title: 'Projet Gestion Energetique',
      debugShowCheckedModeBanner: false,
      home: HomePage(
        consulterLesMesuresActuelles: consulterLesMesuresActuelles,
        timerManager: TimerManager(),
      ),
    );
  }
}