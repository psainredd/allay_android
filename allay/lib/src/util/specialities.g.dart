// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Speciality _$SpecialityFromJson(Map<String, dynamic> json) {
  return Speciality(
    name: json['name'] as String,
    tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$SpecialityToJson(Speciality instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tags': instance.tags,
    };
