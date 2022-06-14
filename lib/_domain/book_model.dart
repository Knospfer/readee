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
  final DateTime? returnDate;

  bool get isAvailable => copies > 0;
  ///The Database is designed to be used by only one user
  ///(there is no user table), so in this particular case
  ///there's no need for other complex checks
  bool get isAlreadyBorroedByUser => returnDate != null;

  const BookModel(
    this.id,
    this.name,
    this.author,
    this.genre,
    this.copies,
    this.returnDate,
  );

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}
