abstract class ResetPasswordState {}

class ResetPasswordInitialState extends ResetPasswordState {}

class ResetPasswordLoadingState extends ResetPasswordState {}

class ResetPasswordSuccessState extends ResetPasswordState {
  final String message;

  ResetPasswordSuccessState({required this.message});
}

class ResetPasswordFailureState extends ResetPasswordState {
  final String message;
  ResetPasswordFailureState({required this.message});
}
