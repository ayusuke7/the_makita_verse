import 'dart:async';

import 'package:flutter/foundation.dart';

import 'base_state.dart';

abstract class BaseViewModel<T extends BaseState>
    implements ValueListenable<T> {
  late final ValueNotifier<T> _stateNotifier;

  T get state => _stateNotifier.value;

  @override
  T get value => _stateNotifier.value;

  BaseViewModel(T initialState) {
    _stateNotifier = ValueNotifier<T>(initialState);
    initController();
  }

  @mustCallSuper
  void initController() {}

  Stream<T> asStream() {
    late StreamController<T> controller;

    void listen() {
      controller.add(_stateNotifier.value);
    }

    controller = StreamController<T>(
      onListen: () {
        _stateNotifier.addListener(listen);
      },
      onCancel: () {
        _stateNotifier.removeListener(listen);
      },
    );

    return controller.stream;
  }

  @override
  void addListener(VoidCallback listener) {
    _stateNotifier.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _stateNotifier.removeListener(listener);
  }

  void emit(T newState) {
    middleware(newState);
  }

  void _emit(T newState) {
    _stateNotifier.value = newState;
  }

  @protected
  void middleware(T newState) {
    _emit(newState);
  }

  void dispose() {
    _stateNotifier.dispose();
  }
}
