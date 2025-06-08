abstract class ForgetPasswordState {}

class ForgetPasswordInitialState extends ForgetPasswordState {}

class ForgetPasswordLoadingState extends ForgetPasswordState {}

class ForgetPasswordSuccessState extends ForgetPasswordState {
  final String message;

  ForgetPasswordSuccessState({
    required this.message,
  });
}

class ForgetPasswordFailureState extends ForgetPasswordState {
  final String message;

  ForgetPasswordFailureState({required this.message});
}
