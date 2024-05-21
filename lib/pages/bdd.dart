import 'package:postgres/postgres.dart';

class DataBase {

  late Connection conn;

  Future<void> ConnectionBdD () async {
    conn = await Connection.open(Endpoint(
      host: '192.168.1.252',
      database: 'projetGestionParcInformatique',
      username: 'hmagrit',
      password: 'BjhGeq9F',
    ));
  }

  Future<int> getSector() async {
    await ConnectionBdD();
    final request = await conn.execute(
        'SELECT id_secteur FROM secteur');
    int sector=request.length;
    return sector;
  }

  Future<double> getConso(int numSector) async {
    await ConnectionBdD();
    final conso_ecran = await conn.execute(
        'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=FALSE ORDER BY date_conso_module DESC LIMIT 1'
    );

    final conso_machine = await conn.execute(
        'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=TRUE ORDER BY date_conso_module DESC LIMIT 1'
    );

    double conso = 0.0;
    if(conso_ecran.isNotEmpty) {
      conso += conso_ecran[0][0] as double;
    }

    if(conso_machine.isNotEmpty) {
      conso += conso_machine[0][0] as double;
    }
    return conso;
    }

    Future<bool> getStateSector(int numSector) async {
      bool retour=false;
      await ConnectionBdD();
      final request = await conn.execute(
          'SELECT etat_secteur FROM secteur WHERE id_secteur=$numSector'
      );
      retour=request[0][0] as bool;
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
