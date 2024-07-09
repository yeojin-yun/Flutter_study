import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_practice/user_service.dart';

void main() {
  group('UserService tests', () {
    test('fetchUserInfo success', () async {
      // 모의 객체 생성
      final mockHttpClient = MockHttpClient();
      final userService = UserService(mockHttpClient);

      // 모의 응답 설정
      when(mockHttpClient
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer(
              (_) async => http.Response('{"id": 1, "name": "John Doe"}', 200));

      // 테스트
      final result = await userService.fetchUserInfo('1');

      // 검증
      expect(result['name'], 'John Doe');
    });

    test('fetchUserInfo failure', () async {
      // 모의 객체 생성
      final mockHttpClient = MockHttpClient();
      final userService = UserService(mockHttpClient);

      // 모의 응답 설정
      when(mockHttpClient
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // 테스트
      expect(() => userService.fetchUserInfo('1'), throwsException);
    });
  });
}
