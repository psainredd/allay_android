enum BloodType {
  A_POSITIVE,
  B_POSITIVE,
  AB_POSITIVE,
  O_POSITIVE,
  A_NEGATIVE,
  B_NEGATIVE,
  AB_NEGATIVE,
  O_NEGATIVE,
}

extension BloodTypeExtension on BloodType {

  String get text {
    switch(this){
      case BloodType.A_POSITIVE:
        return "A+";
      case BloodType.B_POSITIVE:
        return "B+";
      case BloodType.AB_POSITIVE:
        return "AB+";
      case BloodType.O_POSITIVE:
        return "O+";
      case BloodType.A_NEGATIVE:
        return "A-";
      case BloodType.B_NEGATIVE:
        return "B-";
      case BloodType.AB_NEGATIVE:
        return "AB-";
      case BloodType.O_NEGATIVE:
        return "O-";
      default:
        throw Exception("Invalid blood type");
    }
  }

  BloodType fromString(String value) {
    switch(value) {
      case "A+": return BloodType.A_POSITIVE;
      case "B+": return BloodType.B_POSITIVE;
      case "AB+": return BloodType.AB_POSITIVE;
      case "O+": return BloodType.O_POSITIVE;
      case "A-": return BloodType.A_NEGATIVE;
      case "B-": return BloodType.B_NEGATIVE;
      case "AB-": return BloodType.AB_NEGATIVE;
      case "O-": return BloodType.O_NEGATIVE;
      default: throw Exception("Invalid String");
    }
  }
}

enum Gender {
  MALE,
  FEMALE,
}

extension GenderExtension on Gender {

  String get text {
    switch(this) {
      case Gender.MALE:
        return "Male";
      case Gender.FEMALE:
        return "Female";
    }
  }

  Gender fromString(String value) {
    switch(value) {
      case "Male": return Gender.MALE;
      case "Female": return Gender.FEMALE;
      default: throw Exception("Invalid Gender");
    }
  }
}

enum FileType{
  AVI,
  BIN,
  BMP,
  CSV,
  DOC,
  DOCX,
  GIF,
  JPG,
  JPEG,
  JSON,
  MP3,
  MP4,
  MPEG,
  PNG,
  PDF,
  XLS,
  XLSX
}

extension FileTypExtension on FileType {

  String get extension {
    switch (this) {
      case FileType.AVI:
        return ".avi";
      case FileType.BIN:
        return ".bin";
      case FileType.BMP:
        return ".bmp";
      case FileType.CSV:
        return ".csv";
      case FileType.DOC:
        return ".doc";
      case FileType.DOCX:
        return ".docx";
      case FileType.GIF:
        return ".gif";
      case FileType.JPG:
        return ".jpg";
      case FileType.JPEG:
        return ".jpeg";
      case FileType.JSON:
        return ".json";
      case FileType.MP3:
        return ".mp3";
      case FileType.MP4:
        return ".mp4";
      case FileType.MPEG:
        return ".mpeg";
      case FileType.PNG:
        return ".png";
      case FileType.PDF:
        return ".pdf";
      case FileType.XLS:
        return ".xls";
      case FileType.XLSX:
        return ".xlsx";
      default:
        throw Exception("Invalid file type");
    }
  }

  FileType fromExtension(String extension) {
    if (!extension.startsWith(".")) {
      extension = "."+extension;
    }
    switch(extension) {
      case ".avi": return FileType.AVI;
      case ".bin": return FileType.BIN;
      case ".bmp": return FileType.BMP;
      case ".csv": return FileType.CSV;
      case ".doc": return FileType.DOC;
      case ".docx": return FileType.DOCX;
      case ".gif": return FileType.GIF;
      case ".jpg": return FileType.JPG;
      case ".jpeg": return FileType.JPEG;
      case ".json": return FileType.JSON;
      case ".mp3": return FileType.MP3;
      case ".mp4": return FileType.MP4;
      case ".mpeg": return FileType.MPEG;
      case ".png": return FileType.PNG;
      case ".pdf": return FileType.PDF;
      case ".xls": return FileType.XLS;
      case ".xlsx": return FileType.XLSX;
      default: throw Exception('Invalid extension');
    }
  }

  String get mimeType {
    switch(this) {
      case FileType.AVI:
        return "video/x-msvideo";
      case FileType.BIN:
        return"application/octet-stream" ;
      case FileType.BMP:
        return "image/bmp";
      case FileType.CSV:
        return "text/csv";
      case FileType.DOC:
        return "application/msword";
      case FileType.DOCX:
        return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
      case FileType.GIF:
        return "image/gif";
      case FileType.JPG:
        return "image/jpg";
      case FileType.JPEG:
        return "image/jpeg";
      case FileType.JSON:
        return "application/json";
      case FileType.MP3:
        return "audio/mpeg";
      case FileType.MP4:
        return "video/mp4";
      case FileType.MPEG:
        return "video/mpeg";
      case FileType.PNG:
        return "image/png";
      case FileType.PDF:
        return "application/pdf";
      case FileType.XLS:
        return "application/vnd.ms-excel";
      case FileType.XLSX:
        return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
      default:
        throw Exception("Invalid file type");
    }
  }
}

enum AppointmentType {
  DOCTOR,
  DIAGNOSTIC_TEST
}

enum AppointmentStatus {
  SCHEDULED, CANCELLED, COMPLETED, ONGOING, NO_SHOW, CONFLICTED
}