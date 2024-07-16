// ignore_for_file: public_member_api_docs, sort_constructors_first
class CustomError {
  final String errorMessage;

  CustomError({required this.errorMessage});

  CustomError copyWith({
    String? errorMessage,
  }) {
    return CustomError(
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(covariant CustomError other) {
    if (identical(this, other)) return true;

    return other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => errorMessage.hashCode;

  @override
  String toString() => 'CustomError(errorMessage: $errorMessage)';
}
