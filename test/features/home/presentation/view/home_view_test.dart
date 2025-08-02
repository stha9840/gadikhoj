import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finalyearproject/features/home/presentation/view/home_view.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_view_model.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_state.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_view_model.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_state.dart';

// Mocks
class MockVehicleBloc extends Mock implements VehicleBloc {}
class MockSavedVehicleBloc extends Mock implements SavedVehicleBloc {}

void main() {
  late MockVehicleBloc mockVehicleBloc;
  late MockSavedVehicleBloc mockSavedVehicleBloc;

  setUp(() {
    mockVehicleBloc = MockVehicleBloc();
    mockSavedVehicleBloc = MockSavedVehicleBloc();

    // Mock VehicleBloc state and stream
    when(() => mockVehicleBloc.state).thenReturn(
      VehicleLoading(),
    );
    when(() => mockVehicleBloc.stream).thenAnswer((_) => const Stream.empty());

    // Mock SavedVehicleBloc state and stream
    when(() => mockSavedVehicleBloc.state).thenReturn(
      SavedVehicleSuccess(savedVehicles: []),
    );
    when(() => mockSavedVehicleBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  group('HomeView Widget Tests', () {
    testWidgets('renders HomeView widget without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<VehicleBloc>.value(value: mockVehicleBloc),
              BlocProvider<SavedVehicleBloc>.value(value: mockSavedVehicleBloc),
            ],
            child: const HomeView(),
          ),
        ),
      );

      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets('shows loading indicator when VehicleBloc is loading', (tester) async {
      when(() => mockVehicleBloc.state).thenReturn(VehicleLoading());
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<VehicleBloc>.value(value: mockVehicleBloc),
              BlocProvider<SavedVehicleBloc>.value(value: mockSavedVehicleBloc),
            ],
            child: const HomeView(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error text when VehicleBloc state is VehicleError', (tester) async {
      when(() => mockVehicleBloc.state).thenReturn(VehicleError('Error occurred'));
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<VehicleBloc>.value(value: mockVehicleBloc),
              BlocProvider<SavedVehicleBloc>.value(value: mockSavedVehicleBloc),
            ],
            child: const HomeView(),
          ),
        ),
      );

      expect(find.text('Error occurred'), findsOneWidget);
    });
  });
}
