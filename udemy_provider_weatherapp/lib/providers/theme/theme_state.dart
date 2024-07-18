// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_provider.dart';

enum AppTheme {
  light,
  dart;
}

class ThemeState {
  final AppTheme appTheme;
  ThemeState({
    this.appTheme = AppTheme.light,
  });

  factory ThemeState.initialize() {
    return ThemeState();
  }

  ThemeState copyWith({
    AppTheme? appTheme,
  }) {
    return ThemeState(
      appTheme: appTheme ?? this.appTheme,
    );
  }

  @override
  String toString() => 'ThemeState(appTheme: $appTheme)';

  @override
  bool operator ==(covariant ThemeState other) {
    if (identical(this, other)) return true;

    return other.appTheme == appTheme;
  }

  @override
  int get hashCode => appTheme.hashCode;
}
