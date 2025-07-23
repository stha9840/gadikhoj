import 'package:dartz/dartz.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/app/use_case/use_case.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/repository/get_booking_repository.dart';

class DeleteUserBookingUsecase implements UseCaseWithParams<void, String> {
  final IBookingRepository _bookingRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  DeleteUserBookingUsecase({
    required IBookingRepository bookingRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _bookingRepository = bookingRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(String bookingId) async {
    final tokenResult = await _tokenSharedPrefs.getToken();

    if (tokenResult.isLeft()) {
      return Left(tokenResult.swap().getOrElse(() => ApiFailure(message: "Token fetch failed")));
    }
    final tokenValue = tokenResult.getOrElse(() => null);

    if (tokenValue == null) {
      return Left(ApiFailure(message: "User not logged in"));
    }

    return await _bookingRepository.deleteUserBooking(bookingId, tokenValue);
  }
}