// In: lib/core/utils/shake_detector.dart

import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';


class ShakeDetector {
  final void Function() onPhoneShake;
  
  /// The g-force strength required to register a shake. Higher is less sensitive.
  final double shakeThreshold;

  /// The total time window in which all shakes must occur.
  final int shakeWindowMS;
  
  /// The number of shakes required to trigger the action.
  final int requiredShakes;
  
  /// The minimum time that must pass between each shake to filter out jitter.
  final int minTimeBetweenShakesMS;

  StreamSubscription? _subscription;

  int _shakeCount = 0;
  DateTime? _firstShakeTime;
  
  /// Tracks the timestamp of the last valid shake to prevent jitter.
  DateTime? _lastShakeTimestamp;

  ShakeDetector({
    required this.onPhoneShake,
    this.shakeThreshold = 18.0,       // SIGNIFICANTLY INCREASED: Requires a more forceful shake.
    this.shakeWindowMS = 3000,        // Window is now 3 seconds.
    this.requiredShakes = 3,          // Requires 3 distinct shakes.
    this.minTimeBetweenShakesMS = 500, // CRITICAL: A 0.5-second pause is required between each shake.
  });

  void startListening() {
    _subscription = accelerometerEvents.listen((event) {
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      // 1. Check if the force exceeds our high threshold
      if (acceleration > shakeThreshold) {
        final now = DateTime.now();

        // 2. DEBOUNCE: Check if enough time has passed since the LAST registered shake.
        // This is the most important change to prevent a "half shake" from counting multiple times.
        if (_lastShakeTimestamp != null &&
            now.difference(_lastShakeTimestamp!) < Duration(milliseconds: minTimeBetweenShakesMS)) {
          return; // Ignore this event, it's too close to the last one (it's just jitter).
        }
        
        _lastShakeTimestamp = now;

        // 3. Check if this is the first shake or if the window has expired.
        if (_firstShakeTime == null ||
            now.difference(_firstShakeTime!) > Duration(milliseconds: shakeWindowMS)) {
          // If so, start a new shake sequence.
          _firstShakeTime = now;
          _shakeCount = 1;
          return;
        }
        
        // If we're here, it's a valid shake within the time window. Increment the count.
        _shakeCount++;
        
        // 4. Check if the required number of shakes has been met.
        if (_shakeCount >= requiredShakes) {
          onPhoneShake(); // <-- TRIGGER THE ACTION!
          _resetShake();    // Reset everything to prevent immediate re-triggering.
        }
      }
    });
  }

  /// Helper method to reset the entire shake detection state.
  void _resetShake() {
    _firstShakeTime = null;
    _lastShakeTimestamp = null;
    _shakeCount = 0;
  }

  void stopListening() {
    _subscription?.cancel();
    _resetShake(); // Also reset state when we stop listening.
  }
}