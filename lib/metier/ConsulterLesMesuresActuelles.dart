import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetp4_flutter/metier/bdd.dart';

// Classe pour consulter les mesures actuelles
class ConsulterLesMesuresActuelles
{
  final DataBase m_bdd;
  List<SectorData> _sectorDataList = [];
  Timer? _timer;

  ConsulterLesMesuresActuelles(this.m_bdd);

  // Obtient les différentes données du secteur
  Future<List<SectorData>> getSectorData() async
  {
    final sectors = await m_bdd.getSector();
    _sectorDataList.clear();

    for (int i = 1; i <= sectors; i++)
    {
      Map<String, bool> sectorStateMap = await m_bdd.getState("sector", i);
      bool sectorState = sectorStateMap[i.toString()] ?? false;

      List<double> consos = await m_bdd.getConso(true, i);
      Map<String, bool> moduleMachineStates = await m_bdd.getState("moduleMachine", i);
      Map<String, bool> moduleScreenStates = await m_bdd.getState("moduleScreen", i);

      SectorData sectorData = SectorData(
        sectorId: i,
        sectorState: sectorState,
        consos: consos,
        moduleMachineState: moduleMachineStates,
        moduleScreenState: moduleScreenStates,
      );

      _sectorDataList.add(sectorData);
    }

    return _sectorDataList;
  }

  // Obtient l'état du secteur
  Future<bool> getStateSector(int sectorId) async
  {
    Map<String, bool> stateMap = await m_bdd.getState("sector", sectorId);
    bool state = stateMap[sectorId.toString()] ?? false;
    return state;
  }

  // Obtient la consommation du secteur
  Future<double> getConso(int sectorId) async
  {
    final consos = await m_bdd.getConso(true, sectorId);
    return consos.isNotEmpty ? consos.first : 0.0;
  }

  void startTimer(Duration duration, Function(List<SectorData>) updateSectorDataList)
  {
    _timer = Timer.periodic(duration, (timer) {
      getSectorData().then((value) {
        updateSectorDataList(value);
      });
    });
  }

  void stopTimer()
  {
    _timer?.cancel();
  }
}

// Modèle de données pour un secteur
class SectorData
{
  int sectorId;
  bool sectorState;
  List<double> consos;
  Map<String, bool> moduleMachineState;
  Map<String, bool> moduleScreenState;

  SectorData(
      {
    required this.sectorId,
    required this.sectorState,
    required this.consos,
    required this.moduleMachineState,
    required this.moduleScreenState,
    }
  );
}
