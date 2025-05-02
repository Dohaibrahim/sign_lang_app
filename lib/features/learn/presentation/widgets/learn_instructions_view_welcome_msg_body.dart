import 'package:flutter/material.dart';
import 'package:sign_lang_app/core/utils/extentions.dart';
import 'package:sign_lang_app/features/learn/presentation/widgets/continue_button.dart';

import '../../../../core/routing/routes.dart';
import 'nova_message.dart';

class LearnInstructionsWelcomeMsgViewBody extends StatelessWidget {
  const LearnInstructionsWelcomeMsgViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.28,
        ),
        SizedBox(
          height: screenHeight * 0.07,
          width: screenWidth,
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.50),
              const NovaMessage(
                text: 'Hi there! i\'m Eve',
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: screenWidth * .10,
          ),
          child: Image.asset(
            //"assets/images/static_wave_smile03(1)copy.png",
            "assets/images/static_wave_smile03(1).png",
            width: screenWidth * 0.93,
            height: screenHeight * 0.44,
          ),
        ),
        //SizedBox(height: screenHeight * 0.05,),
        ContinueButton(
          text: 'Continue',
          onPressed: () {
            context.pushNamed(Routes.learnInstructionsLetsStartView);
            //context.pushReplacementNamed(Routes.learnInstructionsLetsStartView);
          },
        ),
      ],
    );
  }
}
