import 'package:injectable/injectable.dart';
import 'package:readee/_core/definitions/base_repository.dart';
import 'package:readee/_domain/models/book_owned_model.dart';

//TODO RIMUOVI CODICE DUPLICATO
@lazySingleton
class BookOwnedRepository extends BaseRepository {
  BookOwnedRepository()
      : super(
    collectionName: "my_books",
    itemNameKey: "bookId",
    itemIdKey: "bookId",
  );

  @override
  fromJson(Map<String, dynamic> map) => BookOwnedModel.fromJson(map);

  Future<int> getUserBooksNumber() async {
    final querySnapshot = await collection.get();
    return querySnapshot.docs.length;
  }

  Future<void> addModelWithId(BookOwnedModel book) async {
    final newDoc = await collection.add(book.toJson());
    final newBook = book.copyWith(id: newDoc.id);
    await update(id: newBook.id, toJson: newBook.toJson);
  }
}
