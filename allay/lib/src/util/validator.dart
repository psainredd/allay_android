const mobilePattern = r'^((\+)?91)?(-)?([0-9]{10})$';
const emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

bool isValidMobileNumber(String? mobileNumber) {
  var input = mobileNumber??'';
  RegExp regExp = RegExp(mobilePattern);
  return regExp.hasMatch(input);
}

String getNumberWithoutCountryCode(String mobileNumber) {
  if(! isValidMobileNumber(mobileNumber)) {
    return "";
  }
  RegExp regexp = RegExp(mobilePattern);
  Match? match = regexp.matchAsPrefix(mobileNumber);
  return (match?.group(4))!;
}

bool isValidEmailId(String? emailId) {
  var input = emailId??"";
  RegExp regExp = RegExp(emailPattern);
  return regExp.hasMatch(input);
}

String? nonEmptyTextValidator(String fieldName, String? val) {
  if (val == null || val.isEmpty) {
    return '$fieldName cannot be empty';
  }
  if (!isNonEmptyText(val)) {
    return '$fieldName should have only alphabet characters';
  }
  return null;
}

bool isNonEmptyText(String? text) {
  if((text?.isEmpty)??true) {
    return false;
  }
  String pattern = r'^([a-zA-Z])+$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(text??"");
}

