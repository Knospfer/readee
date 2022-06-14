part of 'books_bloc.dart';

@immutable
abstract class BlocState {
  const BlocState();
}

class Initial extends BlocState {}

class ActionPerformed extends BlocState {}

class Loading extends BlocState {}

class ErrorReceived extends BlocState {}

class Loaded extends BlocState {
  final BookDetailEntity entity;

  const Loaded(this.entity);
}

@immutable
class BookOwnershipChecked extends BlocState {
  final BookOwnedModel? book;

  const BookOwnershipChecked(this.book);
}
