import 'dart:convert';
import 'dart:io';
import 'package:allay/src/models/available_locations.dart';
import 'package:allay/src/util/specialities.dart';
import 'package:allay/src/util/urls.dart';
import 'package:allay/src/models/user.dart';
import 'package:camera/camera.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:file_picker/file_picker.dart' as filePicker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../models/enum.dart';
import '../models/verify_otp_request.dart';

const headerTypeJson = "application/json";

class AllayNetworkManager {
  final Dio _dio = Dio();
  final String _appDocPath;
  AllayNetworkManager._(this._appDocPath) {
    var cj = PersistCookieJar(ignoreExpires: true, storage: FileStorage(_appDocPath +"/.cookies/" ));
    _dio.interceptors.add(CookieManager(cj));
    _dio.interceptors.add(DioCacheManager(CacheConfig (baseUrl: "http://www.allayhealth.in")).interceptor);
  }

  static Future<String> _init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  Dio get dio => _dio;

  static AllayNetworkManager? _instance;

  static Future<AllayNetworkManager> getInstance() async {
    _instance ??= AllayNetworkManager._(await _init());
    return _instance!;
  }
}

final networkClientProvider = FutureProvider<Dio>((ref) async {
  var nm = await AllayNetworkManager.getInstance();
  return nm.dio;
});

final specialitiesProvider = FutureProvider<List<SearchItem>>((ref) async {
  var nm = await AllayNetworkManager.getInstance();
  var response = await nm.dio.get(specialitiesUrl);
  return (response.data as List).map((e) => Speciality.fromJson(e).getSearchItem()).toList();
});

final availableLocationsProvider = FutureProvider<List<SearchItem>>((ref) async {
  var nm = await AllayNetworkManager.getInstance();
  var response = await nm.dio.get(availableLocationsUrl);
  return (response.data as List).map((e) => AvailableLocation.fromJson(e).getSearchItem()).toList();
});

final indianStatesProvider = FutureProvider<List<String>>((ref) async {
  var nm = await AllayNetworkManager.getInstance();
  var response = await nm.dio.get(
      indianStatesUrl,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: headerTypeJson
      })
  );
  return (response.data as List<dynamic>).map((e) => e.toString()).toList();
});

Future<String> getUploadProfilePictureUrl(String fileType) async {
  var nm = await AllayNetworkManager.getInstance();
  var response = await nm.dio.get(uploadProfilePictureUrl, queryParameters: {"imageType": fileType});
  return response.data;
}

Future<String?> getGetProfilePictureUrl() async {
  var nm = await AllayNetworkManager.getInstance();
  var response = await nm.dio.get(getProfilePictureUrl);
  return response.data;
}

Future<S3Resource> getHealthRecordUploadUrl(String fileType) async {
  var nm = await AllayNetworkManager.getInstance();
  var response = await nm.dio.get(
      healthRecordUploadUrl, queryParameters: {"fileType": fileType});
  return S3Resource.fromJson(response.data);
}

Future<String?> getHealthRecordGetUrl() async {
  var nm = await AllayNetworkManager.getInstance();
  var response = await nm.dio.get(healthRecordGetUrl);
  return response.data;
}

final sendOTPProvider = FutureProvider.family<SendOTPResponse, SendOTPRequest>((ref, request) async {
  var nm = await AllayNetworkManager.getInstance();
  var response = await nm.dio.post(
    sendOtpUrl,
    data:  FormData.fromMap(request.toJson()),
    options: Options(headers: {
      HttpHeaders.contentTypeHeader: headerTypeJson,
    }),
  );
  SendOTPResponse responseBody = SendOTPResponse.fromJson(response.data);
  return responseBody;
});

final verifyOTPProvider = FutureProvider.family<User, VerifyOTPRequest>((ref, request) async {
  var nm = await AllayNetworkManager.getInstance();
  var response = await nm.dio.post(
    verifyOtpUrl,
    data: FormData.fromMap(request.toJson()),
    options: Options(headers: {
      HttpHeaders.contentTypeHeader: headerTypeJson,
    })
  );
  User user = User.fromJson(response.data);
  return user;
});

Future<User> _getUser () async {
  var nm = await AllayNetworkManager.getInstance();
  var response = await nm.dio.get(
      getUserProfileUrl,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: headerTypeJson
      })
  );
  User user = User.fromJson(response.data);
  return user;
}

Future<User> _updateUser (User user) async {
  var nm = await AllayNetworkManager.getInstance();
  var response = await nm.dio.post(
    updateUserProfileUrl,
    data: json.encode(user),
  );
  return User.fromJson(response.data);
}

final networkUserProvider = StateNotifierProvider<NetworkUserNotifier, AsyncValue<User?>>((ref) {
  return NetworkUserNotifier();
});

class NetworkUserNotifier extends StateNotifier<AsyncValue<User?>> {
  NetworkUserNotifier() : super(const AsyncValue.loading()){
    _fetch();
  }

  Future<void> _fetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getUser());
  }

  Future<User> updateAndSave(User user) async {
    state = const AsyncValue.loading();
    User updatedUser = await _updateUser(user);
    state = AsyncValue.data(updatedUser);
    return state.value!;
  }
}

Future<void> uploadImage(String url, XFile image, String fileType) async {
  FileType fileTypeEnum = FileType.XLS.fromExtension(fileType);
  var content = await image.readAsBytes();
  var length = await image.length();
  await http.put(
    Uri.parse(url),
    headers: {
      'Content-Type': fileTypeEnum.mimeType,
      'Accept': '*/*',
      'Content-Length': length.toString(),
      'Connection': 'keep-alive'
    },
    body: content
  );
}

Future<void> uploadFile(String url, filePicker.PlatformFile inputFile, String fileType) async {
  FileType fileTypeEnum = FileType.XLS.fromExtension(fileType);
  var file = File(inputFile.path!);
  var content = await file.readAsBytes();
  var length = file.lengthSync();
  var response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': fileTypeEnum.mimeType,
        'Accept': '*/*',
        'Content-Length': length.toString(),
        'Connection': 'keep-alive'
      },
      body: content
  );
}