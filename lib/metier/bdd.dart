import 'package:postgres/postgres.dart';

class DataBase {
  late Connection conn;

  Future<void> connectionBdD () async {
    conn = await Connection.open(Endpoint(
      //host: '192.168.1.253', //Avec le routeur wifiEnergy en filaire
      //host: '192.168.1.252',
      host: '192.168.178.202',
      database: 'projetGestionParcInformatique',
      username: 'hmagrit',
      password: 'BjhGeq9F',
    ));
  }

  Future<int> getSector() async {
    await connectionBdD();
    final request = await conn.execute(
        'SELECT id_secteur FROM secteur');
    int sector=request.length;
    return sector;
  }

  Future<List<double>> getConso(bool time,int numSector) async {
    await connectionBdD();
    List<double> consos = [];
    if(time==true) {
      final consoEcran = await conn.execute(
          'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=FALSE ORDER BY date_conso_module DESC LIMIT 1'
      );

      final consoMachine = await conn.execute(
          'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=TRUE ORDER BY date_conso_module DESC LIMIT 1'
      );

      if (consoEcran.isNotEmpty) {
        consos += consoEcran[0][0] as List<double>;
      }

      if (consoMachine.isNotEmpty) {
        consos += consoMachine[0][0] as List<double>;
      }
    }
    else {
      return consos = await conn.execute(
        'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=FALSE AND date_conso_module >= NOW() - INTERVAL \'24 hour\' ORDER BY date_conso_module'
      ) as List<double>;
    }
      return consos;
  }

  Future<double> getConsoModule(int numSector, String module, String typeModule) async {
    await connectionBdD();
    double conso = 0.0;
    if(typeModule=="machine") {
      return conso = await conn.execute(
          'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND module_machine_mac=$module ORDER BY date_conso_module DESC LIMIT 1'
      ) as double;
    }
    else if(typeModule=="ecran") {
      return conso = await conn.execute(
          'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND module_ecran_mac=$module ORDER BY date_conso_module DESC LIMIT 1'
      ) as double;
    }
    return conso;
  }

  Future<Map<String, bool>> getState(String wantedData, int numSector) async {
    Map<String, bool> retour = {};
    await connectionBdD();
    switch(wantedData) {
      case "sector":
        final request = await conn.execute(
            'SELECT id_secteur, etat_secteur FROM secteur WHERE id_secteur=$numSector'
        );
        for (final row in request) {
          retour[row[0] as String] = row[1] == 't';
        }

      case "askedSector":
        final request = await conn.execute(
            'SELECT id_secteur, etat_demande_secteur FROM secteur WHERE id_secteur=$numSector'
        );
        for (final row in request) {
          retour[row[0] as String] = row[1] == 't';
        }

      case "moduleMachine":
        final request = await conn.execute(
            'SELECT etat_module_machine, mac_module_machine FROM module_machine WHERE secteur_id=$numSector'
        );
        for (final row in request) {
          retour[row[0] as String] = row[1] == 't';
        }

      case "moduleScreen":
        final request = await conn.execute(
            'SELECT etat_module_ecran, mac_module_ecran FROM module_ecran WHERE secteur_id=$numSector'
        );
        for (final row in request) {
          retour[row[0] as String] = row[1] == 't';
        }

      case "machine":
        final request = await conn.execute(
            'SELECT etat_machine, ip_machine FROM machine WHERE module_machine_mac=(SELECT mac_module_machine FROM module_machine WHERE secteur_id=$numSector);'
        );
        for (final row in request) {
          retour[row[0] as String] = row[1] == 't';
        }
    }
    return retour;
  }

  Future<Map<String, bool>> getStateMachine(String moduleMAC) async {
    Map<String, bool> retour = {};
     final request = await conn.execute(
      'SELECT mac_module_machine, etat_module_machine FROM module_machine WHERE mac_module_machine=$moduleMAC'
    );
     for (final row in request) {
       retour[row[0] as String] = row[1] == 't';
     }
     return retour;
  }
}
