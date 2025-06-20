import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_lang_app/core/di/dependency_injection.dart';
import 'package:sign_lang_app/core/routing/routes.dart';
import 'package:sign_lang_app/core/utils/constants.dart';
import 'package:sign_lang_app/core/utils/extentions.dart';
import 'package:sign_lang_app/core/widgets/app_text_form_field.dart';
import 'package:sign_lang_app/features/auth/presentation/widgets/loading_button.dart';
import 'package:sign_lang_app/features/setting/data/models/edit_info_request.dart';
import 'package:sign_lang_app/features/setting/domain/usecases/edit_info_usecase.dart';
import 'package:sign_lang_app/features/setting/presentation/Edit_info_cubit/edit_info_cubit.dart';
import 'package:sign_lang_app/features/setting/presentation/widgets/pick_profile_image.dart';
import '../../../../core/theming/styles.dart';
import 'package:sign_lang_app/core/utils/sharedprefrence.dart';

class EditProfileViewBody extends StatefulWidget {
  final String currentUserName;
  final String currentUserEmail;

  const EditProfileViewBody({
    super.key,
    required this.currentUserName,
    required this.currentUserEmail,
  });

  @override
  State<EditProfileViewBody> createState() => _EditProfileViewBodyState();
}

class _EditProfileViewBodyState extends State<EditProfileViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late String userName;
  late String userEmail;
  String? updatedImagePath; // لحفظ الصورة الجديدة مؤقتًا

  @override
  void initState() {
    super.initState();
    userName = widget.currentUserName;
    userEmail = widget.currentUserEmail;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: height * 0.12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit Profile",
                      style:
                          TextStyles.font32PrimaryExtraBold.copyWith(fontSize: 40),
                    ),
                    Text(
                      'Edit your profile',
                      style:
                          TextStyles.font16GraySemibold.copyWith(fontSize: 22),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30.h),

            // Pick profile image and capture path
            PickProfileImage(
              currentUserName: userName,
              // onImageSelected: (path) {
              //   updatedImagePath = path;
              // },
            ),

            AppTextFormField(
              hintText: 'Name',
              initialValue: userName,
              onSaved: (value) {
                userName = value!;
              },
            ),
            const SizedBox(height: 20),
            AppTextFormField(
              hintText: 'Email',
              initialValue: userEmail,
              onSaved: (value) {
                userEmail = value!;
              },
            ),
            SizedBox(height: 30.h),

            BlocListener<EditInfoCubit, EditInfoState>(
              listener: (context, state) async {
                if (state is EditInfoSuccess) {
                  // // ✅ بعد نجاح التعديل، خزّن الصورة لو كانت اتغيرت
                  // if (updatedImagePath != null) {
                  //   await SharedPrefHelper.setData(
                  //       SharedPrefKeys.profileImagePath, updatedImagePath);
                  // }
                  Navigator.pushNamed(context, Routes.SettingView); // نرجع true لما يحصل تعديل
                }
              },
              child: BlocBuilder<EditInfoCubit, EditInfoState>(
                builder: (context, state) {
                  return LoadingButton(
                    title: 'Edit Information',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        await SharedPrefHelper.setData(
                            SharedPrefKeys.username, userName);
                        await SharedPrefHelper.setData(
                            SharedPrefKeys.userEmail, userEmail);

                        context.read<EditInfoCubit>().execute(
                              usecase: getIt<EditInfoUsecase>(),
                              params: EditInfoReqParams(
                                name: userName,
                                email: userEmail,
                              ),
                            );
                      }
                    },
                    btnKey: EditInfoCubit.get(context).btnKey,
                  );
                },
              ),
            ),

            MaterialButton(
              padding: EdgeInsets.zero,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                context.pushNamed(
                  Routes.changePassword,
                  arguments: {'userEmail': userEmail},
                );
              },
              child: Text(
                'Change your password',
                style: TextStyles.font32PrimaryExtraBold.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
