import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sombook/core/api/api_exception.dart';

void main() {
  test('uses a backend error message when one is available', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/books'),
      response: Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/books'),
        statusCode: 422,
        data: const {'message': 'Invalid request'},
      ),
    );

    final apiException = ApiException.fromDioException(exception);

    expect(apiException.message, 'Invalid request');
    expect(apiException.statusCode, 422);
  });

  test('uses a friendly message for connection errors', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/books'),
      type: DioExceptionType.connectionError,
    );

    final apiException = ApiException.fromDioException(exception);

    expect(
      apiException.message,
      'Unable to connect. Check your internet connection.',
    );
  });
}
