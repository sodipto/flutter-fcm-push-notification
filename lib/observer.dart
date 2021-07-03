 import 'dart:async';

class Bloc {
  /// Stream controller
  final _streamController = StreamController<Object>.broadcast();

  /// Object sink (send objects here)
  void sink(Object value) => _streamController.add(value);

  /// Object stream (listenable for objects)
  Stream<Object> get stream => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}