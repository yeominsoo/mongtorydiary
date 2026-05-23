import 'package:mongtory_diary/core/network/api_client.dart';
import 'package:mongtory_diary/core/network/api_exception.dart';
import 'package:mongtory_diary/data/dto/todo_item_response_dto.dart';
import 'package:mongtory_diary/data/dto/todo_upsert_request_dto.dart';

class RemoteTodoDataSource {
  const RemoteTodoDataSource(this._apiClient, this._accessToken);

  final ApiClient _apiClient;
  final String? _accessToken;

  Future<List<TodoItemResponseDto>> getTodos({
    required String from,
    required String to,
  }) async {
    final response = await _apiClient.get<List<TodoItemResponseDto>>(
      '/api/v1/todos',
      parser: (json) => (json as List<dynamic>? ?? const [])
          .map(
            (item) =>
                TodoItemResponseDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      queryParameters: {'from': from, 'to': to},
      headers: _authorizationHeaders,
    );

    return response.data;
  }

  Future<TodoItemResponseDto> createTodo(TodoUpsertRequestDto request) async {
    final response = await _apiClient.post<TodoItemResponseDto>(
      '/api/v1/todos',
      parser: (json) =>
          TodoItemResponseDto.fromJson(json as Map<String, dynamic>),
      body: request.toJson(),
      headers: _authorizationHeaders,
    );

    return response.data;
  }

  Future<TodoItemResponseDto> updateTodo(
    int todoId,
    TodoUpsertRequestDto request,
  ) async {
    final response = await _apiClient.put<TodoItemResponseDto>(
      '/api/v1/todos/$todoId',
      parser: (json) =>
          TodoItemResponseDto.fromJson(json as Map<String, dynamic>),
      body: request.toJson(),
      headers: _authorizationHeaders,
    );

    return response.data;
  }

  Future<void> deleteTodo(int todoId) async {
    await _apiClient.delete<void>(
      '/api/v1/todos/$todoId',
      parser: (_) {},
      headers: _authorizationHeaders,
    );
  }

  Map<String, String> get _authorizationHeaders {
    if (_accessToken == null || _accessToken.isEmpty) {
      throw const ApiException('로그인이 필요합니다.');
    }

    return {'Authorization': 'Bearer $_accessToken'};
  }
}
