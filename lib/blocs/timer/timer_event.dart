import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Our TimerBloc will need to know how to process the following events:
@immutable
abstract class TimerEvent extends Equatable {
  TimerEvent([List props = const []]) : super(props);
}

// Start — informs the TimerBloc that the timer should be started.
class Start extends TimerEvent {
  final int duration;

  Start({@required this.duration}) : super([duration]);

  @override
  String toString() => "Start { duration: $duration }";
}

// Pause — informs the TimerBloc that the timer should be paused.
class Pause extends TimerEvent {
  @override
  String toString() => "Pause";
}

// Resume — informs the TimerBloc that the timer should be resumed.
class Resume extends TimerEvent {
  @override
  String toString() => "Resume";
}

// Reset — informs the TimerBloc that the timer should be reset to the original state.
class Reset extends TimerEvent {
  @override
  String toString() => "Reset";
}

// Tick — informs the TimerBloc that a tick has occurred and that it needs to update its state accordingly.
class Tick extends TimerEvent {
  final int duration;

  Tick({@required this.duration}) : super([duration]);

  @override
  String toString() => "Tick { duration: $duration }";
}