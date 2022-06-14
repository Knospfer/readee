import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:readee/_domain/models/book_owned_model.dart';

@lazySingleton
class BookOwnedRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('my_books');

  Stream<BookOwnedModel?> stream(String bookId) =>
      _collection.where("bookId", isEqualTo: bookId).snapshots().map(
            (event) => event.docs
                .map((e) => BookOwnedModel.fromJson(e.data() as Map<String, dynamic>))
                .firstOrNull,
          );

  Future<BookOwnedModel?> getBook(String bookId) async {
    final querySnapshot = await _getSnapshow(bookId);
    if (querySnapshot == null) return null;

    final bookRaw = querySnapshot.data() as Map<String, dynamic>;
    return BookOwnedModel.fromJson(bookRaw);
  }

  Future<QueryDocumentSnapshot?> _getSnapshow(String bookId) async {
    final querySnapshotList =
        await _collection.where("bookId", isEqualTo: bookId).get();

    return querySnapshotList.docs.firstOrNull;
  }

  Future<void> addBook(BookModel book) async {
    final newDoc = await _collection.add({});
    await updateBook(
      BookOwnedModel(
        id: newDoc.id,
        bookId: book.id,
        date: DateTime.now().add(const Duration(days: 14)),
      ),
    );
  }

  Future<void> updateBook(BookOwnedModel book) =>
      _collection.doc(book.id).update(book.toJson());

  Future<void> removeBook(BookOwnedModel book) =>
      _collection.doc(book.id).delete();
}
