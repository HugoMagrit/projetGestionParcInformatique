import 'package:postgres/postgres.dart';

class DataBase {

/*try {
    final results = await conn.execute('SELECT mac_module_machine FROM module_machine WHERE secteur_id=1');
    for(int i=0; i<results.length; i++) {
      print(results);
    }

  } catch (e) {
    print('Error: $e');
  } finally {
    await conn.close();
  }
}*/

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

  Future<int> getSector() async {
    final conn = await Connection.open(Endpoint(
      host: '192.168.1.252',
      database: 'projetGestionParcInformatique',
      username: 'hmagrit',
      password: 'BjhGeq9F',
    )
    );
    final results = await conn.execute(
        'SELECT id_secteur FROM secteur');
    int sector=results.length;
    return sector;
  }
}