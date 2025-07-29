// In: lib/core/utils/shake_detector.dart

import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector {
  final void Function() onPhoneShake;
  final double shakeThreshold;

  // Time window in milliseconds to detect the second shake.
  final int doubleShakeWindow;

  StreamSubscription? _subscription;

  // New variables for double shake logic
  int _shakeCount = 0;
  DateTime? _firstShakeTime;

  ShakeDetector({
    required this.onPhoneShake,
    this.shakeThreshold = 13.0, // Increased threshold slightly for better accuracy
    this.doubleShakeWindow = 1500, // User has 1.5 seconds to perform the second shake
  });

  void startListening() {
    _subscription = accelerometerEvents.listen((event) {
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      // Check if the force exceeds our threshold
      if (acceleration > shakeThreshold) {
        final now = DateTime.now();

        // Check if this is the first shake in a new sequence
        if (_firstShakeTime == null) {
          _firstShakeTime = now;
          _shakeCount = 1;
        } else {
          // Check if the new shake is within the time window of the first shake
          if (now.difference(_firstShakeTime!) <
              Duration(milliseconds: doubleShakeWindow)) {
            _shakeCount++;
            // If this is the second shake, trigger the callback and reset
            if (_shakeCount >= 2) {
              onPhoneShake(); // <-- THIS IS THE ACTION!
              _resetShake();
            }
          } else {
            // If too much time has passed, treat this as the first shake of a new sequence
            _firstShakeTime = now;
            _shakeCount = 1;
          }
        }
      }
    });
  }

  // Helper method to reset the shake detection state
  void _resetShake() {
    _firstShakeTime = null;
    _shakeCount = 0;
  }

  void stopListening() {
    _subscription?.cancel();
  }
}