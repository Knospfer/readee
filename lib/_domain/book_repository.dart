import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_domain/book_model.dart';

@lazySingleton
class BookRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('storage');

  Stream<List<BookModel>> stream() => _collection.snapshots().map(
        (event) => event.docs
            .map((e) => BookModel.fromJson(e.data() as Map<String, dynamic>))
            .toList(),
      );

  Future<DocumentReference> addBook(BookModel bookModel) =>
      _collection.add(bookModel.toJson());

  Future<void> updateBook(BookModel bookModel) =>
      _collection.doc(bookModel.id).update(bookModel.toJson());
}
