import 'package:projetp4_flutter/metier/bdd.dart';
import 'package:projetp4_flutter/metier/bdd.dart';

class ConsulterLesMesuresActuelles {
  Future<List<SectorData>> consulterLesMesuresActelles() async {
    final sectors = DataBase().getSector() as int;
    List<SectorData> sectorDataList = [];

    for (int i = 1; i <= sectors; i++) {
      bool sectorState = (await DataBase().getState("sector", i)) as bool;
      List<double> consos = await DataBase().getConso(true, i);
      Map<String, bool> moduleMachineStates = (await DataBase().getState("moduleMachine", i));
      Map<String, bool> moduleScreenStates = (await DataBase().getState("moduleMachine", i));

      SectorData sectorData = SectorData(
        sectorId: i,
        sectorState: sectorState,
        consos: consos,
        moduleMachineState: moduleMachineStates,
        moduleScreenState: moduleScreenStates,
      );

      sectorDataList.add(sectorData);
    }

    return sectorDataList;
  }
}

class SectorData {
  int sectorId;
  bool sectorState;
  List<double> consos;
  Map<String, bool> moduleMachineState;
  Map<String, bool> moduleScreenState;

  SectorData({required this.sectorId, required this.sectorState, required this.consos, required this.moduleMachineState, required this.moduleScreenState});
}