import 'package:flutter/foundation.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/models/book_owned_model.dart';

@immutable
class BookDetailEntity {
  final BookModel bookModel;
  final BookOwnedModel? bookOwnedModel;

  const BookDetailEntity(this.bookModel, this.bookOwnedModel);
}
