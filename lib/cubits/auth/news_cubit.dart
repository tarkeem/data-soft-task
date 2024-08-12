import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/model/repositories/auth_repository.dart';

import '../../model/models/custom_error.dart';
import '../../model/models/news.dart';

part 'news_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit({required this.authRepository})
      : super(AuthState.initial());

  Future<void> SignIn(String email,String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await authRepository.SignIn(email, password);
      emit(state.copyWith(
        status: AuthStatus.loaded,
      ));
      print('state: $state');
    } on CustomError catch (e) {
      log(".......error..........");
      emit(state.copyWith(
        status: AuthStatus.error,
        error: e,
      ));
      print('state: $state');
    }
  }

  Future<void> SignUpScreen(String email,String password) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await authRepository.SignUp(email, password);

      

      emit(state.copyWith(
        status: AuthStatus.loaded,
      ));
      print('state: $state');
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        error: e,
      ));
      print('state: $state');
    }
  }
}
