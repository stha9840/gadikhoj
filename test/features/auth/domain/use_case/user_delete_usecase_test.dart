import 'package:dartz/dartz.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_delete_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/app/use_case/use_case.dart';

// Mocks
class MockUserRepository extends Mock implements IUserRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late DeleteUserUseCase deleteUserUseCase;
  late MockUserRepository mockUserRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();

    deleteUserUseCase = DeleteUserUseCase(
      iUserRepository: mockUserRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );

    // Register fallback values if needed for params (usually not needed for String)
  });

  const testUserId = '1234';
  const testParams = DeleteUserParams(userId: testUserId);

  test('should return Left(Failure) when token retrieval fails', () async {
    final failure = ApiFailure(message: 'No token');

    // Arrange
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await deleteUserUseCase.call(testParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
    verifyNever(() => mockUserRepository.deleteUser(any(), any()));
  });

  test('should call deleteUser and return Right(void) when token retrieval succeeds', () async {
    const token = 'valid-token';

    // Arrange
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => Right(token));
    when(() => mockUserRepository.deleteUser(testUserId, token))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await deleteUserUseCase.call(testParams);

    // Assert
    expect(result, const Right(null));
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
    verify(() => mockUserRepository.deleteUser(testUserId, token)).called(1);
  });

  test('should return Left(Failure) when deleteUser fails', () async {
    const token = 'valid-token';
    final failure = ApiFailure(message: 'Delete failed');

    // Arrange
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => Right(token));
    when(() => mockUserRepository.deleteUser(testUserId, token))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await deleteUserUseCase.call(testParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
    verify(() => mockUserRepository.deleteUser(testUserId, token)).called(1);
  });
}
