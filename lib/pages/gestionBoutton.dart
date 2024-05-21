import 'package:flutter/material.dart';
import 'package:projetp4_flutter/pages/bdd.dart';

class ButtonSector extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  ButtonSector({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }
  DataBase bdd = DataBase();

    createButton(int numSector)
    {
      return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            minimumSize: MaterialStateProperty.all<Size>(const Size(250, 350)),
            ),
          onPressed: () async {
            bdd.getSector().then((sector) {
              print('Nombre de secteurs : $sector');
            });
          },
          child: Text('Secteur $numSector'),
        );
    }

    eventButton(int numSector) {

    }
}