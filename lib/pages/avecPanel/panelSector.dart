import 'package:flutter/material.dart';

class PanelSector extends StatelessWidget {
  const PanelSector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: double.infinity,
      color: Colors.grey[300],
      child: Column(
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Container(
              color: Colors.black,
                child: Text('Selection du graphique', style: TextStyle(color: Colors.blueGrey),),
            ),
          ),

          Container(
              child: const Column(
                children: [
                  Text('Consommation des différents modules', style: TextStyle(color: Colors.blueGrey),)
                  ]
                )
              ),

          Container(
              child: Text('Activer modules machines', style: TextStyle(color: Colors.blueGrey),)
          ),

          Container(
              child: Text('Activer modules écrans', style: TextStyle(color: Colors.blueGrey),)
          ),

          Container(
              child: Text('Activer secteur', style: TextStyle(color: Colors.blueGrey),)
          ),
        ],
      ),
    );
  }
}