import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth.mock.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late UserLoginUsecase usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();

    registerFallbackValue(const UserLoginParams(email: '', password: ''));

    usecase = UserLoginUsecase(
      userRepository: mockAuthRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  test('✅ should return token and save it when login succeeds', () async {
    // Arrange
    const loginParams = UserLoginParams(email: 'aayush', password: 'aayush123');
    const token = 'abc123token';

    // Using mocktail: use 'when(() => ...)' with a lambda, and matchers for args
    when(
      () => mockAuthRepository.loginUser('aayush', 'aayush123'),
    ).thenAnswer((_) async => const Right(token));

    when(
      () => mockTokenSharedPrefs.saveToken(token),
    ).thenAnswer((_) async => Right<Failure, void>(null));

    // Act
    final result = await usecase(loginParams);

    // Assert
    expect(result, const Right(token));
    verify(() => mockAuthRepository.loginUser('aayush', 'aayush123')).called(1);
    verify(() => mockTokenSharedPrefs.saveToken(token)).called(1);
  });
}
