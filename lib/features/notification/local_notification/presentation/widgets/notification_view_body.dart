import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sign_lang_app/features/notification/local_notification/notification_model.dart';

class NotificationViewBody extends StatelessWidget {
  const NotificationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<NotificationModel>('notificationsBox');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 15),
        itemCount: box.length,
        itemBuilder: (context, index) {
          final notification = box.getAt(index);
          DateTime localTime = notification!.scheduledTime.toLocal();
          String label = getRelativeDayLabel(localTime);
          String time = DateFormat.Hm().format(localTime);
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.transparent),
                    color: Theme.of(context).colorScheme.inverseSurface),
                child: ListTile(
                  leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.green[100],
                      child: Image.asset("assets/images/static_point_up1.png")),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.title ?? '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20),
                      ),
                      Text(
                        '$label at $time',
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSecondaryFixed,
                            fontSize: 13),
                      )
                    ],
                  ),
                  subtitle: Text(
                    notification.body,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        },
      ),
    );
  }

  String getRelativeDayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(date.year, date.month, date.day);

    final difference = today.difference(aDate).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference == -1) return 'Tomorrow';

    return DateFormat.EEEE().format(date); // Returns "Monday", "Tuesday", etc.
  }
}
