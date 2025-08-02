import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/home/domain/use_case/create_booking_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// --- Imports for the code being tested ---
// Adjust these paths to match your project's structure if they differ.
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/home/domain/repository/vehicle_repository.dart';


// ======================================================================
// 1. MOCK CLASSES & TEST HELPERS
// ======================================================================

// These mock classes will stand in for the real dependencies.
class MockVehicleRepository extends Mock implements IVehicleRepository {}
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

// FIX #2: This class now correctly overrides the `props` getter from its parent.
class TestFailure extends Failure {
  const TestFailure({required super.message});

  // This now returns `List<Object>` to match the signature in the abstract `Failure` class.
  @override
  List<Object> get props => [message];
}


// ======================================================================
// 2. MAIN TEST FUNCTION
// ======================================================================

void main() {
  // --- Test Setup ---
  late CreateBookingUsecase usecase;
  late MockVehicleRepository mockRepository;
  late MockTokenSharedPrefs mockTokenPrefs;

  setUp(() {
    mockRepository = MockVehicleRepository();
    mockTokenPrefs = MockTokenSharedPrefs();
    usecase = CreateBookingUsecase(
      repository: mockRepository,
      tokenSharedPrefs: mockTokenPrefs,
    );
  });

  // --- Test Data ---
  const tToken = 'sample_auth_token';
  final tParams = CreateBookingParams(
    vehicleId: 'vehicle-123',
    startDate: DateTime(2025, 8, 10),
    endDate: DateTime(2025, 8, 12),
    pickupLocation: 'City A',
    dropLocation: 'City B',
    totalPrice: 5000.0,
  );
  
  // This now instantiates our valid TestFailure class.
  const tFailure = TestFailure(message: 'Server error occurred');


  // ======================================================================
  // 3. THE TESTS
  // ======================================================================
  group('CreateBookingUsecase', () {

    test(
      'should call repository and return success (Right<void>) when token is available',
      () async {
        // Arrange
        when(() => mockTokenPrefs.getToken())
            .thenAnswer((_) async => const Right(tToken));

        when(() => mockRepository.createBooking(
              any(), any(),
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              pickupLocation: any(named: 'pickupLocation'),
              dropLocation: any(named: 'dropLocation'),
              totalPrice: any(named: 'totalPrice'),
            )).thenAnswer((_) async => const Right(null));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Right(null));
        verify(() => mockTokenPrefs.getToken()).called(1);
        verify(() => mockRepository.createBooking(
              tToken,
              tParams.vehicleId,
              startDate: tParams.startDate,
              endDate: tParams.endDate,
              pickupLocation: tParams.pickupLocation,
              dropLocation: tParams.dropLocation,
              totalPrice: tParams.totalPrice,
            )).called(1);
        verifyNoMoreInteractions(mockTokenPrefs);
        verifyNoMoreInteractions(mockRepository);
      },
    );


    test(
      'should return Failure when getting the token fails',
      () async {
        // Arrange
        when(() => mockTokenPrefs.getToken())
            .thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockTokenPrefs.getToken()).called(1);
        verifyZeroInteractions(mockRepository);
        verifyNoMoreInteractions(mockTokenPrefs);
      },
    );


    test(
      'should return Failure when the repository call fails',
      () async {
        // Arrange
        when(() => mockTokenPrefs.getToken())
            .thenAnswer((_) async => const Right(tToken));
        
        when(() => mockRepository.createBooking(
              any(), any(),
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              pickupLocation: any(named: 'pickupLocation'),
              dropLocation: any(named: 'dropLocation'),
              totalPrice: any(named: 'totalPrice'),
            )).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockTokenPrefs.getToken()).called(1);
        verify(() => mockRepository.createBooking(
              tToken,
              tParams.vehicleId,
              startDate: tParams.startDate,
              endDate: tParams.endDate,
              pickupLocation: tParams.pickupLocation,
              dropLocation: tParams.dropLocation,
              totalPrice: tParams.totalPrice,
            )).called(1);
        verifyNoMoreInteractions(mockTokenPrefs);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}