part of 'books_bloc.dart';

@immutable
abstract class BlocState {}

class Initial extends BlocState {}

class ActionPerformed extends BlocState {}

class Loading extends BlocState {}

class ErrorReceived extends BlocState {}
