// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TodoSearchState {
  final String searchTerm;

  TodoSearchState({required this.searchTerm});

  factory TodoSearchState.initialize() {
    return TodoSearchState(searchTerm: "");
  }

  TodoSearchState copyWith({
    String? searchTerm,
  }) {
    return TodoSearchState(
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }

  @override
  String toString() => 'TodoSearchState(searchTerm: $searchTerm)';

  @override
  bool operator ==(covariant TodoSearchState other) {
    if (identical(this, other)) return true;

    return other.searchTerm == searchTerm;
  }

  @override
  int get hashCode => searchTerm.hashCode;
}

class TodoSearch with ChangeNotifier {
  TodoSearchState _state = TodoSearchState.initialize();
  TodoSearchState get state => _state;

  void setSearchTerm(String newSearchTerm) {
    _state = _state.copyWith(searchTerm: newSearchTerm);
    notifyListeners();
  }
}
