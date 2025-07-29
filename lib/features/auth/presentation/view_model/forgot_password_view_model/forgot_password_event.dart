import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object> get props => [];
}

class SendResetLinkEvent extends ForgotPasswordEvent {
  final String email;
  const SendResetLinkEvent(this.email);
}

class SubmitNewPasswordEvent extends ForgotPasswordEvent {
  final String token;
  final String password;
  const SubmitNewPasswordEvent(this.token, this.password);
}