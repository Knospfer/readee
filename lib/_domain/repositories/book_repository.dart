import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_domain/models/book_model.dart';

@lazySingleton
class BookRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('storage');

  Stream<List<BookModel>> stream() => _collection.snapshots().map(
        (event) => event.docs
            .map((e) => BookModel.fromJson(e.data() as Map<String, dynamic>))
            .toList(),
      );

  Stream<List<BookModel>> query(String bookName) => _collection
      .where('name', isEqualTo: bookName)
      .snapshots()
      .map(
        (event) => event.docs
            .map((e) => BookModel.fromJson(e.data() as Map<String, dynamic>))
            .toList(),
      );

  Stream<BookModel?> singleBookStream(String bookId) => _collection
      .where("id", isEqualTo: bookId)
      .snapshots()
      .map(
        (event) => event.docs
            .map((e) => BookModel.fromJson(e.data() as Map<String, dynamic>))
            .firstOrNull,
      );

  Future<DocumentReference> addBook(BookModel bookModel) =>
      _collection.add(bookModel.toJson());

  Future<void> updateBook(BookModel bookModel) =>
      _collection.doc(bookModel.id).update(bookModel.toJson());
}
