import 'package:flutter/material.dart';
import 'package:io8/data/response/api_response.dart';
import 'package:io8/features/db/model/db_model.dart';
import 'package:io8/features/db/repository/db_api_service.dart';
import 'package:io8/utils/toast_messages/toast_message_util.dart';

class CreateDbViewmode extends ChangeNotifier {
  final _dbRepo = DbApiService();

  ApiResponse<List<DbModel>> dbData = ApiResponse.loading();
  setDbData(ApiResponse<List<DbModel>> data) {
    dbData = data;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> createDb(
      dynamic body, dynamic projId, BuildContext context) async {
    setLoading(true); // Indicating that loading has started

    try {
      _dbRepo.createDbs(body).then((value) {
        print('Finally, it came here: $value, here is the proj $projId');
        setLoading(false); // Stopping the loading spinner

        ToastMessageUtil.showToast(
          message: "Database created successfully!",
          toastType: ToastType.success,
        );
        Navigator.pop(context); // Navigating back after success
        getDb(projId); // Fetching the database after creation
      }).onError((error, stackTrace) {
        print("Error is: $error");
        setLoading(false); // Stopping the loading spinner on error
        ToastMessageUtil.showToast(
          message: "Error creating database! $error",
          toastType: ToastType.error,
        );
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateDb(
      dynamic body, dynamic bodyId, BuildContext context) async {
    setLoading(true);
    _dbRepo.updateDbs(body, bodyId).then(
      (value) {
        print(value);
        setLoading(false);
        ToastMessageUtil.showToast(
            message: "Database Updated !!", toastType: ToastType.success);

        Navigator.pop(context);
      },
    ).onError(
      (error, stackTrace) {
        print(error);
        setLoading(false);
        ToastMessageUtil.showToast(
            message: "Error updating Database !!", toastType: ToastType.error);
      },
    );
  }

  Future<void> deleteDb(
      dynamic dbId, dynamic projId, BuildContext context) async {
    _dbRepo.deleteDbs(dbId).then(
      (value) {
        print(value);
        ToastMessageUtil.showToast(
            message: "Database Deleted !!", toastType: ToastType.success);
        Navigator.pop(context);
        getDb(projId);
      },
    ).onError(
      (error, stackTrace) {
        print(error);

        ToastMessageUtil.showToast(
            message: "Error deleting database !!", toastType: ToastType.error);
      },
    );
  }

  Future<void> getDb(dynamic projId) async {
    setDbData(ApiResponse.loading());
    _dbRepo.getDbs(projId).then(
      (value) {
        print('ooo I got the $value');
        if (value != null && value is List) {
          final data = value
              .map(
                (e) => DbModel.fromJson(e),
              )
              .toList();
          setDbData(ApiResponse.success(data));
        } else {
          setDbData(ApiResponse.success([]));
        }
      },
    ).onError(
      (error, stackTrace) {
        print(stackTrace);
        setDbData(ApiResponse.error(error.toString()));
        print(error);
      },
    );
  }
}
