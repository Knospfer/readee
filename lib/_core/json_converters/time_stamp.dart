import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

//TODO RENAME: DateToTimestamp 
class DateToTimestamp extends JsonConverter<DateTime?, Timestamp?> {
  const DateToTimestamp();

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
