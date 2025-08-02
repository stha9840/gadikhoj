// booking_bloc.dart
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_event.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/get_user_booking_use_case.dart';

class GetBookingBloc extends Bloc<GetBookingEvent, GetBookingState> {
  final GetUserBookingsUsecase getUserBookingsUsecase;

  GetBookingBloc({required this.getUserBookingsUsecase}) : super(BookingInitial()) {
    on<GetUserBookingsEvent>((event, emit) async {
      emit(BookingLoading());

      final result = await getUserBookingsUsecase();

      result.fold(
        (failure) => emit(BookingError(failure.message)),
        (bookings) => emit(BookingLoaded(bookings)),
      );
    });
  }
}
