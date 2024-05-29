import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetp4_flutter/metier/bdd.dart';

class ConsulterLesMesuresActuelles
{
  final DataBase _bdd;
  List<SectorData> _sectorDataList = [];
  Timer? _timer;

  ConsulterLesMesuresActuelles(this._bdd);

  Future<List<SectorData>> getSectorData() async
  {
    final sectors = await _bdd.getSector();
    _sectorDataList.clear();

    for (int i = 1; i <= sectors; i++)
    {
      Map<String, bool> sectorStateMap = await _bdd.getState("sector", i);
      bool sectorState = sectorStateMap[i.toString()] ?? false;

      List<double> consos = await _bdd.getConso(true, i);
      Map<String, bool> moduleMachineStates = await _bdd.getState("moduleMachine", i);
      Map<String, bool> moduleScreenStates = await _bdd.getState("moduleScreen", i);

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

  Future<bool> getStateSector(int sectorId) async
  {
    Map<String, bool> stateMap = await _bdd.getState("sector", sectorId);
    bool state = stateMap[sectorId.toString()] ?? false;
    return state;
  }

  Future<double> getConso(int sectorId) async
  {
    final consos = await _bdd.getConso(true, sectorId);
    print('Consommation: $consos');
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
