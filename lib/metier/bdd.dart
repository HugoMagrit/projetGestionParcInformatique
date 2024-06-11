import 'package:postgres/postgres.dart';

// Classe pour la gestion de la base de données
class DataBase
{

  // Connexion à la base de données
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

  // Récupère le nombre de secteurs
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

  // Récupère la consommation en fonction du secteur et si on veut instantané ou sur 24h
  Future<List<double>> getConso(bool time, int numSector) async
  {
    List<double> siNULL = [-1];
    List<double> consos = [];
    final Connection conn = await connectionBdD();

    try
    {
      if (time == true)
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
        return consos;
      }

      else
      {
        final consos = await conn.execute(
            'SELECT conso_module FROM mesures WHERE secteur_id=$numSector AND type_module=FALSE AND date_conso_module >= NOW() - INTERVAL \'24 hour\' ORDER BY date_conso_module'
        ) as List<double>;
        return consos;
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

  // Récupère la consommation des modules
  Future<Map<String, double>> getConsoModule(int numSector, bool time, String module, String typeModule) async
  {
    final Connection conn = await connectionBdD();
    Map<String, double> conso = {};
    Map<String, double> siNULL = {module: -1};
    try
    {
      if (time)
      {
        if (typeModule == "machine")
        {
          final request = await conn.execute(
              'SELECT module_machine_mac, conso_module FROM mesures '
                  'WHERE secteur_id=$numSector AND module_machine_mac=\'$module\' ORDER BY date_conso_module DESC LIMIT 1'
          );
          for (final row in request)
          {
            if(row[1] != null)
            {
              conso[row[0] as String] = row[1] as double;
            }
            else
            {
              return siNULL;
            }
          }
        }
        else if (typeModule == "ecran")
        {
          final request = await conn.execute(
              'SELECT module_ecran_mac, conso_module FROM mesures '
                  'WHERE secteur_id=$numSector AND module_ecran_mac=\'$module\' ORDER BY date_conso_module DESC LIMIT 1'
          );
          for (final row in request)
          {
            if(row[1] != null)
            {
              conso[row[0] as String] = row[1] as double;
            }
            else
            {
              return siNULL;
            }
          }
        }
        else
        {
          return {};
        }
      }
      else
      {
        // Logique pour la récupération des consommations non instantanées
      }
    }
    catch (e)
    {
      print('Erreur lors de la récupération de la consommation du module $module: $e');
      return siNULL;
    }
    finally
    {
      await conn.close();
    }
    return conso;
  }

  // Récupère les états en fonction de ce qu'on veut
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
            retour[row[0].toString()] = row[1] == true;
          }
          break;

        case "moduleMachine":
          final request = await conn.execute(
              'SELECT mac_module_machine, etat_module_machine FROM module_machine WHERE secteur_id=$numSector'
          );
          for (final row in request)
          {
            retour[row[0].toString()] = row[1] == true;
          }
          break;

        case "moduleScreen":
          final request = await conn.execute(
              'SELECT mac_module_ecran, etat_module_ecran FROM module_ecran WHERE secteur_id=$numSector'
          );
          for (final row in request)
          {
            retour[row[0].toString()] = row[1] == true;
          }
          break;

        case "machine":
          final request = await conn.execute(
              'SELECT ip_machine, etat_machine FROM machine WHERE module_machine_mac=(SELECT mac_module_machine FROM module_machine WHERE secteur_id=$numSector);'
          );
          for (final row in request)
          {
            retour[row[0].toString()] = row[1] == true;
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

  // Récupère l'état des machines reliées à un même module machine
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

  Future<void> updateState(int secteur_n, bool etat, String nom_etat) async
  {
    final Connection conn = await connectionBdD();
    await conn.execute(
      'UPDATE secteur SET etat_demande_secteur=$etat WHERE id_secteur=$secteur_n'
    );
  }
}
