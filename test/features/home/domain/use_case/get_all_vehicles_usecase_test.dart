import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/home/domain/use_case/get_all_vehicles_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:finalyearproject/features/home/domain/repository/vehicle_repository.dart';


class MockVehicleRepository extends Mock implements IVehicleRepository {}
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

// A concrete failure class for testing, ensuring it correctly overrides `props`.
class TestFailure extends Failure {
  const TestFailure({required super.message});

  @override
  List<Object> get props => [message];
}


// ======================================================================
// 2. MAIN TEST FUNCTION
// ======================================================================

void main() {
  // --- Test Setup ---
  late GetAllVehiclesUsecase usecase;
  late MockVehicleRepository mockVehicleRepository;
  late MockTokenSharedPrefs mockTokenPrefs;

  // This runs before each test to create a fresh environment.
  setUp(() {
    mockVehicleRepository = MockVehicleRepository();
    mockTokenPrefs = MockTokenSharedPrefs();
    usecase = GetAllVehiclesUsecase(
      vehicleRepository: mockVehicleRepository,
      tokenSharedPrefs: mockTokenPrefs,
    );
  });

  // --- Test Data ---
  const tToken = 'sample_auth_token_123';
  const tFailure = TestFailure(message: 'An error occurred');
  
  // A sample list of vehicles to be returned on success.
  const tVehicleList = [
    VehicleEntity(
      id: '1',
      vehicleName: 'Test Truck',
      vehicleType: 'Heavy',
      filepath: 'truck.png',
      fuelCapacityLitres: 100,
      loadCapacityKg: 5000,
      passengerCapacity: '3',
      pricePerTrip: 3000,
    ),
    VehicleEntity(
      id: '2',
      vehicleName: 'Test Van',
      vehicleType: 'Light',
      filepath: 'van.png',
      fuelCapacityLitres: 60,
      loadCapacityKg: 1000,
      passengerCapacity: '2',
      pricePerTrip: 1500,
    ),
  ];


  // ======================================================================
  // 3. THE TESTS
  // ======================================================================
  group('GetAllVehiclesUsecase', () {

    test(
      'should get token and return list of vehicles from repository on success',
      () async {
        // Arrange: Set up the mocks to return successful results.
        when(() => mockTokenPrefs.getToken())
            .thenAnswer((_) async => const Right(tToken));
            
        when(() => mockVehicleRepository.getAllVehicles(any()))
            .thenAnswer((_) async => const Right(tVehicleList));

        // Act: Call the use case.
        final result = await usecase();

        // Assert: Check that the result is a success and contains the vehicle list.
        expect(result, const Right(tVehicleList));
        
        // Verify that the correct methods were called on the mocks.
        verify(() => mockTokenPrefs.getToken()).called(1);
        verify(() => mockVehicleRepository.getAllVehicles(tToken)).called(1);
        
        // Verify no other interactions occurred.
        verifyNoMoreInteractions(mockTokenPrefs);
        verifyNoMoreInteractions(mockVehicleRepository);
      },
    );


    test(
      'should return a Failure when getting the token fails',
      () async {
        // Arrange: Set up the token preferences to return a failure.
        when(() => mockTokenPrefs.getToken())
            .thenAnswer((_) async => const Left(tFailure));

        // Act: Call the use case.
        final result = await usecase();

        // Assert: The result should be the failure.
        expect(result, const Left(tFailure));
        
        // Verify that getToken was called.
        verify(() => mockTokenPrefs.getToken()).called(1);
        
        // IMPORTANT: Verify that the repository was never called.
        verifyZeroInteractions(mockVehicleRepository);
        
        verifyNoMoreInteractions(mockTokenPrefs);
      },
    );


    test(
      'should return a Failure when the repository call fails',
      () async {
        // Arrange: Token succeeds, but the repository call fails.
        when(() => mockTokenPrefs.getToken())
            .thenAnswer((_) async => const Right(tToken));
            
        when(() => mockVehicleRepository.getAllVehicles(any()))
            .thenAnswer((_) async => const Left(tFailure));

        // Act: Call the use case.
        final result = await usecase();

        // Assert: The result should be the failure from the repository.
        expect(result, const Left(tFailure));
        
        // Verify that both mocks were called correctly.
        verify(() => mockTokenPrefs.getToken()).called(1);
        verify(() => mockVehicleRepository.getAllVehicles(tToken)).called(1);
        
        verifyNoMoreInteractions(mockTokenPrefs);
        verifyNoMoreInteractions(mockVehicleRepository);
      },
    );
  });
}