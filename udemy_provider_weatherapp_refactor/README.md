# udemy_provider_weatherapp_refactor

> 기존에 만들었던 weather앱의 Provider 부분을 StateNotifierProvider로 변경
> 

**StateNotifierProvider 만들기**
1. Provider class는 `StateNotifier<T>`를 extends한다.
2. `T`는 해당 Provider가 관리하는 상태이다.
3. 반드시 상위 생성자를 호출해야 한다. (상위 생성자에게 할당하는 T타입 상태의 초기 값)
4. `state`를 선언하지 않아도 사용할 수 있다.
5. Locator를 `mixin`한 후 update를 오버라이드 하면 다른 `Provider`에 `watch`, `read` 까지 할 수 있다.
- watch<T>, read<T>
6. `update`를 오버라이드 하지 않아도 접근 자체가 가능


**StateNotifierProvider 위젯 트리 주입 방법**
1. **StateNotifierProvider<T extends StateNotifier<Value>, Value> class** 
→ 첫 번째 타입은 Provider이며, 두 번째 타입은 그 Provider가 관리하는 state가 됨
****2. 그 후에 create를 통해 Provider 객체를 리턴하면 됨
3. 이 때 다른 상태에 의존하는 Provider가 있다면 의존하는 Provider가 더 상위 위젯트리에 선언되어야 함

**StateNotifierProvider 위젯 트리 내 사용 방법**
1. context.watch<V> → 바로 state에 접근 가능
2. context.read<T> → Provider에 접근 가능

---

[Provider](https://www.notion.so/weather_app_refactor2-3024ac540af0473db7cbdf7d3917bec5?pvs=21)

[Provider 위젯트리 선언](https://www.notion.so/weather_app_refactor2-3024ac540af0473db7cbdf7d3917bec5?pvs=21)

[UI](https://www.notion.so/weather_app_refactor2-3024ac540af0473db7cbdf7d3917bec5?pvs=21)

[addListener](https://www.notion.so/weather_app_refactor2-3024ac540af0473db7cbdf7d3917bec5?pvs=21)

---
### Provider

- `class WeatherProvider extends StateNotifier<WeatherState> with LocatorMixin {}`
    - `StateNotifier`를 상속받고 관리할 상태를 명시해줌
- `WeatherProvider() : super(WeatherState.initalize());`
    - 반드시 상위 생성자를 호출해야 함. 상위 생성자에게 부여하는 값이 `state`의 초기값이 됨
- `await read<WeatherRepository>().fetchWeather(city);`
    - `Locator`를 `mixin`하면 위젯 트리 내의 다른 `Provider`에 접근 가능

```dart
class WeatherProvider extends StateNotifier<WeatherState> with LocatorMixin {
  WeatherProvider() : super(WeatherState.initalize());

  Future<void> fetchWeather(String city) async {
    state = state.copyWith(weatherStatus: WeatherStatus.loading);

    try {
      final Weather weather =
          await read<WeatherRepository>().fetchWeather(city);
      state =
          state.copyWith(weather: weather, weatherStatus: WeatherStatus.loaded);
      debugPrint('✅ 5. [성공] $state');
    } on CustomError catch (e) {
      state = state.copyWith(error: e, weatherStatus: WeatherStatus.error);
      debugPrint('✅ 5. [예외] $state');
    }
  }
}
```

- `class TempSettingProvider extends StateNotifier<TempSettingState> {}`
    - `StateNotifier`를 상속받고, 해당 프로바이더가 관리할 타입을 명시해줌
- `TempSettingProvider() : super(TempSettingState.initialize());`
    - 반드시 상위 생성자를 호출해야 함. 상위 생성자에게 부여한 값이 state의 초기값임

```dart

class TempSettingProvider extends StateNotifier<TempSettingState> {
  TempSettingProvider() : super(TempSettingState.initialize());

  void toggleSwitch() {
    state = state.copyWith(
      tempUnit: state.tempUnit == TempUnit.celsius
          ? TempUnit.fahrenheit
          : TempUnit.celsius,
    );
    debugPrint('toggle switch = $state');
  }
}

```

- `class ThemeProvider extends StateNotifier<ThemeState> with LocatorMixin {}`
    - `StateNotifier`를 상속받고, 해당 프로바이더가 관리할 타입을 명시해줌
- `ThemeProvider() : super(ThemeState.initialize());`
    - 반드시 상위 생성자를 호출해야 함. 상위 생성자에게 부여한 값이 state의 초기값임
- `@override void update(Locator watch) {}`
    - `Locator`를 `mixin` 했기 때문에 사용 가능한 오버라이드 함수
    - 이를 통해 다른 `update`가 필요한 작업들을 처리할 있게 됨.

```dart
class ThemeProvider extends StateNotifier<ThemeState> with LocatorMixin {
  ThemeProvider() : super(ThemeState.initialize());

  @override
  void update(Locator watch) {
    // TODO: implement update
    if (watch<WeatherState>().weather.temp > kWarmOrNot) {
      state = state.copyWith(appTheme: AppTheme.light);
    } else {
      state = state.copyWith(appTheme: AppTheme.dart);
    }
    super.update(watch);
  }
}
```
---
### Provider 선언 부분

- `StateNotifierProvider<WeatherProvider, WeatherState>()`
    - 위젯트리 상에 `StateNotifierProvider`을 선언할 때는 반드시 해당 `Provider` 타입과 그 `Provider`가 관리하는 상태를 명시해줘야 함
- `StateNotifierProvider<ThemeProvider, ThemeState>()`
    - 다른 `Provider`에 의존하는 `Provider`가 있다면, 의존 당하는 `Provider`보다 더 나중에 선언되어야 함
    - 여기서 `ThemeProvider`는 `WeatherProvider`에 의존해서 `Theme`을 바꾸기 때문에 더 나중에 선언되어야 함
- `MaterialApp`의 context 내에 `Provider`가 없어서 에러가 발생 → builder로 한 번 감싸줌

```dart
return MultiProvider(
      providers: [
        ///WeatherRepository가 위젯 트리상에 필요하기 때문에 Provider로 감싸서 선언
        Provider<WeatherRepository>(
          create: (context) => WeatherRepository(
            weatherApiServices: WeatherApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        StateNotifierProvider<WeatherProvider, WeatherState>(
          create: (context) {
            return WeatherProvider();
          },
        ),
        StateNotifierProvider<TempSettingProvider, TempSettingState>(
          create: (context) => TempSettingProvider(),
        ),
        StateNotifierProvider<ThemeProvider, ThemeState>(
          create: (context) => ThemeProvider(),
        )
      ],
      builder: (context, _) => MaterialApp(
        title: 'Flutter Demo',
        theme: context.watch<ThemeState>().appTheme == AppTheme.light
            ? ThemeData.light()
            : ThemeData.dark(),
        home: const HomePage(),
      ),
    );
```
---
### UI

- UI에서 `Provider`을 가져다 쓰는 것은 기존 `Provider`와 동일하지만, 상태 타입을 명시했기 때문에 상태를 바로 가져올 수 있음

```dart
context.watch<TempSettingState>().tempUnit == TempUnit.celsius,
//context.watch<TempProvider>().state.tempUnit으로 접근하지 않아도 됨

context.read<TempSettingProvider>().toggleSwitch();
//read는 Provider를 바로 읽어올 수 있음
```
---
### addListener

```dart
void Function() addListener(void Function(WeatherState) listener, {bool fireImmediately = true})
```
1.  `addListener`는 좀 다르게 작동함
    - 리턴 값 : `void Function()`
    - 첫 번째 파라미터 `listener` : `void Function(WeatherState)`
    - 두 번째 파라미터 `fireImmediately`
2. `addListener`가 리턴하는 함수를 담을 `late` 함수 하나 선언

```dart
late final void Function() _removeListener;
```

3. `initState()`에서 초기화 진행

```dart
_removeListener = _weatherProvider.addListener(addListener);
```

4. 첫 번째 파라미터인 `listener`가 `WeatherState`를 인자로 받기 때문에 `addListener`도 수정해줌

```dart
  void addListener(WeatherState weatherState) {
    debugPrint('⛔️ addListener');

    if (weatherState.weatherStatus == WeatherStatus.error) {
      errorDialog(context, weatherState.error.errorMessage);
    }
  }
```

5. dispose
- `dispose`가 따로 없고 `addListener`에서 리턴한 함수를 호출하면 등록된 리스너를 해제할 수 있음
- 이렇기 때문에 함수를 `late` 변수로 선언했던 것

```dart
///3. dispose에서 dispose <- 그냥 함수 실행만 해도 해제가 된다.
_removeListener();
```
