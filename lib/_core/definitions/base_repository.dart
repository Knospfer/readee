import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

abstract class BaseRepository<T> {
  final String collectionName;
  final String itemNameKey;
  final String itemIdKey;
  late final CollectionReference _collection =
      FirebaseFirestore.instance.collection(collectionName);

  BaseRepository({
    required this.collectionName,
    required this.itemNameKey,
    required this.itemIdKey,
  });

  T fromJson(Map<String, dynamic> map);

  Stream<List<T>> stream() => _collection.snapshots().map(
        (event) => event.docs
            .map((e) => fromJson(e.data() as Map<String, dynamic>))
            .toList(),
      );

  Stream<T?> singleItemStream(String itemId) =>
      _collection.where(itemIdKey, isEqualTo: itemId).snapshots().map(
            (event) => event.docs
                .map(
                  (e) => fromJson(e.data() as Map<String, dynamic>),
                )
                .firstOrNull,
          );

  Stream<List<T>> queryBy(String itemName) =>
      _collection.where(itemNameKey, isEqualTo: itemName).snapshots().map(
            (event) => event.docs
                .map((e) => fromJson(e.data() as Map<String, dynamic>))
                .toList(),
          );

  Future<void> add({required Map<String, dynamic> Function() toJson}) =>
      _collection.add(toJson());

  Future<void> update({
    required String id,
    required Map<String, dynamic> Function() toJson,
  }) =>
      _collection.doc(id).update(toJson());

  Future<void> removeBook(String id) => _collection.doc(id).delete();

  Future<T?> get(String id) async {
    final querySnapshot = await _getSnapshot(id);
    if (querySnapshot == null) return null;

    final bookRaw = querySnapshot.data() as Map<String, dynamic>;
    return fromJson(bookRaw);
  }

  Future<QueryDocumentSnapshot?> _getSnapshot(String id) async {
    final querySnapshotList =
        await _collection.where(itemIdKey, isEqualTo: id).get();

    return querySnapshotList.docs.firstOrNull;
  }
}
