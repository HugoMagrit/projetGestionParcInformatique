import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Container(
            color: Colors.blueGrey,
            height: 150,
            width: 10000,
            child: const Center(
            child: Text('Les pages', textWidthBasis: TextWidthBasis.parent, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),

          Container(
            color: Colors.black,
            height: 465,
            width: 10000,
            child: const Center(
              child: Text('Etats des secteurs', textWidthBasis: TextWidthBasis.parent, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),

          Container(
            color: Colors.grey,
            height: 125,
            width: 10000,
            child: const Center(
              child: Text('Les logs', textWidthBasis: TextWidthBasis.parent, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          )

        ],
      )
    );
  }
}