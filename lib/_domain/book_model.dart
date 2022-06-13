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
