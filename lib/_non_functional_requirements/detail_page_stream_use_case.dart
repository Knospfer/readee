import 'package:injectable/injectable.dart';
import 'package:readee/_domain/entities/book_detail_entity.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/models/book_owned_model.dart';
import 'package:readee/_domain/repositories/book_repository.dart';
import 'package:readee/_domain/repositories/my_books_repository.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class DetailPageStreamUseCase {
  final BookRepository _bookRepository;
  final BookOwnedRepository _bookOwnedRepository;

  DetailPageStreamUseCase(this._bookRepository, this._bookOwnedRepository);

  Stream<BookDetailEntity> stream(String bookId) => CombineLatestStream(
        [
          _bookRepository.singleItemStream(bookId),
          _bookOwnedRepository.singleItemStream(bookId)
        ],
        (values) => BookDetailEntity(
          values.first as BookModel,
          values.last as BookOwnedModel?,
        ),
      );
}
