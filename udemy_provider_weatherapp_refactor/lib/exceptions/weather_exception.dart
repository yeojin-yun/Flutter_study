// ignore_for_file: public_member_api_docs, sort_constructors_first
///오픈웨더만의 특별한 에러 케이스이므로 -> 커스텀으로 예외처리
class WeatherException implements Exception {
  String message;
  WeatherException([
    this.message = 'Something went wrong',
  ]) {
    message = 'Weather Exception: $message';
  }

  @override
  String toString() => message;
}
