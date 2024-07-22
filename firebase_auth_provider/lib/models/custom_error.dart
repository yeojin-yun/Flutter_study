// ignore_for_file: public_member_api_docs, sort_constructors_first
class CustomError {
  final String code;
  final String message;
  final String plugin;

  CustomError(
      {required this.code, required this.message, required this.plugin});

  CustomError copyWith({
    String? code,
    String? message,
    String? plugin,
  }) {
    return CustomError(
      code: code ?? this.code,
      message: message ?? this.message,
      plugin: plugin ?? this.plugin,
    );
  }

  @override
  String toString() =>
      'CustomError(code: $code, message: $message, plugin: $plugin)';

  @override
  bool operator ==(covariant CustomError other) {
    if (identical(this, other)) return true;

    return other.code == code &&
        other.message == message &&
        other.plugin == plugin;
  }

  @override
  int get hashCode => code.hashCode ^ message.hashCode ^ plugin.hashCode;
}
