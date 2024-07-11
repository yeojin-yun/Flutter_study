# StateNotifier & StateNotifierProvider
- Provider 패키지를 만든 Remi가 만든 패키지
- StateNotifier를 사용하면 ProxyProvider를 사용할 필요가 없음
- Remi가 만든 riverpod라는 상태관리 패키지에서 널리 쓰이고 있음
- 추후 riverpod를 사용할 예정이라면 이해하는데 큰 도움이 됨

### 패키지

- [state_notifier](https://pub.dev/packages/state_notifier)
- [flutter_state_notifier](https://pub.dev/packages/flutter_state_notifier)

```yaml
dependencies:
  ...
  flutter_state_notifier: ^1.0.0
  state_notifier: ^1.0.0
```

### **특징**

- `StateNotifier`를 상속받음
- 핸들링할 `State`를 명시함

```dart
class BgColor extends StateNotifier<BgColorState> {}
```

- 상위 생성자를 호출한 후, 사용할 `State`의 초기값을 부여해야 함
    - 이게 추후의 `state`의 초기값이 됨

```dart
class BgColor extends StateNotifier<BgColorState> {
  BgColor() : super(BgColorState(color: Colors.blue));
}
```

- `state`를 명시하지 않아도 사용이 가능
- `notifyListener();` 명시하지 않아도 됨

```dart
class BgColor extends StateNotifier<BgColorState> {
  BgColor() : super(BgColorState(color: Colors.blue));

  void chnageColor() {
    if (state.color == Colors.blue) {
      state = state.copyWith(color: Colors.black);
    } else if (state.color == Colors.black) {
      state = state.copyWith(color: Colors.red);
    } else {
      state = state.copyWith(color: Colors.blue);
    }
  }
}
```

- `LocatorMixin`을 `mixin`하면 `update` 함수를 오버라이드 해서 다른 `State`의 값을 가져다 쓸 수 있음
    - `watch`로 접근 가능
    - 이를 통해 다른 오브젝트의 변수를 `listen`할 수 있음
    - 위젯 트리 밖에서도 사용 가능
    - `read`는 사용 불가능 (값을 `listen`하는 개념이므로)

```dart
class Counter extends StateNotifier<CounterState> with LocatorMixin {
  Counter() : super(CounterState(count: 0));  
  
  @override
  void update(Locator watch) {
    debugPrint('✅ [update-BgColorState] ${watch<BgColorState>().color}');
    debugPrint('✅ [update-BgColor] ${watch<BgColor>().state.color}');
    super.update(watch);
  }
}
```

---

## 사용법

### 선언부

```dart
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:state_notifier/state_notifier.dart';

class BgColorState {
  final Color color;

  BgColorState({required this.color});

  BgColorState copyWith({
    Color? color,
  }) {
    return BgColorState(
      color: color ?? this.color,
    );
  }

  @override
  String toString() => 'BgColorState(color: $color)';

  @override
  bool operator ==(covariant BgColorState other) {
    if (identical(this, other)) return true;

    return other.color == color;
  }

  @override
  int get hashCode => color.hashCode;
}

///StateNotifier의 특이점
///✅ 1. StateNotifier<BgColorState>처럼 핸들링할 State를 지정한다는 점
class BgColor extends StateNotifier<BgColorState> {
  ///BgColor(super.state);
  ///✅ 2. super를 call해야 한다는 점
  ///이 때 초기값(initialState)을 인자값으로 넘김
  BgColor() : super(BgColorState(color: Colors.blue));

  ///✅ 3. state를 정의하지 않았는데도 사용할 수 있음.
  ///state의 초기값은 super를 콜 할 때 넣었던 값이 됨
  ///✅ 4. notifyListener();를 하지 않아도 됨
  void chnageColor() {
    if (state.color == Colors.blue) {
      state = state.copyWith(color: Colors.black);
    } else if (state.color == Colors.black) {
      state = state.copyWith(color: Colors.red);
    } else {
      state = state.copyWith(color: Colors.blue);
    }
  }
}

```

```dart
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:statenotifier_statenotifierprovider/providers/bg_color.dart';

class CounterState {
  final int count;

  CounterState({required this.count});

  CounterState copyWith({
    int? count,
  }) {
    return CounterState(
      count: count ?? this.count,
    );
  }

  @override
  String toString() => 'CounterState(count: $count)';

  @override
  bool operator ==(covariant CounterState other) {
    if (identical(this, other)) return true;

    return other.count == count;
  }

  @override
  int get hashCode => count.hashCode;
}

///BgColor를 read / watch하기 위해서 LocatorMixin을 믹스인함
class Counter extends StateNotifier<CounterState> with LocatorMixin {
  Counter() : super(CounterState(count: 0));

  void increment() {
    ///Locator를 mixin했기 때문에 사용이 가능해짐
    debugPrint('✅ [Counter +] ${read<BgColor>().state}');
    Color currentColor = read<BgColor>().state.color;
    if (currentColor == Colors.black) {
      state = state.copyWith(count: state.count + 10);
    } else if (currentColor == Colors.red) {
      state = state.copyWith(count: state.count - 10);
    } else {
      state = state.copyWith(count: state.count + 1);
    }
  }

  ///다른 오브젝트의 변화를 listen하게 해줌
  ///위젯 트리 밖에서도 사용 가능
  ///업데이트 함수에서는 read는 쓸 수 없음
  @override
  void update(Locator watch) {
    // TODO: implement update
    ///이렇게 watch를 이용해 다른 state의 값을 읽어올 수 있음
    debugPrint('✅ [update-BgColorState] ${watch<BgColorState>().color}');
    debugPrint('✅ [update-BgColor] ${watch<BgColor>().state.color}');
    super.update(watch);
  }
}

```

- 상태 대신 enum 사용 한 경우

```dart

enum Level {
  bronze,
  silver,
  gold;
}

class CustomLevel extends StateNotifier<Level> with LocatorMixin {
  CustomLevel() : super(Level.bronze);

  ///이 프로바이더는 일종의 computed provider -> 다른 값(count)에 의존해서 값이 바뀜
  @override
  void update(Locator watch) {
    // TODO: implement update
    /// 의존하는 값이 업데이트 될 떄마다 호출됨
    ///
    final currentCount = watch<CounterState>().count;
    if (currentCount >= 100) {
      state = Level.gold;
    } else if (currentCount >= 50 && currentCount < 100) {
      state = Level.silver;
    } else {
      state = Level.bronze;
    }
    super.update(watch);
  }
}

```

### 사용부분

- 선언
    - 순서가 중요⭐️ : Counter는 BgColor에 , CustomLevel Counter에 의존하고 있기 때문에 위젯 트리 상의 순서가 매우 중요 → 순서를 바꿔서 빌드하면 에러 발생

```dart
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ///StateNotifierProvider -> 두 개의 타입을 명시함 -> State와 State를 핸들링 하는 클래스
        ///순서가 매우 중요
        StateNotifierProvider<BgColor, BgColorState>(
          create: (context) => BgColor(),
        ),
        StateNotifierProvider<Counter, CounterState>(
          create: (context) => Counter(),
        ),
        StateNotifierProvider<CustomLevel, Level>(
          create: (context) => CustomLevel(),
        ),
      ],
      child: ...
    );
  }
```

- state를 가져다 쓸 때

```dart
final colorState = context.watch<BgColorState>().color;
final level = context.watch<Level>();
final countState = context.watch<CounterState>().count;
```

- 함수 호출 시 (이전과 동일)

```dart
context.read<Counter>().increment();
context.read<BgColor>().chnageColor();
```
