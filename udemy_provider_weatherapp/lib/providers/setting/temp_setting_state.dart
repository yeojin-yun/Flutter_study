// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'temp_setting_provider.dart';

enum TempUnit {
  celsius,
  fahrenheit;
}

class TempSettingState {
  final TempUnit tempUnit;
  TempSettingState({
    this.tempUnit = TempUnit.celsius,
  });

  factory TempSettingState.initialize() {
    return TempSettingState();
  }

  TempSettingState copyWith({
    TempUnit? tempUnit,
  }) {
    return TempSettingState(
      tempUnit: tempUnit ?? this.tempUnit,
    );
  }

  @override
  String toString() => 'TempSettingState(tempUnit: $tempUnit)';

  @override
  bool operator ==(covariant TempSettingState other) {
    if (identical(this, other)) return true;

    return other.tempUnit == tempUnit;
  }

  @override
  int get hashCode => tempUnit.hashCode;
}
