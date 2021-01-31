// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackData _$TrackDataFromJson(Map json) {
  return TrackData()
    ..name = json['name'] as String
    ..isMute = json['isMute'] as bool
    ..channel = json['channel'] as int
    ..pianoRollData = json['pianoRollData'] == null
        ? null
        : PianoRollData.fromJson(json['pianoRollData'] as Map);
}

Map<String, dynamic> _$TrackDataToJson(TrackData instance) => <String, dynamic>{
      'name': instance.name,
      'isMute': instance.isMute,
      'channel': instance.channel,
      'pianoRollData': instance.pianoRollData,
    };
