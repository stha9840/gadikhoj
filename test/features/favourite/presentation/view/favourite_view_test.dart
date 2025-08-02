import 'package:bloc_test/bloc_test.dart';
import 'package:finalyearproject/features/favourite/presentation/view/favourite_view.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finalyearproject/features/saved_vechile/domain/entity/saved_vechile_entity.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_event.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';


// Mock Bloc
class MockSavedVehicleBloc
    extends MockBloc<SavedVehicleEvent, SavedVehicleState>
    implements SavedVehicleBloc {}

void main() {
  late MockSavedVehicleBloc mockSavedVehicleBloc;

  setUp(() {
    mockSavedVehicleBloc = MockSavedVehicleBloc();
  });

  Future<void> pumpFavouriteView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SavedVehicleBloc>.value(
          value: mockSavedVehicleBloc,
          child: const FavouriteView(),
        ),
      ),
    );
  }

  group('FavouriteView Widget Tests', () {
    testWidgets('displays loading indicator when state is loading', (tester) async {
      when(() => mockSavedVehicleBloc.state).thenReturn(SavedVehicleLoading());
      whenListen(mockSavedVehicleBloc, Stream<SavedVehicleState>.empty());

      await pumpFavouriteView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message and retry button on error', (tester) async {
      when(() => mockSavedVehicleBloc.state).thenReturn(
        SavedVehicleError(message: 'Failed to load data'),
      );
      whenListen(mockSavedVehicleBloc, Stream<SavedVehicleState>.empty());

      await pumpFavouriteView(tester);

      expect(find.text('Failed to load data'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('displays empty message when no saved vehicles', (tester) async {
      when(() => mockSavedVehicleBloc.state).thenReturn(
        SavedVehicleSuccess(savedVehicles: []),
      );
      whenListen(mockSavedVehicleBloc, Stream<SavedVehicleState>.empty());

      await pumpFavouriteView(tester);

      expect(find.text('No saved vehicles yet.'), findsOneWidget);
    });

  

  });
}
