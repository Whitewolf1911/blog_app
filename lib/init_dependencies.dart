import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_API_KEY'] ?? '',
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserLogin(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => GetCurrentUser(authRepository: serviceLocator()),
  );

  // Register blocs as singleton, you don't want different state each time. It needs to persist.
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      getCurrentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}
