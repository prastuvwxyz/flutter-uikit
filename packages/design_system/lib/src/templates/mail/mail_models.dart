import 'package:flutter/foundation.dart';

enum MailLayout { adaptive, sidebar, mobile }

@immutable
class MailFolder {
  final String id;
  final String name;
  final int unreadCount;

  const MailFolder(
      {required this.id, required this.name, this.unreadCount = 0});
}

@immutable
class MailMessage {
  final String id;
  final String subject;
  final String body;
  final String from;
  final List<String> to;
  final DateTime date;
  final bool starred;

  const MailMessage({
    required this.id,
    required this.subject,
    required this.body,
    required this.from,
    required this.to,
    required this.date,
    this.starred = false,
  });
}
