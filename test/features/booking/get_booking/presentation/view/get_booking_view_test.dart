import 'package:bloc_test/bloc_test.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/entity/booking.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view/get_booking_view.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_event.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_state.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_view_model.dart';


class MockBookingViewModel extends MockBloc<BookingEvent, BookingState>
    implements BookingViewModel {}

class FakeBookingEvent extends Fake implements BookingEvent {}
class FakeBookingState extends Fake implements BookingState {}

void main() {
  late MockBookingViewModel mockBookingViewModel;

  setUpAll(() {
    registerFallbackValue(FakeBookingEvent());
    registerFallbackValue(FakeBookingState());
  });

  setUp(() {
    mockBookingViewModel = MockBookingViewModel();
  });
  tearDown(() {
    mockBookingViewModel.close();
  });

  Widget createTestWidget(Widget child) {
    return BlocProvider<BookingViewModel>.value(
      value: mockBookingViewModel,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  final mockBookings = [
    BookingEntity(
      id: '1',
      userId: 'user-123',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 2)),
      pickupLocation: 'City A',
      dropLocation: 'City B',
      totalPrice: 5000,
      status: 'confirmed',
      vehicle: const VehicleEntity(
        id: 'vehicle-01',
        vehicleName: 'Test Truck',
        vehicleType: 'Heavy Duty',
        filepath: 'truck.png',
        fuelCapacityLitres: 80,
        loadCapacityKg: 2000,
        passengerCapacity: '3',
        pricePerTrip: 2500,
      ),
    ),
    BookingEntity(
      id: '2',
      userId: 'user-123',
      startDate: DateTime.now().add(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 7)),
      pickupLocation: 'City C',
      dropLocation: 'City D',
      totalPrice: 7500,
      status: 'pending',
      vehicle: const VehicleEntity(
        id: 'vehicle-02',
        vehicleName: 'Test Van',
        vehicleType: 'Light Duty',
        filepath: 'van.png',
        fuelCapacityLitres: 50,
        loadCapacityKg: 800,
        passengerCapacity: '2',
        pricePerTrip: 1500,
      ),
    ),
  ];
  group('GetBookingView (BookingListScreen) Tests', () {
    testWidgets('dispatches GetUserBookings event on initialization', (tester) async {

      when(() => mockBookingViewModel.state).thenReturn(BookingInitial());
      await tester.pumpWidget(createTestWidget(const BookingListScreen()));
      verify(() => mockBookingViewModel.add(GetUserBookings())).called(1);
    });

    testWidgets('shows loading indicator when state is BookingLoading', (tester) async {
      when(() => mockBookingViewModel.state).thenReturn(BookingLoading());
      
      // Act: Build the widget.
      await tester.pumpWidget(createTestWidget(const BookingListScreen()));

    
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when state is BookingError', (tester) async {

      const errorMessage = 'Failed to fetch bookings';
      when(() => mockBookingViewModel.state).thenReturn(const BookingError(errorMessage));


      await tester.pumpWidget(createTestWidget(const BookingListScreen()));

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Error: $errorMessage'), findsOneWidget);
    });

    testWidgets('shows "No bookings found" message when state is BookingLoaded with empty list', (tester) async {
      when(() => mockBookingViewModel.state).thenReturn(const BookingLoaded([]));
      await tester.pumpWidget(createTestWidget(const BookingListScreen()));
      expect(find.byIcon(Icons.event_busy), findsOneWidget);
      expect(find.text('No bookings found'), findsOneWidget);
    });

    testWidgets('displays a list of bookings when state is BookingLoaded', (tester) async {
      when(() => mockBookingViewModel.state).thenReturn(BookingLoaded(mockBookings));

      await tester.pumpWidget(createTestWidget(const BookingListScreen()));

      expect(find.byType(Card), findsNWidgets(2));
      expect(find.text('Test Truck'), findsOneWidget);
      expect(find.text('Test Van'), findsOneWidget);
      expect(find.text('City A'), findsOneWidget);
      expect(find.text('City C'), findsOneWidget);
      expect(find.text('CONFIRMED'), findsOneWidget);
    });

    testWidgets('navigates to BookingDetailsPage on tap', (tester) async {
  
      when(() => mockBookingViewModel.state).thenReturn(BookingLoaded(mockBookings));
      await tester.pumpWidget(createTestWidget(const BookingListScreen()));
      await tester.tap(find.text('Test Truck'));
      await tester.pumpAndSettle();
      expect(find.byType(BookingDetailsPage), findsOneWidget);
      expect(find.text('Booking Details'), findsOneWidget);
    });

    testWidgets('triggers refresh event on pull-to-refresh', (tester) async {
      when(() => mockBookingViewModel.state).thenReturn(BookingLoaded(mockBookings));
      await tester.pumpWidget(createTestWidget(const BookingListScreen()));
      clearInteractions(mockBookingViewModel);
      await tester.fling(find.text('Test Truck'), const Offset(0.0, 300.0), 1000.0);
      await tester.pumpAndSettle();
      verify(() => mockBookingViewModel.add(GetUserBookings())).called(1);
    });
  });

  group('BookingDetailsPage Tests', () {
    testWidgets('displays correct details and action buttons', (tester) async {
      when(() => mockBookingViewModel.state).thenReturn(BookingInitial());
      await tester.pumpWidget(createTestWidget(BookingDetailsPage(booking: mockBookings[0])));
      expect(find.text('Test Truck'), findsOneWidget);
      expect(find.text('Heavy Duty'), findsOneWidget);
      expect(find.text('City A'), findsOneWidget);
      expect(find.text('Rs. 5000.00'), findsOneWidget);
      expect(find.text('CONFIRMED'), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('shows confirmation dialog on cancel and triggers event', (tester) async {
      // Arrange
      when(() => mockBookingViewModel.state).thenReturn(BookingInitial());
      await tester.pumpWidget(createTestWidget(BookingDetailsPage(booking: mockBookings[0])));

      
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle(); 
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle(); 

     
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Cancel Booking?'), findsOneWidget);
      await tester.tap(find.text('Yes'));
      await tester.pump();
      verify(() => mockBookingViewModel.add(CancelBooking(mockBookings[0].id!))).called(1);
    });

    testWidgets('shows confirmation dialog on delete and triggers event', (tester) async {
      when(() => mockBookingViewModel.state).thenReturn(BookingInitial());
      await tester.pumpWidget(createTestWidget(BookingDetailsPage(booking: mockBookings[0])));
      // Act
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Delete Booking?'), findsOneWidget);
      await tester.tap(find.text('Yes'));
      await tester.pump();
      verify(() => mockBookingViewModel.add(DeleteBooking(mockBookings[0].id!))).called(1);
    });
  });
}