import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? data;

  const ApiException({required this.message, this.statusCode, this.data});

  factory ApiException.fromDioException(DioException exception) {
    final response = exception.response;
    final responseData = response?.data;
    final serverMessage = responseData is Map<String, dynamic>
        ? responseData['message']?.toString()
        : null;

    return ApiException(
      message: serverMessage ?? _messageFor(exception.type),
      statusCode: response?.statusCode,
      data: responseData,
    );
  }

  static String _messageFor(DioExceptionType type) {
    return switch (type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'The request timed out. Please try again.',
      DioExceptionType.connectionError =>
        'Unable to connect. Check your internet connection.',
      DioExceptionType.cancel => 'The request was cancelled.',
      _ => 'Something went wrong. Please try again.',
    };
  }

  @override
  String toString() => message;
}
