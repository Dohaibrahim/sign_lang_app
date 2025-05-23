import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_lang_app/core/errors/build_error.dart';
import 'package:sign_lang_app/core/routing/routes.dart';
import 'package:sign_lang_app/core/utils/extentions.dart';
import 'package:sign_lang_app/core/widgets/custom_background_color.dart';
import 'package:sign_lang_app/core/widgets/top_snackbar.dart';
import 'package:sign_lang_app/features/auth/presentation/manager/signup_cubit/signup_cubit.dart';
import 'package:sign_lang_app/features/auth/presentation/widgets/register_view_body.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          context.pushReplacementNamed(Routes.loginScreen);
          TopSnackBar.show(
                  context,
                  title:  'User Created ',
                  message: 'User Account Created Success ',
                  contentType: ContentType.success,
                  color: Color(0xff19A7CE),
                );
        }
        if (state is SignupFailure) {
          buildErrorBar(context, state.errorMessage);
        }
      },
      child: const CustomStack(child: RegisterViewBody()),
    ));
  }
}
