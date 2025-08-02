import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/app/use_case/use_case.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/repository/get_booking_repository.dart';

class UpdateUserBookingUsecase implements UseCaseWithParams<void, UpdateBookingParams> {
  final IBookingRepository _bookingRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UpdateUserBookingUsecase({
    required IBookingRepository bookingRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _bookingRepository = bookingRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(UpdateBookingParams params) async {
    final tokenResult = await _tokenSharedPrefs.getToken();

    // Handle token retrieval failure
    if (tokenResult.isLeft()) {
      return Left(tokenResult.swap().getOrElse(() => ApiFailure(message: "Token fetch failed")));
    }
    final tokenValue = tokenResult.getOrElse(() => null);

    // Handle null token
    if (tokenValue == null) {
      return Left(ApiFailure(message: "User not logged in"));
    }

    // Call the repository method
    return await _bookingRepository.updateUserBooking(params.id, params.data, tokenValue);
  }
}

// Parameters class for clarity and scalability
class UpdateBookingParams extends Equatable {
  final String id;
  final Map<String, dynamic> data;

  const UpdateBookingParams({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}