import 'package:allay/src/util/specialities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'available_locations.g.dart';

@JsonSerializable(explicitToJson: true)
class AvailableLocation {
  String cityName;
  String state;
  List<String> tags;

  AvailableLocation({required this.cityName, required this.state, required this.tags});

  factory AvailableLocation.fromJson(Map<String, dynamic> json) => _$AvailableLocationFromJson(json);
  Map<String, dynamic> toJson() => _$AvailableLocationToJson(this);

  SearchItem getSearchItem() {
    return SearchItem(
      label: '$cityName, $state',
      icon: const Icon(Icons.location_on),
      tags: tags
    );
  }
}