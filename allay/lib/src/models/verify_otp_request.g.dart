// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOTPRequest _$SendOTPRequestFromJson(Map<String, dynamic> json) {
  return SendOTPRequest(
    mobileNumber: json['mobileNumber'] as String,
  );
}

Map<String, dynamic> _$SendOTPRequestToJson(SendOTPRequest instance) =>
    <String, dynamic>{
      'mobileNumber': instance.mobileNumber,
    };

SendOTPResponse _$SendOTPResponseFromJson(Map<String, dynamic> json) {
  return SendOTPResponse(
    expirationTime: DateTime.parse(json['expirationTime'] as String),
    otpMessageFormat: json['otpMessageFormat'] as String,
  );
}

Map<String, dynamic> _$SendOTPResponseToJson(SendOTPResponse instance) =>
    <String, dynamic>{
      'expirationTime': instance.expirationTime.toIso8601String(),
      'otpMessageFormat': instance.otpMessageFormat,
    };

VerifyOTPRequest _$VerifyOTPRequestFromJson(Map<String, dynamic> json) {
  return VerifyOTPRequest(
    json['mobileNumber'] as String,
    json['otp'] as String,
  );
}

Map<String, dynamic> _$VerifyOTPRequestToJson(VerifyOTPRequest instance) =>
    <String, dynamic>{
      'mobileNumber': instance.mobileNumber,
      'otp': instance.otp,
    };
