import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:finalyearproject/features/home/presentation/view/home_view.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_view_model.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_state.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';

class MockVehicleBloc extends Mock implements VehicleBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockVehicleBloc mockVehicleBloc;

  final testVehicles = [
    const VehicleEntity(
      vehicleName: 'Toyota Corolla',
      vehicleType: 'Car',
      filepath: 'corolla.jpg',
      fuelCapacityLitres: 45,
      loadCapacityKg: 500,
      passengerCapacity: '5',
      pricePerTrip: 1200,
    ),
    const VehicleEntity(
      vehicleName: 'Ford F-150',
      vehicleType: 'Truck',
      filepath: 'f150.jpg',
      fuelCapacityLitres: 70,
      loadCapacityKg: 1500,
      passengerCapacity: '3',
      pricePerTrip: 2000,
    ),
  ];

  group('HomeView Widget Tests', () {
    testWidgets('displays vehicle cards with vehicle names and Rent Now button', (tester) async {
      mockVehicleBloc = MockVehicleBloc();

      when(() => mockVehicleBloc.state).thenReturn(VehicleLoaded(testVehicles));
      whenListen(mockVehicleBloc, Stream<VehicleState>.fromIterable([VehicleLoaded(testVehicles)]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<VehicleBloc>.value(
            value: mockVehicleBloc,
            child: const HomeView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Toyota Corolla'), findsOneWidget);
      expect(find.text('Ford F-150'), findsOneWidget);
      expect(find.text('Rent Now'), findsNWidgets(testVehicles.length));
    });

    testWidgets('shows loading indicator when state is VehicleLoading', (tester) async {
      mockVehicleBloc = MockVehicleBloc();
      when(() => mockVehicleBloc.state).thenReturn(VehicleLoading());
      whenListen(mockVehicleBloc, Stream<VehicleState>.fromIterable([VehicleLoading()]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<VehicleBloc>.value(
            value: mockVehicleBloc,
            child: const HomeView(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message on VehicleError state', (tester) async {
      const errorMessage = 'Failed to load vehicles';

      mockVehicleBloc = MockVehicleBloc();
      when(() => mockVehicleBloc.state).thenReturn(VehicleError(errorMessage));
      whenListen(mockVehicleBloc, Stream<VehicleState>.fromIterable([VehicleError(errorMessage)]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<VehicleBloc>.value(
            value: mockVehicleBloc,
            child: const HomeView(),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
