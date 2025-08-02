import 'package:dartz/dartz.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_update_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';

// Mock Classes
class MockUserRepository extends Mock implements IUserRepository {}
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

// Fake Class for UserEntity
class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late UpdateUserUseCase updateUserUseCase;

  const tUserId = 'user123';
  const tToken = 'testToken';
  final tUserEntity = UserEntity(
    userId: 'user123',
    username: 'testuser',
    email: 'test@example.com',
  );

  final tFailure = ApiFailure(message: 'Test Failure');

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    updateUserUseCase = UpdateUserUseCase(
      iUserRepository: mockUserRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  group('UpdateUserUseCase', () {
    test('should update user successfully', () async {
      // Arrange
      when(() => mockTokenSharedPrefs.getToken())
          .thenAnswer((_) async => Right(tToken));

      when(() => mockUserRepository.updateUser(tUserId, tUserEntity, tToken))
          .thenAnswer((_) async => Right(null));

      // Act
      final result = await updateUserUseCase(
        UpdateUserParams(userId: tUserId, user: tUserEntity),
      );

      // Assert
      expect(result, Right(null));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verify(() => mockUserRepository.updateUser(tUserId, tUserEntity, tToken)).called(1);
    });

    test('should return Failure when token fetch fails', () async {
      // Arrange
      when(() => mockTokenSharedPrefs.getToken())
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await updateUserUseCase(
        UpdateUserParams(userId: tUserId, user: tUserEntity),
      );

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verifyNever(() => mockUserRepository.updateUser(any(), any(), any()));
    });

    test('should return Failure when repository update fails', () async {
      // Arrange
      when(() => mockTokenSharedPrefs.getToken())
          .thenAnswer((_) async => Right(tToken));

      when(() => mockUserRepository.updateUser(tUserId, tUserEntity, tToken))
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await updateUserUseCase(
        UpdateUserParams(userId: tUserId, user: tUserEntity),
      );

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verify(() => mockUserRepository.updateUser(tUserId, tUserEntity, tToken)).called(1);
    });
  });
}
