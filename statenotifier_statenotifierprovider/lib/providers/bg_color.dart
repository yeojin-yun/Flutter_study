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
///1. StateNotifier<BgColorState>처럼 핸들링할 State를 지정한다는 점
class BgColor extends StateNotifier<BgColorState> {
  ///BgColor(super.state);
  ///2. super를 call해야 한다는 점
  ///이 때 초기값(initialState)을 인자값으로 넘김
  BgColor() : super(BgColorState(color: Colors.blue));

  ///3. state를 정의하지 않았는데도 사용할 수 있음.
  ///state의 초기값은 super를 콜 할 때 넣었던 값이 됨
  ///4. notifyListener();를 하지 않아도 됨
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
