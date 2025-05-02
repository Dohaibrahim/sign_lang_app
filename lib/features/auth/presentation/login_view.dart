import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_lang_app/core/errors/build_error.dart';
import 'package:sign_lang_app/core/routing/routes.dart';
import 'package:sign_lang_app/core/utils/extentions.dart';
import 'package:sign_lang_app/core/utils/profile_image_service.dart';
import 'package:sign_lang_app/core/widgets/custom_background_color.dart';
import 'package:sign_lang_app/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:sign_lang_app/features/auth/presentation/widgets/login_view_body.dart';
import 'package:sign_lang_app/features/notification/cloud_notification/data/data_source/notification_remote_data_source.dart';
import 'package:sign_lang_app/features/notification/cloud_notification/domain/repo/notification_repo.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccess) {
              final args = {
                'userImage': state.userImage,
                'userName': state.userName,
                'userEmail': state
                    .userEmail, // Ensure you have this in your LoginSuccess state
              };
              ProfileImageService.saveProfileImagePath(state.userImage);
              context.pushReplacementNamed(
                Routes.bottomNavigation,
                arguments: args,
              );
              buildErrorBar(context, state.message);
              await NotificationRepoImpl(
                      notificationRemoteDataSource:
                          NotificationRemoteDataSourceImpl())
                  .subscribeToTopic('daily_updates');
            }
            if (state is LoginFailure) {
              buildErrorBar(context, state.errorMessage);
            }
          },
          child: dark ? _isDarkTheme() : _isLightTheme()),
    );
  }
}

Widget _isLightTheme() {
  return const LoginViewBody();
}

Widget _isDarkTheme() {
  return const CustomStack(width: double.maxFinite, child: LoginViewBody());
}
