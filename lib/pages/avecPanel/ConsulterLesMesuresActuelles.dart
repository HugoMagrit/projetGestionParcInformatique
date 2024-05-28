import 'package:projetp4_flutter/pages/bdd.dart';

class ConsulterLesMesuresActuelles {
  void consulterLesMesuresActelles() {
    final sectors=DataBase().getSector() as int;
    for(int i=1; i<=sectors; i++) {

    }
  }
}