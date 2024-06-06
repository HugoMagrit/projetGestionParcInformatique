import 'dart:async';
import 'package:flutter/widgets.dart';

// Classe qui gère le timer
class TimerManager
{
  Timer? _timer;

  void startTimer(Duration duration, VoidCallback callback)
  {
    _timer = Timer.periodic(duration, (timer)
    {
      callback();
    }
    );
  }

  void stopTimer()
  {
    _timer?.cancel();
    _timer = null;
  }
}