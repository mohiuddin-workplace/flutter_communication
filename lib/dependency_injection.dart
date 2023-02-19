import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_communication/feature/data/remote/data_sources/chat_room_data_source.dart';
import 'package:flutter_communication/feature/data/remote/data_sources/message_data_source.dart';
import 'package:flutter_communication/feature/data/remote/data_sources/user_data_source.dart';
import 'package:flutter_communication/feature/data/remote/repository_impls/chat_room_repository.dart';
import 'package:flutter_communication/feature/data/remote/repository_impls/message_repository.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';
import 'package:flutter_communication/feature/domain/entities/room_entity.dart';
import 'package:flutter_communication/feature/domain/entities/user_entity.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat/add_message_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat/delete_message_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat/get_message_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat/gets_message_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat/gets_update_message_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat/live_messages_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat/update_message_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat_room/create_room_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat_room/live_rooms_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/user/live_user_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/user/update_user_chat_room_use_case.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feature/domain/repositories/database_repository.dart';
import 'feature/domain/use_cases/chat_room/update_room_use_case.dart';
import 'feature/presentation/cubits/message_cubit.dart';
import 'index.dart';

GetIt locator = GetIt.instance;

Future<void> init() async {
  final local = await SharedPreferences.getInstance();
  final firebaseAuth = FirebaseAuth.instance;
  final facebookAuth = FacebookAuth.instance;
  final biometricAuth = LocalAuthentication();
  final database = FirebaseFirestore.instance;
  final realtime = FirebaseDatabase.instance;
  locator.registerLazySingleton<SharedPreferences>(() => local);
  locator.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  locator.registerLazySingleton<FacebookAuth>(() => facebookAuth);
  locator.registerLazySingleton<LocalAuthentication>(() => biometricAuth);
  locator.registerLazySingleton<FirebaseFirestore>(() => database);
  locator.registerLazySingleton<FirebaseDatabase>(() => realtime);
  _helpers();
  _dataSources();
  _repositories();
  _useCases();
  _cubits();
  await locator.allReady();
}

void _helpers() {
  locator.registerLazySingleton<PreferenceHelper>(() {
    return PreferenceHelper.of(preferences: locator());
  });
}

void _dataSources() {
  locator.registerLazySingleton<KeepUserDataSource>(() {
    return LocalUserDataSourceImpl(preferences: locator());
  });
  locator.registerLazySingleton<AuthDataSource>(() {
    return AuthDataSourceImpl(
      facebookAuth: locator(),
      firebaseAuth: locator(),
      localAuth: locator(),
    );
  });
}

void _repositories() {
  locator.registerLazySingleton<AuthRepository>(() {
    return AuthRepositoryImpl(
      authDataSource: locator.call(),
    );
  });
  locator.registerLazySingleton<DatabaseRepository<UserEntity>>(() {
    return UserRepository(
      remote: UserDataSource(),
      local: locator(),
    );
  });
  locator.registerLazySingleton<DatabaseRepository<RoomEntity>>(() {
    return ChatRoomRepository(
      remote: ChatRoomDataSource(),
      local: locator(),
    );
  });
  locator.registerLazySingleton<DatabaseRepository<MessageEntity>>(() {
    return MessageRepository(
      remote: MessageDataSource(),
      local: locator(),
    );
  });
}

void _useCases() {
  // AUTH SEGMENT
  locator.registerLazySingleton<IsSignInUseCase>(() {
    return IsSignInUseCase(repository: locator());
  });
  locator.registerLazySingleton<SignUpWithCredentialUseCase>(() {
    return SignUpWithCredentialUseCase(repository: locator());
  });
  locator.registerLazySingleton<SignUpWithEmailAndPasswordUseCase>(() {
    return SignUpWithEmailAndPasswordUseCase(repository: locator());
  });
  locator.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(() {
    return SignInWithEmailAndPasswordUseCase(repository: locator());
  });
  locator.registerLazySingleton<SignInWithFacebookUseCase>(() {
    return SignInWithFacebookUseCase(repository: locator());
  });
  locator.registerLazySingleton<SignInWithGoogleUseCase>(() {
    return SignInWithGoogleUseCase(repository: locator());
  });
  locator.registerLazySingleton<SignInWithBiometricUseCase>(() {
    return SignInWithBiometricUseCase(repository: locator());
  });
  locator.registerLazySingleton<SignOutUseCase>(() {
    return SignOutUseCase(repository: locator());
  });

  // USER SEGMENT
  locator.registerLazySingleton<UserCreateUseCase>(() {
    return UserCreateUseCase(repository: locator());
  });
  locator.registerLazySingleton<UpdateUserChatRoomUseCase>(() {
    return UpdateUserChatRoomUseCase(repository: locator());
  });
  locator.registerLazySingleton<UserUpdateUseCase>(() {
    return UserUpdateUseCase(repository: locator());
  });
  locator.registerLazySingleton<GetUserUseCase>(() {
    return GetUserUseCase(repository: locator());
  });
  locator.registerLazySingleton<UserGetsUseCase>(() {
    return UserGetsUseCase(repository: locator());
  });
  locator.registerLazySingleton<UserDeleteUseCase>(() {
    return UserDeleteUseCase(repository: locator());
  });
  locator.registerLazySingleton<UserSaveUseCase>(() {
    return UserSaveUseCase(repository: locator());
  });
  locator.registerLazySingleton<UserBackupUseCase>(() {
    return UserBackupUseCase(repository: locator());
  });
  locator.registerLazySingleton<UserRemoveUseCase>(() {
    return UserRemoveUseCase(repository: locator());
  });
  locator.registerLazySingleton<LiveUsersUseCase>(() {
    return LiveUsersUseCase(repository: locator());
  });
  // CHAT_ROOMS
  locator.registerLazySingleton<CreateRoomUseCase>(() {
    return CreateRoomUseCase(repository: locator());
  });
  locator.registerLazySingleton<UpdateRoomUseCase>(() {
    return UpdateRoomUseCase(repository: locator());
  });
  locator.registerLazySingleton<LiveChatsUseCase>(() {
    return LiveChatsUseCase(repository: locator());
  });
  // CHATS
  locator.registerLazySingleton<AddMessageUseCase>(() {
    return AddMessageUseCase(repository: locator());
  });
  locator.registerLazySingleton<DeleteMessageUseCase>(() {
    return DeleteMessageUseCase(repository: locator());
  });
  locator.registerLazySingleton<GetMessageUseCase>(() {
    return GetMessageUseCase(repository: locator());
  });
  locator.registerLazySingleton<GetsMessageUseCase>(() {
    return GetsMessageUseCase(repository: locator());
  });
  locator.registerLazySingleton<GetsUpdateMessageUseCase>(() {
    return GetsUpdateMessageUseCase(repository: locator());
  });
  locator.registerLazySingleton<LiveMessagesUseCase>(() {
    return LiveMessagesUseCase(repository: locator());
  });
  locator.registerLazySingleton<UpdateMessageUseCase>(() {
    return UpdateMessageUseCase(repository: locator());
  });
}

void _cubits() {
  locator.registerFactory<AuthCubit>(() => AuthCubit(
        isSignInUseCase: locator(),
        signUpWithCredentialUseCase: locator(),
        signUpWithEmailAndPasswordUseCase: locator(),
        signInWithEmailAndPasswordUseCase: locator(),
        signInWithFacebookUseCase: locator(),
        signInWithGoogleUseCase: locator(),
        signInWithBiometricUseCase: locator(),
        signOutUseCase: locator(),
        userCreateUseCase: locator(),
        userSaveUseCase: locator(),
        userBackupUseCase: locator(),
        userRemoveUseCase: locator(),
      ));
  locator.registerFactory<UserCubit>(() => UserCubit(
        userBackupUseCase: locator(),
        userCreateUseCase: locator(),
        userDeleteUseCase: locator(),
        userGetUseCase: locator(),
        userGetUpdatesUseCase: locator(),
        userGetsUseCase: locator(),
        userRemoveUseCase: locator(),
        userSaveUseCase: locator(),
        userUpdateUseCase: locator(),
        updateUserRoomUseCase: locator(),
        createRoomUseCase: locator(),
      ));
  locator.registerFactory<MessageCubit>(() => MessageCubit(
        addMessageUseCase: locator(),
        deleteMessageUseCase: locator(),
        getMessageUseCase: locator(),
        getsMessageUseCase: locator(),
        getsUpdateMessageUseCase: locator(),
        updateMessageUseCase: locator(),
      ));
}
