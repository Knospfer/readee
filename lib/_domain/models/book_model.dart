import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_model.freezed.dart';

part 'book_model.g.dart';

@JsonSerializable()
@freezed
class BookModel
    with _$BookModel {

  ///The Database is designed to be used by only one user
  ///(there is no user table), so in this particular case
  ///there's no need for other complex checks
  bool get isAlreadyBorroedByUser => date != null;

  int? get daysRemaining {
    final acutalDate = date;
    if (acutalDate == null) return null;
    final range = DateTimeRange(start: DateTime.now(), end: acutalDate);

    return range.duration.inDays;
  }

  bool get isAvailable => copies > 0;

  const factory BookModel({
    required String id,
    required String name,
    required String author,
    required String genre,
    required int copies,
    @TimestampConverter() DateTime? date,
  }) = _BookModel;

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  const BookModel._();
}

class TimestampConverter extends JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) {
    if (json == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(json.millisecondsSinceEpoch);
  }

  @override
  Timestamp? toJson(DateTime? object) {
    if (object == null) return null;

    return Timestamp.fromDate(object);
  }
}
