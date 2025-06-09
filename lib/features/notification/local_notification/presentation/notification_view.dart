import 'package:flutter/material.dart';
import 'package:sign_lang_app/features/notification/local_notification/presentation/widgets/notification_view_body.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: NotificationViewBody(),
    );
  }
}
