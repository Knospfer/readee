import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:readee/_core/json_converters/time_stamp.dart';

part 'book_model.freezed.dart';

part 'book_model.g.dart';

@freezed
class BookModel with _$BookModel {
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
    @Default(false) owned,
    @DateToTimestamp() DateTime? date,
  }) = _BookModel;

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  const BookModel._();
}
