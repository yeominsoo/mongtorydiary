import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mongtory_diary/core/network/api_exception.dart';
import 'package:mongtory_diary/data/dto/api_response_dto.dart';

class ApiClient {
  ApiClient({required this.baseUrl, http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _httpClient;

  Future<ApiResponseDto<T>> get<T>(
    String path, {
    required T Function(Object? json) parser,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await _httpClient.get(
      _buildUri(path, queryParameters: queryParameters),
      headers: _mergeHeaders(headers),
    );

    return _parseResponse(response, parser);
  }

  Future<ApiResponseDto<T>> post<T>(
    String path, {
    required T Function(Object? json) parser,
    Object? body,
    Map<String, String>? headers,
  }) async {
    final response = await _httpClient.post(
      _buildUri(path),
      headers: _mergeHeaders(headers),
      body: body == null ? null : jsonEncode(body),
    );

    return _parseResponse(response, parser);
  }

  Future<ApiResponseDto<T>> put<T>(
    String path, {
    required T Function(Object? json) parser,
    Object? body,
    Map<String, String>? headers,
  }) async {
    final response = await _httpClient.put(
      _buildUri(path),
      headers: _mergeHeaders(headers),
      body: body == null ? null : jsonEncode(body),
    );

    return _parseResponse(response, parser);
  }

  Future<ApiResponseDto<T>> delete<T>(
    String path, {
    required T Function(Object? json) parser,
    Map<String, String>? headers,
  }) async {
    final response = await _httpClient.delete(
      _buildUri(path),
      headers: _mergeHeaders(headers),
    );

    return _parseResponse(response, parser);
  }

  Uri _buildUri(String path, {Map<String, String>? queryParameters}) {
    final normalizedBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';

    return Uri.parse(
      '$normalizedBaseUrl$normalizedPath',
    ).replace(queryParameters: queryParameters);
  }

  ApiResponseDto<T> _parseResponse<T>(
    http.Response response,
    T Function(Object? json) parser,
  ) {
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final parsed = ApiResponseDto.fromJson(decoded, parser);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(parsed.message, statusCode: response.statusCode);
    }

    if (!parsed.success) {
      throw ApiException(parsed.message, statusCode: response.statusCode);
    }

    return parsed;
  }

  Map<String, String> get _defaultHeaders => const {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    return {..._defaultHeaders, ...?headers};
  }
}
