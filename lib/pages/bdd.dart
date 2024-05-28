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

  Future<double> getConso(int numSector) async {
    await connectionBdD();
    double conso = 0.0;
      final consoEcran = await conn.execute(
          'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=FALSE ORDER BY date_conso_module DESC LIMIT 1'
      );

      final consoMachine = await conn.execute(
          'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=TRUE ORDER BY date_conso_module DESC LIMIT 1'
      );

      if (consoEcran.isNotEmpty) {
        conso += consoEcran[0][0] as double;
      }

      if (consoMachine.isNotEmpty) {
        conso += consoMachine[0][0] as double;
      }
      return conso;
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

  Future<bool> getStateSector(int numSector) async {
    bool retour=false;
    await connectionBdD();
    final request = await conn.execute(
        'SELECT etat_secteur FROM secteur WHERE id_secteur=$numSector'
    );
    retour=request[0][0] as bool;
    return retour;
  }
}
