// lib/services/api_service.dart

// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = kBaseUrl;

  // Token key in secure storage
  static const _tokenKey = 'auth_token';

  Future<String?> getToken() async => await _storage.read(key: _tokenKey);

  Future<void> setToken(String token) async => await _storage.write(key: _tokenKey, value: token);

  Future<void> clearToken() async => await _storage.delete(key: _tokenKey);

  Map<String, String> _defaultHeaders({String? token}) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _uri(String path, [Map<String, dynamic>? params]) {
    final url = baseUrl + path;
    if (params == null) return Uri.parse(url);
    return Uri.parse(url).replace(queryParameters: params.map((k, v) => MapEntry(k, v.toString())));
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? params}) async {
    final token = await getToken();
    final res = await http.get(_uri(path, params), headers: _defaultHeaders(token: token));
    return _processResponse(res);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final token = await getToken();
    final res = await http.post(_uri(path),
        headers: _defaultHeaders(token: token), body: body == null ? null : jsonEncode(body));
    return _processResponse(res);
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    final token = await getToken();
    final res = await http.put(_uri(path),
        headers: _defaultHeaders(token: token), body: body == null ? null : jsonEncode(body));
    return _processResponse(res);
  }

  Future<dynamic> delete(String path) async {
    final token = await getToken();
    final res = await http.delete(_uri(path), headers: _defaultHeaders(token: token));
    return _processResponse(res);
  }

  dynamic _processResponse(http.Response res) {
    final code = res.statusCode;
    final text = res.body.isEmpty ? '{}' : res.body;
    final json = () {
      try {
        return jsonDecode(text);
      } catch (_) {
        return text;
      }
    }();

    if (code >= 200 && code < 300) {
      return json;
    } else {
      throw ApiException(code, json);
    }
  }

  /// Example login - adapt the path & fields to your backend
  Future<bool> login(String email, String password) async {
    final resp = await post('/auth/login/', body: {'email': email, 'password': password});
    // Expect backend to return something like { "token": "xxx" }
    if (resp is Map && resp.containsKey('token')) {
      await setToken(resp['token'].toString());
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await clearToken();
  }
}

class ApiException implements Exception {
  final int statusCode;
  final dynamic body;
  ApiException(this.statusCode, this.body);
  @override
  String toString() => 'ApiException($statusCode): $body';
}