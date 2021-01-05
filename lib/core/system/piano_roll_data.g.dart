// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piano_roll_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PianoRollData _$PianoRollDataFromJson(Map json) {
  return PianoRollData()
    ..keyCount = json['keyCount'] as int
    ..measureCount = json['measureCount'] as int
    ..beatCount = json['beatCount'] as int
    ..notes = (json['notes'] as List)
        ?.map((e) => e == null ? null : NoteData.fromJson(e as Map))
        ?.toList();
}

Map<String, dynamic> _$PianoRollDataToJson(PianoRollData instance) =>
    <String, dynamic>{
      'keyCount': instance.keyCount,
      'measureCount': instance.measureCount,
      'beatCount': instance.beatCount,
      'notes': instance.notes,
    };
