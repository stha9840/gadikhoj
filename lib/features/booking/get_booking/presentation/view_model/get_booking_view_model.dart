
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/cancel_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/delete_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/get_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/update_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_event.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingViewModel extends Bloc<BookingEvent, BookingState> {
  final GetUserBookingsUsecase _getUserBookingsUsecase;
  final CancelUserBookingUsecase _cancelUserBookingUsecase;
  final DeleteUserBookingUsecase _deleteUserBookingUsecase;
  final UpdateUserBookingUsecase _updateUserBookingUsecase;

  BookingViewModel({
    required GetUserBookingsUsecase getUserBookingsUsecase,
    required CancelUserBookingUsecase cancelUserBookingUsecase,
    required DeleteUserBookingUsecase deleteUserBookingUsecase,
    required UpdateUserBookingUsecase updateUserBookingUsecase,
  })  : _getUserBookingsUsecase = getUserBookingsUsecase,
        _cancelUserBookingUsecase = cancelUserBookingUsecase,
        _deleteUserBookingUsecase = deleteUserBookingUsecase,
        _updateUserBookingUsecase = updateUserBookingUsecase,
        super(BookingInitial()) {
    // Handler for fetching user bookings
    on<GetUserBookings>((event, emit) async {
      emit(BookingLoading());
      final result = await _getUserBookingsUsecase();
      result.fold(
        (failure) => emit(BookingError(failure.message)),
        (bookings) => emit(BookingLoaded(bookings)),
      );
    });

    // Handler for canceling a booking
    on<CancelBooking>((event, emit) async {
      emit(BookingLoading());
      final result = await _cancelUserBookingUsecase(event.bookingId);
      result.fold(
        (failure) => emit(BookingError(failure.message)),
        (_) => add(GetUserBookings()), // On success, refresh the list
      );
    });

    // Handler for deleting a booking
    on<DeleteBooking>((event, emit) async {
      emit(BookingLoading());
      final result = await _deleteUserBookingUsecase(event.bookingId);
      result.fold(
        (failure) => emit(BookingError(failure.message)),
        (_) => add(GetUserBookings()), // On success, refresh the list
      );
    });

    // Handler for updating a booking
    on<UpdateBooking>((event, emit) async {
      emit(BookingLoading());
      final params = UpdateBookingParams(id: event.bookingId, data: event.data);
      final result = await _updateUserBookingUsecase(params);
      result.fold(
        (failure) => emit(BookingError(failure.message)),
        (_) => add(GetUserBookings()), // On success, refresh the list
      );
    });
  }
}