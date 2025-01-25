import 'package:allay/src/models/user.dart';

import '../util/specialities.dart';
import 'enum.dart';

class AppointmentAPIModel {
  DoctorProfileAPIModel? doctorProfile;
  DiagnosticTest? diagnosticTest;
  AppointmentType? appointmentType;
  User? patientInfo;
  DateTime? startTime;
  int? scheduledDurationInMinutes;
  AppointmentStatus? appointmentStatus;
  HealthRecord? healthRecord;
  BigInt? fees;
  bool isWalkIn = false;
}

class DoctorProfileAPIModel {
   String? firstName;
   String? lastName;
   String? emailId;
   String? phoneNumber;
   Speciality? speciality;
   DateTime? workingFrom;
   Map<int, List<TimeSlot>>? availableSlots;
   double? consultationFee;
   String? profilePictureGetUrl;
   List<AppointmentAPIModel>? appointments;
}

class DiagnosticTest {
  String? testId;
  String? testName;
  String? testDescription;
}

class TimeSlot {
  DateTime? startTime;
  DateTime? endTime;
}

class HealthRecord {
  String? ehrId;
  String? patientId;
  String? doctorId;
  Ailment? ailment;
  DateTime? creationTime;
  bool? isExternal;
}