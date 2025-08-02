import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/home/domain/use_case/create_booking_usecase.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_event.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_state.dart';

class MockCreateBookingUsecase extends Mock implements CreateBookingUsecase {}

void main() {
  late BookingBloc bookingBloc;
  late MockCreateBookingUsecase mockCreateBookingUsecase;

  setUp(() {
    mockCreateBookingUsecase = MockCreateBookingUsecase();

    registerFallbackValue(
      CreateBookingParams(
        vehicleId: '',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        pickupLocation: '',
        dropLocation: '',
        totalPrice: 0,
      ),
    );

    bookingBloc = BookingBloc(createBookingUsecase: mockCreateBookingUsecase);
  });

  final testParams = CreateBookingParams(
    vehicleId: '123',
    startDate: DateTime(2025, 8, 10),
    endDate: DateTime(2025, 8, 12),
    pickupLocation: 'Location A',
    dropLocation: 'Location B',
    totalPrice: 5000,
  );

  blocTest<BookingBloc, BookingState>(
    'emits [BookingSubmitting, BookingSuccess] when booking is successful',
    build: () {
      when(() => mockCreateBookingUsecase.call(any()))
          .thenAnswer((_) async => Right(unit));
      return bookingBloc;
    },
    act: (bloc) => bloc.add(
      SubmitBooking(
        vehicleId: testParams.vehicleId,
        startDate: testParams.startDate,
        endDate: testParams.endDate,
        pickupLocation: testParams.pickupLocation,
        dropLocation: testParams.dropLocation,
        totalPrice: testParams.totalPrice,
      ),
    ),
    expect: () => [
      BookingSubmitting(),
      BookingSuccess(),
    ],
    verify: (_) {
      verify(() => mockCreateBookingUsecase.call(any())).called(1);
    },
  );

  blocTest<BookingBloc, BookingState>(
    'emits [BookingSubmitting, BookingFailure] when booking fails',
    build: () {
      when(() => mockCreateBookingUsecase.call(any()))
          .thenAnswer((_) async => Left(ApiFailure(message: 'Failed to create booking')));
      return bookingBloc;
    },
    act: (bloc) => bloc.add(
      SubmitBooking(
        vehicleId: testParams.vehicleId,
        startDate: testParams.startDate,
        endDate: testParams.endDate,
        pickupLocation: testParams.pickupLocation,
        dropLocation: testParams.dropLocation,
        totalPrice: testParams.totalPrice,
      ),
    ),
    expect: () => [
      BookingSubmitting(),
      BookingFailure('Failed to create booking'),
    ],
    verify: (_) {
      verify(() => mockCreateBookingUsecase.call(any())).called(1);
    },
  );
}
