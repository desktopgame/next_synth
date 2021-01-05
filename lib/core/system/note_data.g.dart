// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteData _$NoteDataFromJson(Map json) {
  return NoteData()
    ..keyIndex = json['keyIndex'] as int
    ..measureIndex = json['measureIndex'] as int
    ..beatIndex = json['beatIndex'] as int
    ..offset = json['offset'] as int
    ..length = (json['length'] as num)?.toDouble();
}

Map<String, dynamic> _$NoteDataToJson(NoteData instance) => <String, dynamic>{
      'keyIndex': instance.keyIndex,
      'measureIndex': instance.measureIndex,
      'beatIndex': instance.beatIndex,
      'offset': instance.offset,
      'length': instance.length,
    };
