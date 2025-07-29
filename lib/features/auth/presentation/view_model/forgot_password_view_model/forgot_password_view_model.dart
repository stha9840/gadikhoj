import 'package:finalyearproject/features/auth/domain/use_case/request_password_reset_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/forgot_password_view_model/forgot_password_event.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/forgot_password_view_model/forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordViewModel extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final RequestPasswordResetUsecase _requestUsecase;
  final ResetPasswordUsecase _resetUsecase;

  ForgotPasswordViewModel({
    required RequestPasswordResetUsecase requestUsecase,
    required ResetPasswordUsecase resetUsecase,
  })  : _requestUsecase = requestUsecase,
        _resetUsecase = resetUsecase,
        super(ForgotPasswordInitial()) {

    on<SendResetLinkEvent>((event, emit) async {
      emit(ForgotPasswordLoading());
      final result = await _requestUsecase(event.email);
      result.fold(
        (failure) => emit(ForgotPasswordFailure(failure.message)),
        (_) => emit(ForgotPasswordLinkSent()),
      );
    });

    on<SubmitNewPasswordEvent>((event, emit) async {
      emit(ForgotPasswordLoading());
      final result = await _resetUsecase(event.token, event.password);
      result.fold(
        (failure) => emit(ForgotPasswordFailure(failure.message)),
        (_) => emit(ForgotPasswordSuccess()),
      );
    });
  }
}