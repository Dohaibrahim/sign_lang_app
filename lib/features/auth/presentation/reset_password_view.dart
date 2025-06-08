import 'package:flutter/material.dart';
import 'package:sign_lang_app/features/auth/presentation/widgets/reset_password_view_body.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        body: ResetPasswordViewBody(otp: args["otp"], email: args["email"]));
  }
}
