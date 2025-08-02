import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:finalyearproject/features/home/presentation/view/booking_view.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_event.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_state.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

// FIX 1: Define FAKE classes for any type used with mocktail's `any()` matcher.
// These must be at the top level of the file.
class FakeBookingEvent extends Fake implements BookingEvent {}
class FakeBookingState extends Fake implements BookingState {}

// Define the Mock Bloc class
class MockBookingBloc extends MockBloc<BookingEvent, BookingState>
    implements BookingBloc {}


void main() {
  // FIX 2: Register the fallback values in `setUpAll`.
  // This function runs ONCE before any tests and MUST be inside main()
  // to ensure mocktail is configured correctly.
  setUpAll(() {
    registerFallbackValue(FakeBookingEvent());
    registerFallbackValue(FakeBookingState());
  });

  // --- Test Setup ---
  late MockBookingBloc mockBookingBloc;

  const testVehicle = VehicleEntity(
    id: 'vehicle-123',
    vehicleName: 'Test Truck',
    vehicleType: 'Heavy Duty',
    filepath: 'truck.png',
    fuelCapacityLitres: 80,
    loadCapacityKg: 2000,
    passengerCapacity: '3',
    pricePerTrip: 2500,
  );

  // This runs before each test.
  setUp(() {
    mockBookingBloc = MockBookingBloc();
  });

  // This runs after each test to prevent memory leaks.
  tearDown(() {
    mockBookingBloc.close();
  });

  // Helper function to build the widget tree for each test.
  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<BookingBloc>.value(
        value: mockBookingBloc,
        child: const BookingScreen(vehicle: testVehicle),
      ),
    );
  }

  group('BookingScreen Widget Tests', () {
    testWidgets('renders initial UI elements correctly', (tester) async {
      when(() => mockBookingBloc.state).thenReturn(BookingInitial());
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Book Vehicle'), findsOneWidget);
      expect(find.text('Test Truck'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.text('Confirm Booking'), findsOneWidget);
    });

    testWidgets('shows loading indicator when state is BookingSubmitting', (tester) async {
      when(() => mockBookingBloc.state).thenReturn(BookingSubmitting());
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    
    testWidgets('shows validation errors when form is submitted empty', (tester) async {
      when(() => mockBookingBloc.state).thenReturn(BookingInitial());
      await tester.pumpWidget(createTestWidget());

      // FIX 3: Scroll to the button before tapping to avoid off-screen errors.
      final buttonFinder = find.text('Confirm Booking');
      await tester.ensureVisible(buttonFinder);
      await tester.pumpAndSettle();
      
      await tester.tap(buttonFinder);
      await tester.pump();

      expect(find.text('Start Date is required'), findsOneWidget);
      expect(find.text('End Date is required'), findsOneWidget);
      expect(find.text('Pickup Location is required'), findsOneWidget);
      expect(find.text('Drop Location is required'), findsOneWidget);
    });

    testWidgets('submits form with correct data when all fields are valid', (tester) async {
      // Arrange
      when(() => mockBookingBloc.state).thenReturn(BookingInitial());
      final startDate = DateTime.now();
      final endDate = DateTime.now().add(const Duration(days: 4));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Fill in form fields
      await tester.enterText(find.widgetWithText(TextFormField, 'Pickup Location'), 'City A');
      await tester.enterText(find.widgetWithText(TextFormField, 'Drop Location'), 'City B');

      // Select dates from pickers
      await tester.tap(find.widgetWithText(TextFormField, 'Start Date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(startDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextFormField, 'End Date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(endDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      
      // Verify derived data (total price) is correct
      final expectedPrice = testVehicle.pricePerTrip * 5;
      expect(find.text('Npr ${expectedPrice.toStringAsFixed(2)}'), findsOneWidget);

      // Scroll to button before tapping
      final buttonFinder = find.text('Confirm Booking');
      await tester.ensureVisible(buttonFinder);
      await tester.pumpAndSettle();
      await tester.tap(buttonFinder);
      await tester.pump();

      // Assert: Verify that the bloc's add method was called with the correct data.
      // This will now pass thanks to registerFallbackValue.
      verify(() => mockBookingBloc.add(any(that: isA<SubmitBooking>()
            .having((e) => e.vehicleId, 'vehicleId', testVehicle.id)
            .having((e) => e.pickupLocation, 'pickupLocation', 'City A')
            .having((e) => e.dropLocation, 'dropLocation', 'City B')
            .having((e) => e.totalPrice, 'totalPrice', expectedPrice))))
          .called(1);
    });
  });
}