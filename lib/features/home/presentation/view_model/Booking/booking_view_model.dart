// booking_bloc.dart
import 'package:finalyearproject/features/home/domain/use_case/create_booking_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import 'package:finalyearproject/core/error/failure.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUsecase createBookingUsecase;

  BookingBloc({required this.createBookingUsecase}) : super(BookingInitial()) {
    on<SubmitBooking>((event, emit) async {
      emit(BookingSubmitting());

      final result = await createBookingUsecase.call(
        CreateBookingParams(
          vehicleId: event.vehicleId,
          startDate: event.startDate,
          endDate: event.endDate,
          pickupLocation: event.pickupLocation,
          dropLocation: event.dropLocation,
          totalPrice: event.totalPrice,
        ),
      );

      result.fold(
        (failure) => emit(BookingFailure(_mapFailureToMessage(failure))),
        (_) => emit(BookingSuccess()),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    // Customize message handling as needed
    return failure.message ?? 'Unexpected error';
  }
}
