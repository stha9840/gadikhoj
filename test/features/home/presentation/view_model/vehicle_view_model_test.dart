import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_event.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_state.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:finalyearproject/features/home/domain/use_case/get_all_vehicles_usecase.dart';
import 'package:mocktail/mocktail.dart';


class MockGetAllVehiclesUsecase extends Mock implements GetAllVehiclesUsecase {}

// A concrete failure class for testing.
class TestFailure extends Failure {
  const TestFailure({required super.message});
  @override
  List<Object> get props => [message];
}

void main() {


  late VehicleBloc vehicleBloc;
  late MockGetAllVehiclesUsecase mockGetAllVehiclesUsecase;

  setUp(() {
    mockGetAllVehiclesUsecase = MockGetAllVehiclesUsecase();
    vehicleBloc = VehicleBloc(
      getAllVehiclesUsecase: mockGetAllVehiclesUsecase,
    );
  });
 
  tearDown(() {
    vehicleBloc.close();
  });


  const tVehicle1 = VehicleEntity(id: '1', vehicleName: 'Big Truck', vehicleType: 'Heavy', filepath: '', fuelCapacityLitres: 100, loadCapacityKg: 1000, passengerCapacity: '3', pricePerTrip: 100);
  const tVehicle2 = VehicleEntity(id: '2', vehicleName: 'Small Van', vehicleType: 'Light', filepath: '', fuelCapacityLitres: 50, loadCapacityKg: 500, passengerCapacity: '2', pricePerTrip: 50);
  const tVehicle3 = VehicleEntity(id: '3', vehicleName: 'Light Truck', vehicleType: 'Heavy', filepath: '', fuelCapacityLitres: 120, loadCapacityKg: 1200, passengerCapacity: '3', pricePerTrip: 120);
  
  const tVehicleList = [tVehicle1, tVehicle2, tVehicle3];
  const tFailure = TestFailure(message: 'Failed to fetch');




  test('initial state should be VehicleInitial', () {
    expect(vehicleBloc.state, VehicleInitial());
  });

  group('FetchVehiclesEvent', () {
    blocTest<VehicleBloc, VehicleState>(
      'should emit [VehicleLoading, VehicleLoaded] when data is fetched successfully',
   
      setUp: () {
        when(() => mockGetAllVehiclesUsecase())
            .thenAnswer((_) async => const Right(tVehicleList));
      },
      
      build: () => vehicleBloc,
      act: (bloc) => bloc.add(FetchVehiclesEvent()),
     
      expect: () => [
        VehicleLoading(),
        VehicleLoaded(
          allVehicles: tVehicleList,
          filteredVehicles: tVehicleList,
          vehicleTypes: const ["All", "Heavy", "Light"],
          selectedType: "All",
          searchQuery: '',
        ),
      ],
      verify: (_) {
        verify(() => mockGetAllVehiclesUsecase()).called(1);
      },
    );

    blocTest<VehicleBloc, VehicleState>(
      'should emit [VehicleLoading, VehicleError] when fetching data fails',
     
      setUp: () {
        when(() => mockGetAllVehiclesUsecase())
            .thenAnswer((_) async => const Left(tFailure));
      },
    
      build: () => vehicleBloc,
      act: (bloc) => bloc.add(FetchVehiclesEvent()),
      
      expect: () => [
        VehicleLoading(),
        const VehicleError('Unexpected error'), 
      ],
    );
  });

  group('FilterVehiclesEvent', () {
    blocTest<VehicleBloc, VehicleState>(
      'should emit VehicleLoaded with filtered list when a type is selected',
      
      seed: () => const VehicleLoaded(
        allVehicles: tVehicleList,
        filteredVehicles: tVehicleList,
        vehicleTypes: ["All", "Heavy", "Light"],
        selectedType: "All",
        searchQuery: '',
      ),
      
      build: () => vehicleBloc,
      act: (bloc) => bloc.add(const FilterVehiclesEvent('Heavy')),
      
      expect: () => [
        const VehicleLoaded(
          allVehicles: tVehicleList,
          filteredVehicles: [tVehicle1, tVehicle3], 
          vehicleTypes: ["All", "Heavy", "Light"],
          selectedType: "Heavy", 
          searchQuery: '',
        ),
      ],
    );
  });
  
  group('SearchVehiclesEvent', () {
      blocTest<VehicleBloc, VehicleState>(
      'should emit VehicleLoaded with searched list when a query is entered',
      
      seed: () => const VehicleLoaded(
        allVehicles: tVehicleList,
        filteredVehicles: tVehicleList,
        vehicleTypes: ["All", "Heavy", "Light"],
        selectedType: "All",
        searchQuery: '',
      ),
    
      build: () => vehicleBloc,
      act: (bloc) => bloc.add(const SearchVehiclesEvent('truck')),
   
      expect: () => [
        const VehicleLoaded(
          allVehicles: tVehicleList,
          filteredVehicles: [tVehicle1, tVehicle3], 
          vehicleTypes: ["All", "Heavy", "Light"],
          selectedType: "All",
          searchQuery: 'truck',
        ),
      ],
    );
    
  });
}