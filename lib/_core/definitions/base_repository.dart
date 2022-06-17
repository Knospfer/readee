import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

abstract class BaseRepository<T> {
  final String collectionName;
  final String itemNameKey;
  final String itemIdKey;
  @protected
  late final CollectionReference collection =
      FirebaseFirestore.instance.collection(collectionName);

  BaseRepository({
    required this.collectionName,
    required this.itemNameKey,
    required this.itemIdKey,
  });

  T fromJson(Map<String, dynamic> map);

  Stream<List<T>> stream() => collection.snapshots().map(
        (event) => event.docs
            .map((e) => fromJson(e.data() as Map<String, dynamic>))
            .toList(),
      );

  Stream<T?> singleItemStream(String itemId) =>
      collection.where(itemIdKey, isEqualTo: itemId).snapshots().map(
            (event) => event.docs
                .map(
                  (e) => fromJson(e.data() as Map<String, dynamic>),
                )
                .firstOrNull,
          );

  Stream<List<T>> queryBy(String itemName) =>
      collection.where(itemNameKey, isEqualTo: itemName).snapshots().map(
            (event) => event.docs
                .map((e) => fromJson(e.data() as Map<String, dynamic>))
                .toList(),
          );

  Future<void> add({required Map<String, dynamic> Function() toJson}) =>
      collection.add(toJson());

  Future<void> update({
    required String id,
    required Map<String, dynamic> Function() toJson,
  }) =>
      collection.doc(id).update(toJson());

  Future<void> remove(String id) => collection.doc(id).delete();

  Future<T?> get(String id) async {
    final querySnapshot = await getSnapshot(id);
    if (querySnapshot == null) return null;

    final bookRaw = querySnapshot.data() as Map<String, dynamic>;
    return fromJson(bookRaw);
  }

  Future<QueryDocumentSnapshot?> getSnapshot(String id) async {
    final querySnapshotList =
        await collection.where(itemIdKey, isEqualTo: id).get();

    return querySnapshotList.docs.firstOrNull;
  }
}
