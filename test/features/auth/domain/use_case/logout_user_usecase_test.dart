import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';
import 'package:finalyearproject/features/auth/domain/use_case/logout_user_usecase.dart';

// Mock for IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late LogoutUserUsecase logoutUserUsecase;

  final tFailure = ApiFailure(message: 'Logout failed');

  setUp(() {
    mockUserRepository = MockUserRepository();
    logoutUserUsecase = LogoutUserUsecase(repository: mockUserRepository);
  });

  group('LogoutUserUsecase', () {
    test('should return void on successful logout', () async {
      // Arrange
      when(() => mockUserRepository.logoutUser())
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await logoutUserUsecase.call();

      // Assert
      expect(result, const Right(null));
      verify(() => mockUserRepository.logoutUser()).called(1);
    });

    test('should return Failure when logout fails', () async {
      // Arrange
      when(() => mockUserRepository.logoutUser())
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await logoutUserUsecase.call();

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockUserRepository.logoutUser()).called(1);
    });
  });
}
