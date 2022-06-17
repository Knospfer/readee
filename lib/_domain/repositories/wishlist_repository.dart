import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_domain/models/book_model.dart';
import 'package:collection/collection.dart';

//TODO CODICE DUPLICATO
@lazySingleton
class WishlistRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('wishlits');

  Stream<List<BookModel>> stream() => _collection.snapshots().map(
        (event) => event.docs
            .map((e) => BookModel.fromJson(e.data() as Map<String, dynamic>))
            .toList(),
      );

  Stream<BookModel?> singleBookStream(String bookId) =>
      _collection.where("id", isEqualTo: bookId).snapshots().map(
            (event) => event.docs
                .map(
                  (e) => BookModel.fromJson(
                    e.data() as Map<String, dynamic>,
                  ),
                )
                .firstOrNull,
          );

  Stream<List<BookModel>> query(String bookName) => _collection
      .where('name', isEqualTo: bookName)
      .snapshots()
      .map(
        (event) => event.docs
            .map((e) => BookModel.fromJson(e.data() as Map<String, dynamic>))
            .toList(),
      );

  Future<void> addBook(BookModel book) => _collection.add(book.toJson());

  Future<BookModel?> getBook(String bookId) async {
    final querySnapshot = await _getSnapshot(bookId);
    if (querySnapshot == null) return null;

    final bookRaw = querySnapshot.data() as Map<String, dynamic>;
    return BookModel.fromJson(bookRaw);
  }

  Future<void> updateBook(BookModel book) =>
      _collection.doc(book.id).update(book.toJson());

  Future<void> removeBook(BookModel book) => _collection.doc(book.id).delete();

  Future<QueryDocumentSnapshot?> _getSnapshot(String bookId) async {
    final querySnapshotList =
        await _collection.where("id", isEqualTo: bookId).get();

    return querySnapshotList.docs.firstOrNull;
  }
}
