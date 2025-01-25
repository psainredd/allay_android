// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_locations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableLocation _$AvailableLocationFromJson(Map<String, dynamic> json) {
  return AvailableLocation(
    cityName: json['cityName'] as String,
    state: json['state'] as String,
    tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$AvailableLocationToJson(AvailableLocation instance) =>
    <String, dynamic>{
      'cityName': instance.cityName,
      'state': instance.state,
      'tags': instance.tags,
    };
