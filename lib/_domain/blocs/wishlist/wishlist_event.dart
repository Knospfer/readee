part of 'wishlist_bloc.dart';

@immutable
abstract class WishlistEvent {
  final BookModel bookModel;

  const WishlistEvent(this.bookModel);
}

@immutable
class Toggle extends WishlistEvent {
  const Toggle(super.bookModel);
}

@immutable
class InitStream extends WishlistEvent {
  const InitStream(super.bookModel);
}
