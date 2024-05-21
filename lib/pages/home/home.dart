import 'package:flutter/material.dart';
import 'package:projetp4_flutter/pages/bdd.dart';
import 'package:projetp4_flutter/pages/gestionBoutton.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    DataBase bdd = DataBase();
    return Scaffold(
      body: Column(
        children: [

          Container(
            color: Colors.blueGrey,
            height: 150,
            width: 9000,
            child: const Center(
            child: Text('Les pages'),

            ),
          ),

          SizedBox(
            height: 465,
            width: 1280,
            child: Stack(
              children: <Widget>[
                Image.asset('assets/Images/planSalle.png'),

                    Positioned(
                        top: 20,
                        left: 20,
                        child: ButtonSector(
                          onPressed: () {
                          },
                          child: const Text('Fluttering Button'),
                        ).createButton(1),

                            ),
                          ],
                        )
                    ),

          Container(
            color: Colors.grey,
            height: 125,
            width: 10000,
            child: const Center(
              child: Text('Les logs', textWidthBasis: TextWidthBasis.parent, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ),
      ]
      )
      );
  }
}