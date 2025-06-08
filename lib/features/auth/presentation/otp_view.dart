import 'package:flutter/material.dart';
import 'package:sign_lang_app/features/auth/presentation/widgets/otp_view_body.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: OtpViewBody(email: args),
    );
  }
}
