class ApiResponse<T> {
  final T? data;
  final int statusCode;
  final String? message;
  final String? error;

  ApiResponse({this.data, required this.statusCode, this.message, this.error});

    Map<String, dynamic> toJson() => {
        'data': data,
        'statusCode': statusCode,
        'message': message,
        'error': error,
      };
}
