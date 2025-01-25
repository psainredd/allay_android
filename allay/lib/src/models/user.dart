import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import '../util/allay_shared_prefs.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  bool? isActive;
  String? primaryUserId;
  String? nickName;
  String? mobileNumber;
  String? userId;
  String? firstName;
  String? lastName;
  String? emailId;
  String? gender;
  DateTime? dateOfBirth;
  String? profilePictureUrl;
  bool? hasProfilePicture;
  String? emergencyContact;
  Address? address;
  MedicalProfile? medicalProfile;

  User({
    this.isActive,
    this.userId,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.primaryUserId,
    this.nickName,
    this.emailId,
    this.dateOfBirth,
    this.emergencyContact,
    this.profilePictureUrl,
    this.gender,
    this.address,
    this.medicalProfile
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Address {
  String? houseNumber;
  String? streetName;
  String? locality;
  String? area;
  String? cityName;
  String? state;
  String? geoCoordinates;
  String? pinCode;

  Address({
    this.houseNumber,
    this.streetName,
    this.locality,
    this.area,
    this.cityName,
    this.state,
    this.geoCoordinates,
    this.pinCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MedicalProfile {
  double? weight;
  int? heightInCentiMeters;
  List<String>? allergies;
  String? bloodType;
  List<Ailment>? ailments;

  MedicalProfile({
    this.weight,
    this.heightInCentiMeters,
    this.allergies,
    this.bloodType,
    this.ailments
  });

  factory MedicalProfile.fromJson(Map<String, dynamic> json) => _$MedicalProfileFromJson(json);
  Map<String, dynamic> toJson() => _$MedicalProfileToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Ailment {
  String? ailmentType;
  String? description;
  DateTime? dateOfDiagnosis;
  List<S3Resource>? healthRecords;
  List<String>? symptoms;

  Ailment({
    this.ailmentType,
    this.description,
    this.dateOfDiagnosis,
    this.healthRecords,
    this.symptoms
  });
  factory Ailment.fromJson(Map<String, dynamic> json) => _$AilmentFromJson(json);
  Map<String, dynamic> toJson() => _$AilmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class S3Resource {
  String? resourceKey;
  String? preSignedURL;
  String? fileName;
  String? fileType;
  bool uploadFailed = false;
  dynamic file;
  S3Resource({
    this.resourceKey,
    this.fileName,
    this.preSignedURL,
    this.fileType,
    this.file
  });
  factory S3Resource.fromJson(Map<String, dynamic> json) => _$S3ResourceFromJson(json);
  Map<String, dynamic> toJson() => _$S3ResourceToJson(this);
}