import 'package:dartz/dartz.dart';
import 'package:sign_lang_app/core/errors/failure.dart';
import 'package:sign_lang_app/features/auth/data/models/forget_password_model.dart';
import 'package:sign_lang_app/features/auth/data/models/reset_password_model.dart';
import 'package:sign_lang_app/features/auth/data/models/signIn_response.dart';
import 'package:sign_lang_app/features/auth/data/models/signin_req.dart';
import 'package:sign_lang_app/features/auth/data/models/signup_req.dart';
import 'package:sign_lang_app/features/auth/data/models/signup_response.dart';

abstract class AuthRepo {
  Future<Either<Failure, SignupResponse>> signUp(SignupReqParams params);

  Future<Either<Failure, LoginResponse>> signIn(SigninReqParams params);

  Future<Either<Failure, ForgetPasswordResponse>> forgetPassword(
      ForgetPasswordReq forgetPasswordReq);

  Future<Either<Failure, ResetPasswordResponse>> resetPassword(
      ResetPasswordReq resetPasswordReq, String token);
}
