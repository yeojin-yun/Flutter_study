// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_basic/models/custom_error.dart';
import 'package:riverpod_basic/models/user_model.dart';
import 'package:riverpod_basic/repository/user_repository.dart';

enum Status {
  initial,
  loading,
  loaded,
  error;
}

class UserState {
  final List<UserModel> user;
  final Status status;
  final CustomError error;

  UserState({required this.user, required this.status, required this.error});

  factory UserState.initialize() {
    return UserState(
        user: [UserModel.initialize()],
        status: Status.initial,
        error: CustomError(errorMessage: ''));
  }

  @override
  String toString() => 'UserState(user: $user, status: $status, error: $error)';

  @override
  bool operator ==(covariant UserState other) {
    if (identical(this, other)) return true;

    return other.user == user && other.status == status && other.error == error;
  }

  @override
  int get hashCode => user.hashCode ^ status.hashCode ^ error.hashCode;

  UserState copyWith({
    List<UserModel>? user,
    Status? status,
    CustomError? error,
  }) {
    return UserState(
      user: user ?? this.user,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class UserStateProvider extends StateNotifier<UserState> {
  final UserRepository userRepository;
  UserStateProvider(this.userRepository) : super(UserState.initialize());

  Future<void> fetchUserList() async {
    state = state.copyWith(status: Status.loading);
    try {
      List<UserModel> userList = await userRepository.getUserList();
      debugPrint('userList is null? ${userList}');
      state = state.copyWith(user: userList, status: Status.loaded);
    } catch (e, s) {
      state = state.copyWith(
          user: [UserModel.initialize()],
          status: Status.error,
          error: CustomError(errorMessage: '$e | $s'));
    }
  }
}
