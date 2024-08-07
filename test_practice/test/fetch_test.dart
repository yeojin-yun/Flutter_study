import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_practice/fetch_data.dart';

import 'fetch_data_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late ApiService apiService;
  late MockDio mockDio;

  setUp(
    () {
      mockDio = MockDio();
      apiService = ApiService(dio: mockDio);
    },
  );

  group(
    'mockito test 2',
    () {
      test(
        'mockito test 1 - success',
        () async {
          final responsePayload = {"userId": 1, "id": 1, "title": 'supernova'};
          when(mockDio.get('https://jsonplaceholder.typicode.com/albums/1'))
              .thenAnswer(
            (_) async {
              return Response(
                  requestOptions: RequestOptions(path: ''),
                  data: responsePayload,
                  statusCode: 200);
            },
          );

          final response = await apiService.fetchAlbum();
          expect(response, isA<Album>());
          expect(response.id, 1);
          expect(response.userId, 1);
          expect(response.title, 'supernova');
          verify(mockDio.get('https://jsonplaceholder.typicode.com/albums/1'))
              .called(1);
        },
      );

      test(
        'mockito test 2 - failure',
        () async {
          // final responsePayload = {
          //   "userId": "1",
          //   "status": 1,
          //   "title": 'supernova'
          // };
          when(mockDio.get('https://jsonplaceholder.typicode.com/albums/1'))
              .thenThrow(DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 404,
              data: {},
            ),
            type: DioExceptionType.badResponse,
          ));

          // expect(() => apiService.fetchAlbum(), throwsA(isA<HttpException>()));
          expect(apiService.fetchAlbum(), throwsA(isA<DioException>()));

          // expect(
          //     apiService.fetchAlbum(),
          //     throwsA(predicate((e) =>
          //         e is HttpException && e.message == 'Failed to load album')));
        },
      );
    },
  );
}
