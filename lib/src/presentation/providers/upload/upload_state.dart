import 'package:cubex/src/core/utils/helpers.dart';
import 'package:cubex/src/data/datasources/remote/upload/upload_service.dart';
import 'package:cubex/src/data/repositories/upload/upload_service_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UploadState extends ChangeNotifier {
  static UploadState? _instance;
  static late UploadService uploadService;

  UploadState() {
    uploadService = UploadServiceImpl();
  }

  static UploadState get instance {
    if (_instance == null) {
      _instance = UploadState();
    }
    return _instance!;
  }

  bool _uploadBusy = false;
  bool get uploadBusy => _uploadBusy;

  Future<String?> uploadAssetImages({
    required FormData data,
  }) async {
    _uploadBusy = true;
    notifyListeners();

    try {
      final res = await uploadService.uploadFile(data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return res.data['data']['url'];
      }
      return null;
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
      return null;
    } finally {
      _uploadBusy = false;
      notifyListeners();
    }
  }
}
