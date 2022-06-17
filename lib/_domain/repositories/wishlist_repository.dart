import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:readee/_core/definitions/base_repository.dart';
import 'package:readee/_domain/models/book_model.dart';

@lazySingleton
class WishlistRepository extends BaseRepository<BookModel> {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('wishlist');

  WishlistRepository()
      : super(
          collectionName: "wishlist",
          itemNameKey: "name",
          itemIdKey: "id",
        );

  Future<void> removeItemFrom(BookModel book) async {
    final actualBook = await getSnapshot(book.id);
    _collection.doc(actualBook?.id).delete();
  }

  Future<void> updateIfExisting(BookModel book) async {
    final actualBook = await getSnapshot(book.id);
    if (actualBook == null) return;

    _collection.doc(actualBook.id).update(book.toJson());
  }

  @override
  BookModel fromJson(Map<String, dynamic> map) => BookModel.fromJson(map);
}
