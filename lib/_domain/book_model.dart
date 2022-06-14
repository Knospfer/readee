import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_model.g.dart';

//TODO FREEZED COPY WITH
@immutable
@JsonSerializable()
class BookModel {
  final String id;
  final String name;
  final String author;
  final String genre;
  final int copies;
  @TimestampConverter()
  final DateTime? date;

  bool get isAvailable => copies > 0;

  ///The Database is designed to be used by only one user
  ///(there is no user table), so in this particular case
  ///there's no need for other complex checks
  bool get isAlreadyBorroedByUser => date != null;

  int? get daysRemaining {
    final acutalDate = date;
    if(acutalDate == null) return null;

    final range = DateTimeRange(start: DateTime.now(), end: acutalDate);

    return range.duration.inDays;
  }

  const BookModel(
    this.id,
    this.name,
    this.author,
    this.genre,
    this.copies,
    this.date,
  );

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);
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
