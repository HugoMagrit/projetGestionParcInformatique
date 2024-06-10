import 'dart:async';
import 'package:projetp4_flutter/metier/bdd.dart';

class ConsulterLesMesuresActuelles
{
  final DataBase m_bdd;
  final List<SectorData> sectorDataList = [];
  Timer? timer;

  ConsulterLesMesuresActuelles(this.m_bdd);

  Future<List<SectorData>> getAllSectorData() async {
    final sectors = await m_bdd.getSector();
    sectorDataList.clear();

    for (int i = 1; i <= sectors; i++) {
      sectorDataList.add(await getSectorData(i));
    }

    return sectorDataList;
  }

  // Obtient les données d'un secteur spécifique
  Future<SectorData> getSectorData(int sectorId) async {
    Map<String, bool> sectorStateMap = await m_bdd.getState("sector", sectorId);
    bool sectorState = sectorStateMap[sectorId.toString()] ?? false;

    List<double> consos = await m_bdd.getConso(true, sectorId);
    Map<String, bool> moduleMachineStates = await m_bdd.getState("moduleMachine", sectorId);
    Map<String, bool> moduleScreenStates = await m_bdd.getState("moduleScreen", sectorId);
    Map<String, double> moduleMachineConso = [] as Map<String, double>;
    Map<String, double> moduleScreenConso = [] as Map<String, double>;

    for(int i=0; i<=moduleMachineStates.length; i++)
      {
        moduleMachineConso = (await m_bdd.getConsoModule(sectorId, true, moduleMachineStates[i] as String, 'machine'));
        print('$moduleMachineConso');
      }

    for(int i=0; i<=moduleScreenStates.length; i++)
    {
      moduleScreenConso = (await m_bdd.getConsoModule(sectorId, true, moduleScreenStates[i] as String, 'ecran'));
      print('$moduleScreenConso');
    }

    return SectorData(
      sectorId: sectorId,
      sectorState: sectorState,
      consosSector: consos,
      moduleMachineState: moduleMachineStates,
      moduleScreenState: moduleScreenStates,
      moduleMachineConso: moduleMachineConso,
      moduleScreenConso: moduleScreenConso,
    );
  }

  void startTimer(Duration duration, Function(List<SectorData>) updateSectorDataList)
  {
    timer = Timer.periodic(duration, (timer) {
      getAllSectorData().then((value) {
        updateSectorDataList(value);
      });
    });
  }

  void stopTimer()
  {
    timer?.cancel();
  }
}

class SectorData
{
  int sectorId;
  bool sectorState;
  List<double> consosSector;
  Map<String, bool> moduleMachineState;
  Map<String, bool> moduleScreenState;
  Map<String, double> moduleMachineConso;
  Map<String, double> moduleScreenConso;

  SectorData(
      {
        required this.sectorId,
        required this.sectorState,
        required this.consosSector,
        required this.moduleMachineState,
        required this.moduleScreenState,
        required this.moduleMachineConso,
        required this.moduleScreenConso,
      }
      );
}