import 'package:io8/data/network/base_network_service.dart';
import 'package:io8/data/network/network_api_service.dart';
import 'package:io8/resources/app_urls/app_urls.dart';

class DbApiService {
  final BaseNetworkService _networkService = NetworkApiService();

  Future<dynamic> createDbs(dynamic body) async {
    try {
      final res = await _networkService.getPostApiResponse(
          AppUrls.createDbsEndpoint, body);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateDbs(dynamic body, dynamic entityId) async {
    try {
      final res = await _networkService.getPutApiResponse(
          '${AppUrls.updateDbsEndpoint}/$entityId', body);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteDbs(dynamic dbId) async {
    try {
      final uri = Uri.parse("${AppUrls.deleteDbsEndpoint}/$dbId");
      final res = await _networkService.getDeleteApiResponse(uri.toString());
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getDbs(dynamic projId) async {
    try {
      final uri = Uri.parse('${AppUrls.getDbsEndpoint}/$projId');
      final res = await _networkService.getGetApiResponse(uri.toString());
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
