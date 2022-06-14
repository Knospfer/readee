import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_domain/models/book_model.dart';

@lazySingleton
class MyBookRepository {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('my_books');

  Future<BookModel?> getBook(String bookId) async {
    final querySnapshotList =
    await _collection.where("id", isEqualTo: bookId).get();
    final querySnapshot = querySnapshotList.docs.firstOrNull;
    if (querySnapshot == null) return null;
    final bookRaw = querySnapshot.data() as Map<String, dynamic>;

    return BookModel.fromJson(bookRaw);
  }

  Future<void> upsertBook(BookModel bookModel) async {
    final book = await getBook(bookModel.id);
    book == null ? await _addBook(bookModel) : await _updateBook(bookModel);
  }

  Future<DocumentReference> _addBook(BookModel bookModel) =>
      _collection.add(bookModel.toJson());

  Future<void> _updateBook(BookModel bookModel) =>
      _collection.doc(bookModel.id).update(bookModel.toJson());

  Future<void> removeBook(BookModel bookModel) =>
      _collection.doc(bookModel.id).delete();
}
