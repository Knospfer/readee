import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_domain/models/book_owned_model.dart';

//TODO RIMUOVI CODICE DUPLICATO
@lazySingleton
class BookOwnedRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('my_books');

  Stream<BookOwnedModel?> singleBookStream(String bookId) =>
      _collection.where("bookId", isEqualTo: bookId).snapshots().map(
            (event) => event.docs
                .map(
                  (e) => BookOwnedModel.fromJson(
                    e.data() as Map<String, dynamic>,
                  ),
                )
                .firstOrNull,
          );

  Future<BookOwnedModel?> getBook(String bookId) async {
    final querySnapshot = await _getSnapshot(bookId);
    if (querySnapshot == null) return null;

    final bookRaw = querySnapshot.data() as Map<String, dynamic>;
    return BookOwnedModel.fromJson(bookRaw);
  }

  Future<QueryDocumentSnapshot?> _getSnapshot(String bookId) async {
    final querySnapshotList =
        await _collection.where("bookId", isEqualTo: bookId).get();

    return querySnapshotList.docs.firstOrNull;
  }

  Future<int> getUserBooksNumber() async {
    final querySnapshot = await _collection.get();
    return querySnapshot.docs.length;
  }

  Future<void> addBook(BookOwnedModel book) async {
    final newDoc = await _collection.add(book.toJson());
    await updateBook(book.copyWith(id: newDoc.id));
  }

  Future<void> updateBook(BookOwnedModel book) =>
      _collection.doc(book.id).update(book.toJson());

  Future<void> removeBook(BookOwnedModel book) =>
      _collection.doc(book.id).delete();
}
