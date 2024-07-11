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
