import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 11)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String body;

  @HiveField(2)
  final DateTime scheduledTime;

  NotificationModel({
    required this.title,
    required this.body,
    required this.scheduledTime,
  });
}
