import 'package:dartz/dartz.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_get_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';

// Mocks
class MockUserRepository extends Mock implements IUserRepository {}
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

// Fake for UserEntity (needed for mocktail fallback)
class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late GetUserUseCase getUserUseCase;

  const tToken = 'dummy_token';
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
    getUserUseCase = GetUserUseCase(
      iUserRepository: mockUserRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  group('GetUserUseCase', () {
    test('should return UserEntity when successful', () async {
      // Arrange
      when(() => mockTokenSharedPrefs.getToken())
          .thenAnswer((_) async => Right(tToken));

      when(() => mockUserRepository.getUser(tToken))
          .thenAnswer((_) async => Right(tUserEntity));

      // Act
      final result = await getUserUseCase();

      // Assert
      expect(result, Right(tUserEntity));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verify(() => mockUserRepository.getUser(tToken)).called(1);
    });

    test('should return Failure when token fetch fails', () async {
      // Arrange
      when(() => mockTokenSharedPrefs.getToken())
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await getUserUseCase();

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verifyNever(() => mockUserRepository.getUser(any()));
    });

    test('should return Failure when repository getUser fails', () async {
      // Arrange
      when(() => mockTokenSharedPrefs.getToken())
          .thenAnswer((_) async => Right(tToken));

      when(() => mockUserRepository.getUser(tToken))
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await getUserUseCase();

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verify(() => mockUserRepository.getUser(tToken)).called(1);
    });
  });
}
