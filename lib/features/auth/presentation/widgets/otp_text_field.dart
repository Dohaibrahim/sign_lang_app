import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpTextField extends StatelessWidget {
  const OtpTextField({super.key, required this.onSaved});
  final void Function(String?)? onSaved;
  //final TextEditingController otpController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: TextFormField(
        //controller: otpController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
        onSaved: onSaved,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
