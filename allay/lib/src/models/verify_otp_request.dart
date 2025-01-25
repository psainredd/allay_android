import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request.g.dart';

@JsonSerializable(explicitToJson: true)
class SendOTPRequest {
  String mobileNumber;

  SendOTPRequest({required this.mobileNumber});

  factory SendOTPRequest.fromJson(Map<String, dynamic> json) => _$SendOTPRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SendOTPRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendOTPResponse {
  DateTime expirationTime;
  String otpMessageFormat;

  SendOTPResponse({required this.expirationTime, required this.otpMessageFormat});

  factory SendOTPResponse.fromJson(Map<String, dynamic> json) => _$SendOTPResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendOTPResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VerifyOTPRequest {
  String mobileNumber;
  String otp;
  VerifyOTPRequest(this.mobileNumber, this.otp);

  factory VerifyOTPRequest.fromJson(Map<String, dynamic> json) => _$VerifyOTPRequestFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyOTPRequestToJson(this);
}