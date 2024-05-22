import 'package:postgres/postgres.dart';

class DataBase {
  late Connection conn;

  Future<void> connectionBdD () async {
    conn = await Connection.open(Endpoint(
      host: '192.168.1.252',
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
    conn.closed;
    return sector;
  }

  Future<double> getConso(int numSector) async {
    await connectionBdD();
    final consoEcran = await conn.execute(
        'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=FALSE ORDER BY date_conso_module DESC LIMIT 1'
    );

    final consoMachine = await conn.execute(
        'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=TRUE ORDER BY date_conso_module DESC LIMIT 1'
    );

    double conso = 0.0;
    if(consoEcran.isNotEmpty) {
      conso += consoEcran[0][0] as double;
    }

    if(consoMachine.isNotEmpty) {
      conso += consoMachine[0][0] as double;
    }
    conn.closed;
    return conso;
    }

    Future<bool> getStateSector(int numSector) async {
      bool retour=false;
      await connectionBdD();
      final request = await conn.execute(
          'SELECT etat_secteur FROM secteur WHERE id_secteur=$numSector'
      );
      retour=request[0][0] as bool;
      conn.closed;
      return retour;
    }

/*getBackground() async {
    final conn = await Connection.open(Endpoint(
      host: '192.168.1.252', //IP partage de connexion 192.168.178.202
      database: 'projetGestionParcInformatique',
      username: 'hmagrit',
      password: 'BjhGeq9F',
    )
    );
    final results = await conn.execute(
        'SELECT plan_locaux.data_plan FROM plan_locaux WHERE id_plan=1');
  }*/

}
