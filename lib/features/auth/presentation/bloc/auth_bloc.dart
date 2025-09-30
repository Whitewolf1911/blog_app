import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final GetCurrentUser _getCurrentUser;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required GetCurrentUser getCurrentUser,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _getCurrentUser = getCurrentUser,
       super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParameters(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (failResponse) => emit(AuthFailure(failResponse.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParameters(email: event.email, password: event.password),
    );

    res.fold(
      (failResponse) => emit(AuthFailure(failResponse.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _getCurrentUser(NoParams());
    res.fold(
      (failResponse) => emit(AuthFailure(failResponse.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }
}
