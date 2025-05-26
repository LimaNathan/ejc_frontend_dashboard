abstract class AppException implements Exception {
  AppException(this.message, [this.stackTrace]);

  final String message;

  final StackTrace? stackTrace;

  @override
  String toString() {
    if (stackTrace != null) {
      return '$runtimeType: $message\n$stackTrace';
    } else {
      return '$runtimeType: $message';
    }
  }

  String toFormattedString(){
    return '$runtimeType: $message';
  }
}
