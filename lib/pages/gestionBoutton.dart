import 'package:flutter/material.dart';
import 'package:projetp4_flutter/pages/bdd.dart';

class ButtonSector {

    createButton(int numSector) {

      DataBase bdd = DataBase();

      Column(
        children: [
          Center(
              child: SizedBox(
                  width: 250,
                  height: 350,
                  child: ElevatedButton(
                      onPressed: () async {
                        bdd.getSector().then((sector){
                          print('Nombre de secteurs : $sector');
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Column(
                          children: [
                            Text('Secteur n'),
                            Text('Consommation'),
                            Text('Etat du secteur'),
                          ]
                      )
                  )
              )
          )
        ],
      )
    }

    eventButton(int numSector) {

    }
}