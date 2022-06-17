import 'package:injectable/injectable.dart';
import 'package:readee/_core/definitions/base_repository.dart';
import 'package:readee/_domain/models/book_model.dart';

@lazySingleton
class BookRepository extends BaseRepository<BookModel> {
  BookRepository()
      : super(
          collectionName: "storage",
          itemIdKey: "id",
          itemNameKey: "name",
        );

  @override
  BookModel fromJson(Map<String, dynamic> map) => BookModel.fromJson(map);
}
