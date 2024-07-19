# udemy_provider_weatherapp

[구조](https://www.notion.so/weather_app-aaf0095ae28a4645b7546370eddbcdfe?pvs=21)

[Provider](https://www.notion.so/weather_app-aaf0095ae28a4645b7546370eddbcdfe?pvs=21)

1. `WeatherProvider`
2. `TempProvider`
3. `ThemeProvider`

[View](https://www.notion.so/weather_app-aaf0095ae28a4645b7546370eddbcdfe?pvs=21)

1. addListener
2. state에 따른 다른 UI

[특이점](https://www.notion.so/weather_app-aaf0095ae28a4645b7546370eddbcdfe?pvs=21)

  - model에 custom 응답 추가

  - custom_exception

  - model 내 factory 함수 추가 (null 방지를 위한 initialize함수)

  - 의존성 주입

---

### 구조

```
- constant
    - constant.dart
    
- model
    - custom_error.dart
    - direct_geocoding.dart
    - weather.dart
    
- pages
    - home_page.dart
    - search_page.dart
    - settings_page.dart
    
- providers
    - setting
        - temp_setting_state.dart
        - temp_setting_provider.dart
    - theme
        - theme_state.dart
        - theme_provider.dart
    - weather
        - weather_provider.dart
        - weather_state.dart
        
- repositories: 개발자들이 보다 쉽게 api 통신을 할 수 있도록 services에 대한 interface를 제공
    - weather_repository.dart
    
- services: remote api와 직접 커뮤니케이션
    - http_error_handling.dart
    - weather_api_service.dart
    
- widgets: 여러 pages에서 공통적으로 사용할 위젯들을 모아놓은 폴더
    - error_dialog.dart
    
- main.dart
```

1. 유저가 search_page에서 도시명을 검색하면 → 위도와 경도를 받은 통신
    - `WeatherApiServices` - `getDirectGeocoding`
2. 위도와 경도를 가지고 다시 `weather` 정보를 가져오는 통신
    - `WeatherApiServices` - `getWeather`
3. 그 weather 데이터를 state로 관리하는 `WeatherProvider`가 존재
    - `WeatherProvider`는 `WeatherRepository`에게 데이터를 요청
    - `WeatherRepository` 에서는 1번, 2번 통신을 결합하여 하나의 `Weather` 데이터만 리턴
    - `WeatherRepository` 가 리턴하는 결과를 home_page UI에 반영
        - 결과가 성공 → 다시 main_page로 돌아온 뒤 데이터 보여줌
        - error → error_dialog를 보여줌
4. home_page에서 섭씨/화씨를 결정하는 setting_page로 연결
5. setting_page에서는 섭씨/화씨를 상태로 하는 `TempProvider`가 존재
    - `TempProvider`는 setting_page의 섭씨/화씨 스위치 버튼의 상태에 따라 값이 달라짐
6. weather state 중에 temp에 따라 앱의 Theme이 바뀜 → `ThemeProvider`
    - WeatherProvider가 관리하는 상태 weather 데이터 중에 temp가 20도 이상이면 → light theme, 20도 이하면 dart theme을 보여줌
    - `ThemeProvider`는 `WeatherProvider`에게 의존하는 `Provider`

---

### Provider
**총 3개의 Provider가 존재**
1. `WeatherProvider` : weather state를 관리하는 Provider
    
    ```dart
    ChangeNotifierProvider<WeatherProvider>(
      create: (context) => WeatherProvider(
        weatherRepository: context.read<WeatherRepository>(),
      ),
    ),
    ```
    
    - `WeatherRepository`에게 의존해서 데이터를 받아옴
    - `WeatherRepository`를 속성으로 받아 `WeatherProvider`의 객체를 생성할 때 의존성 주입
    - `WeatherProvider`를 위젯 트리 상에 선언할 때, `WeatherRepository` 객체가 필요하므로 `WeatherRepository` 또한 위젯 트리 내에 Provider로 존재 해야 함
    
    ```dart
    Provider<WeatherRepository>(
      create: (context) => WeatherRepository(
      weatherApiServices: WeatherApiServices(
        httpClient: http.Client(),
        ),
      ),
    ),
    ```
    
2. `TempProvider` : 섭씨/화씨 state를 관리하는 Provider
    
    ```dart
    ChangeNotifierProvider<TempSettingProvider>(
      create: (context) => TempSettingProvider(),
    ),
    ```
    
3. `ThemeProvider` : theme state를 관리하는 Provider
    - `ThemeProvider`는 `WeatherProvider`에게 의존하는 `Provider`
    
    ```dart
    ChangeNotifierProxyProvider<WeatherProvider, ThemeProvider>(
      create: (context) => ThemeProvider(),
      update: (BuildContext context, WeatherProvider weatherProvider,
        ThemeProvider? previous) {
          return previous!..update(weatherProvider);
        },
    ),
    ```
    

---

### View

1. `addListener`를 추가
    1. `search_page`에서 `WeatherProvider`에서 받아온 결과에 따라 성공이면 다시 `home_page`로 와서 성공 정보를 `UI`를 표시하고, 그렇지 않으면 `error_dialog`를 표시할 예정
    2. 이런 액션을 핸들링 할 때 여러가지 방법이 있지만, 여기서는 `WeatherProvider`에 `listener`를 추가하는 방법을 사용
    3. `WeatherProvider`를 `late`로 설정한 이유는, `context.read<WeatherProvider>();`를 하려면 위젯이 완전히 빌드된 후 호출할 수 있기 때문
    4. `context.read<WeatherProvider>()`는 `initState`와 같은 생명주기 메서드에서 호출할 수 있는 반면, `context.watch<WeatherProvider>()`는 빌드 메서드 내에서 호출해야 합니다. `initState`에서는 위젯이 빌드되기 전에 초기화가 필요
    
    ```dart
    class _HomePageState extends State<HomePage> {
        ///WeatherProvider의 객체를 late로 설정
      late final WeatherProvider _weatherProvider;
      
      ///WeatherProvider의 객체를 초기화
      ///리스너 추가
      @override
      void initState() {
        // TODO: implement initState
        _weatherProvider = context.read<WeatherProvider>();
        _weatherProvider.addListener(addListener);
        super.initState();
      }
    
      ///리스너 제거 작업 필요
      @override
      void dispose() {
        _weatherProvider.removeListener(addListener);
        super.dispose();
      }
    
        ///리스너 정의
      void addListener() {
        debugPrint('⛔️ addListener');
    
        ///watch는 안됨 -> button을 누를 때 watch로 처리하면 안되는 것과 같은 이치
        final WeatherState ws = context.read<WeatherProvider>().state;
        if (ws.weatherStatus == WeatherStatus.error) {
          errorDialog(context, ws.error.errorMessage);
        }
      }
      
      ...
    }
    ```
    
2. `WeatherProvider` 가 관리하는 state에 따라 UI를 다르게 보여줌
    1. `WeatherProvider`가 관리하는 `state` 중, 현재 진행 상태를 나타내는 `state.weatherStatus`에 따라 다른 UI를 보여줌. 
    2. 이를 위해 `Scaffold`의 `body` 부분에 `Widget`을 리턴하는 `_showWeather()` 함수를 할당
    3. `build` 메서드가 호출될 때마다 `_showWeather()`도 함께 호출되며 데이터를 보여주는 UI /에러 얼럿을 표시하는 UI가 보여짐
    
    ```dart
      Widget _showWeather() {
        final state = context.watch<WeatherProvider>().state;
        debugPrint('✅ ✅ ${state.weatherStatus} | ${state.weather.name}');
        if (state.weatherStatus == WeatherStatus.initial) {
          return Center(
            child: Text(
              'Select the city',
              style: TextStyle(fontSize: 20),
            ),
          );
        }
    
        if (state.weatherStatus == WeatherStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    
        if (state.weatherStatus == WeatherStatus.error &&
            state.weather.name == '') {
          return Center(
            child: Text(
              'Select the city',
              style: TextStyle(fontSize: 20),
            ),
          );
        }
    
        return ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 6),
            Text(
              state.weather.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(state.weather.lastUpdated).format(context),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 10),
                Text(
                  '(${state.weather.country})',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showTemperature(state.weather.temp),
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      showTemperature(state.weather.tempMin),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      showTemperature(state.weather.tempMax),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                showIcon(state.weather.icon),
                Expanded(flex: 3, child: formatText(state.weather.description)),
                Spacer(),
              ],
            )
          ],
        );
      }
    ```
    

---

### 특이점

1. 현재 시간을 표시하기 위해 api 응답으로는 오지 않지만, 현재 시간을 같이 모델링 함
    
    ```dart
    // ignore_for_file: public_member_api_docs, sort_constructors_first
    class Weather {
      ...
      final DateTime lastUpdated;
      Weather({
        ...
        required this.lastUpdated, //✅
      });
    
      factory Weather.fromJson(Map<String, dynamic> json) {
        final weather = json['weather'][0];
        final main = json['main'];
    
        return Weather(
          ...
          lastUpdated: DateTime.now() as DateTime, //✅
        );
      }
    
      ///null 값을 만들지 않기 위해 사용하는 생성자
      factory Weather.initialize() => Weather(
            description: '',
            icon: '',
            temp: 100.0,
            tempMin: 100.0,
            tempMax: 100.0,
            name: '',
            country: '',
            lastUpdated: DateTime(1970), //✅
          );
    
      Weather copyWith({
        ...
        DateTime? lastUpdated,
      }) {
        return Weather(
          ...
          lastUpdated: lastUpdated ?? this.lastUpdated, //✅
        );
      }
    
      @override
      String toString() {
        return 'Weather(description: $description, icon: $icon, temp: $temp, tempMin: $tempMin, tempMax: $tempMax, name: $name, country: $country, lastUpdated: $lastUpdated)';
      }
    }
    
    ```
    
2. 해당 api 통신만의 예외 상황 정의
    1. city name을 보내도 빈 배열로 오는 오픈 웨더라는 api 통신만의 예외 상황이 존재
        
        ```dart
         Future<DirectGeocoding> getDirectGeocoding(String city) async {
            debugPrint('✅ 4. [apiService] - getDirectGeocoding');
            final Uri uri = Uri(
              scheme: 'https',
              host: kApiHost,
              path: '/geo/1.0/direct',
              queryParameters: {
                'q': city,
                'limit': kLimit,
                'appId': dotenv.env['APPID']
              },
            );
        
            try {
              final http.Response response = await httpClient.get(uri);
              if (response.statusCode != 200) {
                throw Exception(httpErrorHandle(response));
              }
              final responBody = json.decode(response.body);
        
              ///⭐️⭐️⭐️ 오픈웨더만의 특별한 에러 케이스이므로 -> 커스텀으로 예외처리
              if (responBody.isEmpty) {
                throw WeatherException('Cannot get the location of $city');
              }
        
              final directGeocoding = DirectGeocoding.fromJson(responBody);
              return directGeocoding;
            } catch (e) {
              rethrow;
            }
          }
        ```
        
    
    b. 그러나 repository에서 결과를 리턴할 때는 CustomError 하나의 종류만 리턴함
    
    ```dart
      Future<Weather> fetchWeather(String city) async {
        debugPrint('✅ 3. [repository] fetchWeather');
        try {
          final DirectGeocoding directGeocoding =
              await weatherApiServices.getDirectGeocoding(city);
          debugPrint('repository: $directGeocoding');
    
          final Weather tempWeather =
              await weatherApiServices.getWeather(directGeocoding);
    
          ///유저가 입력한 city보다 geocoding을 통해 넘어온 name, country가 더 정확한 경우가 있기 때문에
          ///그 정보로 대체
          final Weather weather = tempWeather.copyWith(
              name: directGeocoding.name, country: directGeocoding.country);
    
          return weather;
        } on WeatherException catch (e) {
          ///⭐️⭐️⭐️ 
          throw CustomError(errorMessage: e.message);
        } catch (e) {
          ///⭐️⭐️⭐️ 
          throw CustomError(errorMessage: e.toString());
        }
      }
    ```
    
3. Weather Model에서 factory 함수를 통해 생성자 만들어 놓기
    1. 이를 통해 weather state가 null이 되는 것을 방지
        
        ```dart
          ///null 값을 만들지 않기 위해 사용하는 생성자
          factory Weather.initialize() => Weather(
                description: '',
                icon: '',
                temp: 100.0,
                tempMin: 100.0,
                tempMax: 100.0,
                name: '',
                country: '',
                lastUpdated: DateTime(1970),
              );
        ```
        
    2. WeatherState의 factory 생성자에서는 a에서 만든 생성자를 사용
    
    ```dart
      factory WeatherState.initalize() {
        return WeatherState(
            weatherStatus: WeatherStatus.initial,
            weather: Weather.initialize(),
            error: CustomError());
      }
    ```
    

4 . 의존성 주입

[의존성 주입](https://www.notion.so/b020f0324e3240bcaf45e01675b8cbd6?pvs=21)

```dart
///1.
Provider<WeatherRepository>(
  create: (context) => WeatherRepository(
  weatherApiServices: WeatherApiServices(
    httpClient: http.Client(),
    ),
  ),
),

///2. 
ChangeNotifierProvider<WeatherProvider>(
  create: (context) => WeatherProvider(
    weatherRepository: context.read<WeatherRepository>(),
  ),
),
```

- `WeatherRepository`를 위젯 트리상에 Provider로 선언하고, `WeatherProvider`의 객체 생성에서 인자로 넘기는 이유는 의존성 주입을 위해서임
- 의존성 : 클래스가 다른 클래스나 객체를 사용할 때, 그 사용되는 클래스나 객체를 “의존성”이라고 함. 아래에서는 `WeatherProvider`가 `WeatherRepository`를 사용하고 있으니, `WeatherRepository`가 의존성이 되는 것
- 주입: 의존성을 클래스 외부에서 생성하여 클래스에 제공하는 행위.
- **의존성 주입**이란 소프트웨어 디자인 패턴 중 하나로, 클래스 내부에서 사용할 객체를 직접 생성하지 않고, 외부에서 주입 받는 방법. 객체 간 결합도를 낮추고 코드의 재사용성과 테스트 가능성을 높이기 위해 사용됨
- 즉, `WeatherProvider`가 `WeatherRepository`에게 의존하여 생성된다는 이야기
---
# ProxyProvider로 refactor
> `WeatherProvider`에 의존하고 있었던 `ThemeProvider`를 `ChangeProxyProvider`에서 `ProxyProvider`로 변경

`ThemeProvider`에 자체관리하는 `state`가 없고 완전히 `WeatherProvider`에 의존하여 값이 바뀌기 때문에 `ProxyProvider`로 선언하는 것이 더 바람직
> 

1. `ThemeProvider` 수정
    - `state`를 내부에서 생성/관리하는 게 아니라 `WeatherProvider`에게 의존하여 `WeatherProvider`가 업데이트 될 때마다 바뀐 state의 객체를 만들어서 리턴 함

```dart
class ThemeProvider {
  final WeatherProvider weatherProvider;

  ThemeProvider({required this.weatherProvider});
  ThemeState get state {
    if (weatherProvider.state.weather.temp > kWarmOrNot) {
      return ThemeState(appTheme: AppTheme.light);
    } else {
      return ThemeState(appTheme: AppTheme.dart);
    }
  }
}

```

2. `Provider` 선언부분 수정
    - 전부 의존하는 값이기 때문에 `create`가 없음
    - 의존하는 값이 변할 때마다 `update` 함수가 호출됨

```dart
ProxyProvider<WeatherProvider, ThemeProvider>(
  update: (context, value, previous) {
    return ThemeProvider(weatherProvider: value);
  },
)
```
