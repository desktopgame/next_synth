// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppData _$AppDataFromJson(Map json) {
  return AppData()
    ..octaveCount = json['octaveCount'] as int
    ..beatWidth = json['beatWidth'] as int
    ..beatHeight = json['beatHeight'] as int
    ..measureCount = json['measureCount'] as int
    ..beatCount = json['beatCount'] as int
    ..beatSplitCount = json['beatSplitCount'] as int
    ..keyboardWidth = json['keyboardWidth'] as int
    ..toolBarHeight = json['toolBarHeight'] as int
    ..launchCount = json['launchCount'] as int;
}

Map<String, dynamic> _$AppDataToJson(AppData instance) => <String, dynamic>{
      'octaveCount': instance.octaveCount,
      'beatWidth': instance.beatWidth,
      'beatHeight': instance.beatHeight,
      'measureCount': instance.measureCount,
      'beatCount': instance.beatCount,
      'beatSplitCount': instance.beatSplitCount,
      'keyboardWidth': instance.keyboardWidth,
      'toolBarHeight': instance.toolBarHeight,
      'launchCount': instance.launchCount,
    };