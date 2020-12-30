// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectList _$ProjectListFromJson(Map json) {
  return ProjectList()
    ..data = (json['data'] as List)
        ?.map((e) => e == null ? null : Project.fromJson(e as Map))
        ?.toList();
}

Map<String, dynamic> _$ProjectListToJson(ProjectList instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
