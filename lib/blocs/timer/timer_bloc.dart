import 'dart:async';
import 'package:flutter_timer/blocs/timer/timer.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_timer/ticker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;

  // TimerBloc to start off in the Ready state with a preset duration of 1 minute (60 seconds)
  final int _duration = 60;

  StreamSubscription<int> _tickerSubscription;

  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker;

  @override
  TimerState get initialState => Ready(_duration);

  @override
  void onTransition(Transition<TimerEvent, TimerState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  // Every time a Tick event is received, if the tick’s duration is greater than 0, we need to push an updated Running state with the new duration.
  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is Start) {
      yield* _mapStartToState(event);
    } else if (event is Pause) {
      yield* _mapPauseToState(event);
    } else if (event is Resume) {
      yield* _mapResumeToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState(event);
    } else if (event is Tick) {
      yield* _mapTickToState(event);
    }
  }

  // If there was already an open _tickerSubscription we need to cancel it to deallocate the memory
  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }

  // If the TimerBloc receives a Start event, it pushes a Running state with the start duration
  Stream<TimerState> _mapStartToState(Start start) async* {
    yield Running(start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: start.duration).listen(
      (duration) {
        dispatch(Tick(duration: duration));
      },
    );
  }

  Stream<TimerState> _mapPauseToState(Pause pause) async* {
    final state = currentState;
    if (state is Running) {
      _tickerSubscription?.pause();
      yield Paused(state.duration);
    }
  }

  // The Resume event handler is very similar to the Pause event handler. If the TimerBloc has a currentState of Paused and it receives a Resume event, then it resumes the _tickerSubscription and pushes a Running state with the current duration.
  Stream<TimerState> _mapResumeToState(Resume pause) async* {
    final state = currentState;
    if (state is Paused) {
      _tickerSubscription?.resume();
      yield Running(state.duration);
    }
  }

  // If the TimerBloc receives a Reset event, it needs to cancel the current _tickerSubscription so that it isn’t notified of any additional ticks and pushes a Ready state with the original duration
  Stream<TimerState> _mapResetToState(Reset reset) async* {
    _tickerSubscription?.cancel();
    yield Ready(_duration);
  }

  Stream<TimerState> _mapTickToState(Tick tick) async* {
    yield tick.duration > 0 ? Running(tick.duration) : Finished();
  }
}