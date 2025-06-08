import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_lang_app/core/routing/routes.dart';
import 'package:sign_lang_app/core/theming/styles.dart';
import 'package:sign_lang_app/core/widgets/app_text_button.dart';
import 'package:sign_lang_app/features/auth/presentation/widgets/otp_text_field.dart';

class OtpViewBody extends StatefulWidget {
  const OtpViewBody({super.key, required this.email});
  final String email;
  @override
  State<OtpViewBody> createState() => _OtpViewBodyState();
}

class _OtpViewBodyState extends State<OtpViewBody> {
  String? val1, val2, val3, val4, val5, val6;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: screenHeight * 0.20,
            ),
            Text(
              'Enter OTP at your email',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  //color: Colors.grey[700],
                  fontSize: 33,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Text('Please check your email and type the code we sent',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 25)),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Form(
              autovalidateMode: autovalidateMode,
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OtpTextField(
                    onSaved: (data) {
                      val1 = data;
                    },
                  ),
                  OtpTextField(
                    onSaved: (data) {
                      val2 = data;
                    },
                  ),
                  OtpTextField(
                    onSaved: (data) {
                      val3 = data;
                    },
                  ),
                  OtpTextField(
                    onSaved: (data) {
                      val4 = data;
                    },
                  ),
                  OtpTextField(
                    onSaved: (data) {
                      val5 = data;
                    },
                  ),
                  OtpTextField(
                    onSaved: (data) {
                      val6 = data;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.15,
            ),
            AppTextButton(
                buttonText: 'Done',
                textStyle: TextStyles.font14DarkBlueMedium
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 20),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    log("$val1$val2$val3$val4$val5$val6");
                    Navigator.pushReplacementNamed(
                        context, Routes.newPasswordView, arguments: {
                      "otp": "$val1$val2$val3$val4$val5$val6",
                      "email": widget.email
                    });
                  }
                })
          ],
        ),
      ),
    );
  }
}
