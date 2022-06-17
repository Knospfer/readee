import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:readee/_core/json_converters/time_stamp.dart';

part 'book_owned_model.freezed.dart';

part 'book_owned_model.g.dart';

@freezed
class BookOwnedModel with _$BookOwnedModel {
  const factory BookOwnedModel({
    required String id,
    required String bookId,
    @DateToTimestamp() DateTime? date,
  }) = _BookOwnedModel;

  int get daysRemaining {
    final actualDate = date;
    if (actualDate == null) return 0;

    final range = DateTimeRange(start: DateTime.now(), end: actualDate);

    return range.duration.inDays;
  }

  factory BookOwnedModel.fromJson(Map<String, dynamic> json) =>
      _$BookOwnedModelFromJson(json);

  const BookOwnedModel._();
}
