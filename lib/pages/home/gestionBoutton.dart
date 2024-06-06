import 'package:flutter/material.dart';
import 'dart:async';
import 'package:projetp4_flutter/metier/timer.dart' as timer;


class ButtonSector extends StatefulWidget {
  final timer.TimerManager timerManager;
  final int sector;
  final VoidCallback onPressed;

  const ButtonSector({
    super.key,
    required this.timerManager,
    required this.sector,
    required this.onPressed,
  });

  @override
  ButtonSectorState createState() => ButtonSectorState();
}

class ButtonSectorState extends State<ButtonSector> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    widget.timerManager.startTimer(const Duration(seconds: 300), () {
      if(mounted){
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    widget.timerManager.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),),
        ),
        minimumSize: MaterialStateProperty.all<Size>(const Size(250, 350)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Secteur ${widget.sector}', style: TextStyle(color: Colors.grey[300])),
          FutureBuilder<bool>(
            future: widget.timerManager.getStateSector(widget.sector),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Problème de base de données', style: TextStyle(color: Colors.grey[300]));
              } else {
                final state = snapshot.data!;
                return Text('État : ${state ? 'Allumé' : 'Éteint'}', style: TextStyle(color: Colors.grey[300]));
              }
            },
          ),
          FutureBuilder<double>(
            future: widget.timerManager.getConso(widget.sector),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Problème de base de données', style: TextStyle(color: Colors.grey[300]));
              } else {
                final conso = snapshot.data!;
                return Text('Consommation : ${conso}W', style: TextStyle(color: Colors.grey[300]));
              }
            },
          ),
        ],
      ),
    );
  }
}