import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiService extends ChangeNotifier {
  String _baseUrl = AppConstants.defaultApiBaseUrl;
  bool _isDemoMode = true; // Defaults to demo mode for standalone operation

  String get baseUrl => _baseUrl;
  bool get isDemoMode => _isDemoMode;

  ApiService() {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUrl = prefs.getString(AppConstants.keyApiBaseUrl);
      final savedDemoMode = prefs.getBool(AppConstants.keyIsDemoMode);
      if (savedUrl != null && savedUrl.isNotEmpty) {
        _baseUrl = savedUrl;
      }
      if (savedDemoMode != null) {
        _isDemoMode = savedDemoMode;
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setBaseUrl(String newUrl) async {
    _baseUrl = newUrl.trim();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyApiBaseUrl, _baseUrl);
    } catch (_) {}
  }

  Future<void> setDemoMode(bool isDemo) async {
    _isDemoMode = isDemo;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyIsDemoMode, isDemo);
    } catch (_) {}
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    var cleanBase = _baseUrl.trim();
    if (cleanBase.endsWith('/')) {
      cleanBase = cleanBase.substring(0, cleanBase.length - 1);
    }
    var cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$cleanBase$cleanPath').replace(queryParameters: queryParameters);
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final uri = _buildUri(path, queryParams);
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException {
      throw ApiException('Cannot reach Spring Boot server at $_baseUrl.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<dynamic> post(String path, dynamic body) async {
    try {
      final uri = _buildUri(path);
      final response = await http
          .post(uri, headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException {
      throw ApiException('Cannot reach Spring Boot server at $_baseUrl.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<dynamic> put(String path, dynamic body) async {
    try {
      final uri = _buildUri(path);
      final response = await http
          .put(uri, headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException {
      throw ApiException('Cannot reach Spring Boot server at $_baseUrl.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final uri = _buildUri(path);
      final response = await http.delete(uri, headers: _headers).timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException {
      throw ApiException('Cannot reach Spring Boot server at $_baseUrl.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<bool> testConnection() async {
    try {
      final uri = _buildUri('/health');
      final res = await http.get(uri).timeout(const Duration(seconds: 3));
      return res.statusCode >= 200 && res.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      String errorMessage = 'Server returned status ${response.statusCode}';
      try {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is Map && decoded['message'] != null) {
          errorMessage = decoded['message'].toString();
        }
      } catch (_) {}
      throw ApiException(errorMessage, response.statusCode);
    }
  }
}
