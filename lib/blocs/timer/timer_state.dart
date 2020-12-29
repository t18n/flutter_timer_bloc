import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// The TimerStates which our TimerBloc can be in.
@immutable
abstract class TimerState extends Equatable {
  final int duration;

  TimerState(this.duration, [List props = const []])
      : super([duration]..addAll(props));
}

// Ready —ready to start counting down from the specified duration.
class Ready extends TimerState {
  Ready(int duration) : super(duration);

  @override
  String toString() => 'Ready { duration: $duration }';
}

// Running — actively counting down from the specified duration
class Paused extends TimerState {
  Paused(int duration) : super(duration);

  @override
  String toString() => 'Paused { duration: $duration }';
}

// Paused — paused at some remaining duration
class Running extends TimerState {
  Running(int duration) : super(duration);

  @override
  String toString() => 'Running { duration: $duration }';
}

// Finished — completed with a remaining duration of 0
class Finished extends TimerState {
  Finished() : super(0);

  @override
  String toString() => 'Finished';
}