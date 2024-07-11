import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:statenotifier_statenotifierprovider/providers/counter.dart';

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
