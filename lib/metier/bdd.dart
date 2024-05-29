import 'package:postgres/postgres.dart';

class DataBase
{
  Future<Connection> connectionBdD () async
  {
    return await Connection.open(Endpoint(
      //host: '192.168.1.253', //Avec le routeur wifiEnergy en filaire
      //host: '192.168.1.252',
      host: '192.168.178.202',
      database: 'projetGestionParcInformatique',
      username: 'hmagrit',
      password: 'BjhGeq9F',
    ));
  }

  Future<int> getSector() async
  {
    final Connection conn = await connectionBdD();
    final request = await conn.execute(
        'SELECT id_secteur FROM secteur');
    int sector=request.length;
    await conn.close();
    print('Nombre de secteur: $sector');
    return sector;
  }

  Future<List<double>> getConso(bool time, int numSector) async
  {
    print('getConso appelé pour le secteur $numSector');
    List<double> siNULL = [-1];
    List<double> consos = [];
    final Connection conn = await connectionBdD();

    try
    {
      if (time == true && conn.isOpen)
      {
        final consoEcran = await conn.execute(
            'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=FALSE ORDER BY date_conso_module DESC LIMIT 1'
        );

        final consoMachine = await conn.execute(
            'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=TRUE ORDER BY date_conso_module DESC LIMIT 1'
        );

        consos.add(consoEcran.first[0] as double);
        consos.add(consoMachine.first[0] as double);
        consos[0] = consos[0] + consos[1];
        print('Consommation $numSector : $consos');
        return consos;
      }

      else if(conn.isOpen)
      {
        final consos = await conn.execute(
            'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=FALSE AND date_conso_module >= NOW() - INTERVAL \'24 hour\' ORDER BY date_conso_module'
        ) as List<double>;
        return consos;
      }

      else
      {
        return siNULL;
      }
    }
    catch (e)
    {
      print('Erreur lors de la récupération de la consommation du secteur $numSector: $e');
      return siNULL;
    }
    finally {
      await conn.close();
    }
  }

  Future<double> getConsoModule(int numSector, String module, String typeModule) async
  {
    final Connection conn = await connectionBdD();
    double conso = 0.0;
    if(typeModule=="machine")
    {
      final conso = await conn.execute(
          'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND module_machine_mac=$module ORDER BY date_conso_module DESC LIMIT 1'
      ) as double;
      await conn.close();
      return conso;
    }
    else if(typeModule=="ecran")
    {
      final conso = await conn.execute(
          'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND module_ecran_mac=$module ORDER BY date_conso_module DESC LIMIT 1'
      ) as double;
      await conn.close();
      return conso;
    }
    await conn.close();
    return conso;
  }

  Future<Map<String, bool>> getState(String wantedData, int numSector) async
  {
    Map<String, bool> retour = {};
    final Connection conn = await connectionBdD();
    try {
      switch (wantedData)
      {
        case "sector":
          final request = await conn.execute(
              'SELECT id_secteur, etat_secteur FROM secteur WHERE id_secteur=$numSector'
          );
          for (final row in request)
          {
            retour[row[0].toString()] = row[1] == true;
          }
          break;

        case "askedSector":
          final request = await conn.execute(
              'SELECT id_secteur, etat_demande_secteur FROM secteur WHERE id_secteur=$numSector'
          );
          for (final row in request)
          {
            retour[row[0] as String] = row[1] == 't';
          }
          break;

        case "moduleMachine":
          final request = await conn.execute(
              'SELECT etat_module_machine, mac_module_machine FROM module_machine WHERE secteur_id=$numSector'
          );
          for (final row in request)
          {
            retour[row[0] as String] = row[1] == 't';
          }
          break;

        case "moduleScreen":
          final request = await conn.execute(
              'SELECT etat_module_ecran, mac_module_ecran FROM module_ecran WHERE secteur_id=$numSector'
          );
          for (final row in request)
          {
            retour[row[0] as String] = row[1] == 't';
          }
          break;

        case "machine":
          final request = await conn.execute(
              'SELECT etat_machine, ip_machine FROM machine WHERE module_machine_mac=(SELECT mac_module_machine FROM module_machine WHERE secteur_id=$numSector);'
          );
          for (final row in request)
          {
            retour[row[0] as String] = row[1] == 't';
          }
          break;

        default:
          print('Type de donnée non reconnu : $wantedData');
          break;
      }
    }
    catch (e)
    {
      print('Erreur lors de la récupération de l\'état du secteur $numSector: $e');
    }
    finally {
      await conn.close();
    }
    return retour;
  }

  Future<Map<String, bool>> getStateMachine(String moduleMAC) async
  {
    final Connection conn = await connectionBdD();
    Map<String, bool> retour = {};
     final request = await conn.execute(
      'SELECT mac_module_machine, etat_module_machine FROM module_machine WHERE mac_module_machine=$moduleMAC'
    );
     for (final row in request)
     {
       retour[row[0] as String] = row[1] == 't';
     }
     await conn.close();
     return retour;
  }
}
