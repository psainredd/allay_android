// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    isActive: json['isActive'] as bool?,
    userId: json['userId'] as String?,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    mobileNumber: json['mobileNumber'] as String?,
    primaryUserId: json['primaryUserId'] as String?,
    nickName: json['nickName'] as String?,
    emailId: json['emailId'] as String?,
    dateOfBirth: json['dateOfBirth'] == null
        ? null
        : DateTime.parse(json['dateOfBirth'] as String),
    emergencyContact: json['emergencyContact'] as String?,
    profilePictureUrl: json['profilePictureUrl'] as String?,
    gender: json['gender'] as String?,
    address: json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>),
    medicalProfile: json['medicalProfile'] == null
        ? null
        : MedicalProfile.fromJson(
            json['medicalProfile'] as Map<String, dynamic>),
  )..hasProfilePicture = json['hasProfilePicture'] as bool?;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'isActive': instance.isActive,
      'primaryUserId': instance.primaryUserId,
      'nickName': instance.nickName,
      'mobileNumber': instance.mobileNumber,
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'emailId': instance.emailId,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'profilePictureUrl': instance.profilePictureUrl,
      'hasProfilePicture': instance.hasProfilePicture,
      'emergencyContact': instance.emergencyContact,
      'address': instance.address?.toJson(),
      'medicalProfile': instance.medicalProfile?.toJson(),
    };

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    houseNumber: json['houseNumber'] as String?,
    streetName: json['streetName'] as String?,
    locality: json['locality'] as String?,
    area: json['area'] as String?,
    cityName: json['cityName'] as String?,
    state: json['state'] as String?,
    geoCoordinates: json['geoCoordinates'] as String?,
    pinCode: json['pinCode'] as String?,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'houseNumber': instance.houseNumber,
      'streetName': instance.streetName,
      'locality': instance.locality,
      'area': instance.area,
      'cityName': instance.cityName,
      'state': instance.state,
      'geoCoordinates': instance.geoCoordinates,
      'pinCode': instance.pinCode,
    };

MedicalProfile _$MedicalProfileFromJson(Map<String, dynamic> json) {
  return MedicalProfile(
    weight: (json['weight'] as num?)?.toDouble(),
    heightInCentiMeters: json['heightInCentiMeters'] as int?,
    allergies:
        (json['allergies'] as List<dynamic>?)?.map((e) => e as String).toList(),
    bloodType: json['bloodType'] as String?,
    ailments: (json['ailments'] as List<dynamic>?)
        ?.map((e) => Ailment.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MedicalProfileToJson(MedicalProfile instance) =>
    <String, dynamic>{
      'weight': instance.weight,
      'heightInCentiMeters': instance.heightInCentiMeters,
      'allergies': instance.allergies,
      'bloodType': instance.bloodType,
      'ailments': instance.ailments?.map((e) => e.toJson()).toList(),
    };

Ailment _$AilmentFromJson(Map<String, dynamic> json) {
  return Ailment(
    ailmentType: json['ailmentType'] as String?,
    description: json['description'] as String?,
    dateOfDiagnosis: json['dateOfDiagnosis'] == null
        ? null
        : DateTime.parse(json['dateOfDiagnosis'] as String),
    healthRecords: (json['healthRecords'] as List<dynamic>?)
        ?.map((e) => S3Resource.fromJson(e as Map<String, dynamic>))
        .toList(),
    symptoms:
        (json['symptoms'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$AilmentToJson(Ailment instance) => <String, dynamic>{
      'ailmentType': instance.ailmentType,
      'description': instance.description,
      'dateOfDiagnosis': instance.dateOfDiagnosis?.toIso8601String(),
      'healthRecords': instance.healthRecords?.map((e) => e.toJson()).toList(),
      'symptoms': instance.symptoms,
    };

S3Resource _$S3ResourceFromJson(Map<String, dynamic> json) {
  return S3Resource(
    resourceKey: json['resourceKey'] as String?,
    fileName: json['fileName'] as String?,
    preSignedURL: json['preSignedURL'] as String?,
    fileType: json['fileType'] as String?,
    file: json['file'],
  );
}

Map<String, dynamic> _$S3ResourceToJson(S3Resource instance) =>
    <String, dynamic>{
      'resourceKey': instance.resourceKey,
      'preSignedURL': instance.preSignedURL,
      'fileName': instance.fileName,
      'fileType': instance.fileType,
      'file': instance.file,
    };
