import 'package:flutter/material.dart';
import 'dart:async';

import 'package:projetp4_flutter/pages/home/home.dart';

class ButtonSector extends StatefulWidget {
  final TimerManager timerManager;
  final int sector;
  final VoidCallback onPressed;

  const ButtonSector({
    super.key,
    required this.timerManager,
    required this.sector,
    required this.onPressed,
  });

  @override
  _ButtonSectorState createState() => _ButtonSectorState();
}

class _ButtonSectorState extends State<ButtonSector> {
  late double _conso;
  late bool _state;

  @override
  void initState() {
    super.initState();
    _conso = 0;
    _state = false;
    widget.timerManager.startTimer(const Duration(seconds: 60), () {
      setState(() {});
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
      onPressed: widget.onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),),
        ),
        minimumSize: MaterialStateProperty.all<Size>(const Size(250, 350)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Secteur ${widget.sector}'),
          FutureBuilder<bool>(
            future: widget.timerManager.getStateSector(widget.sector),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                final state = snapshot.data;
                if(state != null) {
                  _state = state;
                  return Text('État : ${_state ? 'Allumé' : 'Éteint'}');
                }
                else {
                  return const Text('Problème lié à la base de données');
                }
              }
            },
          ),
          FutureBuilder<double>(
            future: widget.timerManager.getConso(widget.sector),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                final conso = snapshot.data;
                if (conso != null) {
                  _conso = conso;
                  return Text('Consommation : ${_conso}W');
                }
                else
                  {
                    return const Text('Problème lié à la base de données');
                  }
              }
            },
          ),
        ],
      ),
    );
  }
}

class TimerManager {
  final int id;
  final Future<double> Function(int) getConso;
  final Future<bool> Function(int) getStateSector;
  Timer? _timer;

  TimerManager({
    required this.id,
    required this.getConso,
    required this.getStateSector,
  });

  void startTimer(Duration duration, VoidCallback callback) {
    _timer = Timer.periodic(duration, (timer) {
      callback();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}