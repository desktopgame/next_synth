// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map json) {
  return Project()
    ..name = json['name'] as String
    ..tracks = (json['tracks'] as List)
        ?.map((e) => e == null ? null : TrackData.fromJson(e as Map))
        ?.toList()
    ..bpm = json['bpm'] as int
    ..keyCount = json['keyCount'] as int
    ..measureCount = json['measureCount'] as int
    ..beatCount = json['beatCount'] as int;
}

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'name': instance.name,
      'tracks': instance.tracks,
      'bpm': instance.bpm,
      'keyCount': instance.keyCount,
      'measureCount': instance.measureCount,
      'beatCount': instance.beatCount,
    };
