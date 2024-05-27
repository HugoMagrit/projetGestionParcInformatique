import 'dart:async';
import 'package:flutter/widgets.dart';

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