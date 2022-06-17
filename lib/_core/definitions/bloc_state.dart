import 'package:flutter/foundation.dart';

@immutable
abstract class BlocState<T> {
  const BlocState();
}

class Initial<T> extends BlocState<T> {}

class ActionPerformed<T> extends BlocState<T> {}

class Loading<T> extends BlocState<T> {}

class ErrorReceived<T> extends BlocState<T> {
  final String error;

  const ErrorReceived(this.error);
}

class Loaded<T> extends BlocState<T> {
  final T data;

  const Loaded(this.data);
}