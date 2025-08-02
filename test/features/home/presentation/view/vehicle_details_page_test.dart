// import 'package:bloc_test/bloc_test.dart';
// import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_event.dart';
// import 'package:finalyearproject/features/home/presentation/view/vehicle_details_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mocktail/mocktail.dart';

// import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
// import 'package:finalyearproject/features/home/domain/use_case/create_booking_usecase.dart';
// import 'package:finalyearproject/features/home/presentation/view/booking_view.dart';
// import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_view_model.dart';
// import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_state.dart'; // Import your states here

// // Mock Classes
// class MockCreateBookingUsecase extends Mock implements CreateBookingUsecase {}

// class MockBookingBloc extends Mock implements BookingBloc {}

// class FakeBookingEvent extends Fake implements BookingEvent {}

// class FakeBookingState extends Fake implements BookingState {}

// // Mock NavigatorObserver to verify navigation
// class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// void main() {
//   late MockCreateBookingUsecase mockCreateBookingUsecase;
//   late MockBookingBloc mockBookingBloc;
//   late MockNavigatorObserver mockNavigatorObserver;

//   setUpAll(() {
//     registerFallbackValue(FakeBookingEvent());
//     registerFallbackValue(FakeBookingState());
//   });

//   setUp(() {
//     mockCreateBookingUsecase = MockCreateBookingUsecase();
//     mockBookingBloc = MockBookingBloc();
//     mockNavigatorObserver = MockNavigatorObserver();

//     // Stub the BookingBloc state and stream
//     when(() => mockBookingBloc.state).thenReturn( BookingInitial());
//     whenListen(mockBookingBloc, Stream<BookingState>.empty());
//   });

//   Widget createTestWidget(VehicleEntity vehicle) {
//     return MaterialApp(
//       home: RepositoryProvider<CreateBookingUsecase>.value(
//         value: mockCreateBookingUsecase,
//         child: VehicleDetailsView(vehicle: vehicle),
//       ),
//       navigatorObservers: [mockNavigatorObserver],
//     );
//   }

//   testWidgets('VehicleDetailsView displays vehicle info and navigates on Rent Now',
//       (WidgetTester tester) async {
//     final vehicle = VehicleEntity(
//       id: '1',
//       vehicleName: 'Toyota Hilux',
//       vehicleType: 'Pickup Truck',
//       filepath: 'hilux.png',
//       fuelCapacityLitres: 80,
//       loadCapacityKg: 1200,
//       passengerCapacity: '5',
//       pricePerTrip: 3000,
//       vehicleDescription: 'A strong and reliable pickup truck.',
//     );

//     await tester.pumpWidget(createTestWidget(vehicle));
//     await tester.pumpAndSettle();

//     // Verify UI elements are displayed
//     expect(find.text('Toyota Hilux'), findsOneWidget);
//     expect(find.text('Pickup Truck'), findsOneWidget);
//     expect(find.text('NPR 3000'), findsOneWidget);
//     expect(find.text('/trip'), findsOneWidget);
//     expect(find.text('80L'), findsOneWidget);
//     expect(find.text('1200kg'), findsOneWidget);
//     expect(find.text('5'), findsOneWidget);
//     expect(find.text('Description'), findsOneWidget);
//     expect(find.text('A strong and reliable pickup truck.'), findsOneWidget);

//     // Find Rent Now button and tap it
//     final rentNowButton = find.text('Rent Now');
//     expect(rentNowButton, findsOneWidget);

//     await tester.tap(rentNowButton);
//     await tester.pump(const Duration(milliseconds: 500));

//     // Verify navigation happened once
//     verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
//   });
// }
