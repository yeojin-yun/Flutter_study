import 'package:test/test.dart';
import 'package:test_practice/counter.dart';

void main() {
  // test(
  //   'counter test',
  //   () {
  //     final counter = Counter();
  //     counter.increment();
  //     expect(counter.value, 1);
  //   },
  // );
  // group(
  //   "dd",
  //   () {},
  // );
  group(
    'increment, decrement test',
    () {
      test(
        'value 1',
        () {
          final counter = Counter();
          counter.increment();
          expect(counter.value, 1);
        },
      );

      test(
        'value 2',
        () {
          final counter = Counter();
          counter.increment();
          counter.increment();
          expect(counter.value, 2);
        },
      );

      test(
        'value 0',
        () {
          final counter = Counter();
          counter.increment();
          counter.decrement();
          expect(counter.value, 0);
        },
      );
    },
  );
}
