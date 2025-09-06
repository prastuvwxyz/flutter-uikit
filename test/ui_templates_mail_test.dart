import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../packages/ui_templates/lib/ui_templates.dart';
import 'package:flutter/widgets.dart';

void main() {
  testWidgets('MailTemplate basic interactions', (WidgetTester tester) async {
    var composeCalled = false;
    MailFolder? selectedFolder;
    MailMessage? selectedMessage;

    final folders = [
      const MailFolder(id: 'inbox', name: 'Inbox', unreadCount: 2),
      const MailFolder(id: 'sent', name: 'Sent'),
    ];

    final messages = [
      MailMessage(
        id: 'm1',
        subject: 'Hello',
        body: 'Hi there',
        from: 'a@example.com',
        to: ['you@example.com'],
        date: DateTime.now(),
      ),
      MailMessage(
        id: 'm2',
        subject: 'Meeting',
        body: 'Let\'s meet',
        from: 'b@example.com',
        to: ['you@example.com'],
        date: DateTime.now(),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MailTemplate(
          folders: folders,
          messages: messages,
          onCompose: () => composeCalled = true,
          onFolderSelected: (f) => selectedFolder = f,
          onMessageSelected: (m) => selectedMessage = m,
        ),
      ),
    );

    // Ensure compose button exists and tap it
    expect(find.text('Compose'), findsOneWidget);
    await tester.tap(find.text('Compose'));
    await tester.pumpAndSettle();
    expect(composeCalled, isTrue);

    // Tap folder
    await tester.tap(find.text('Sent'));
    await tester.pumpAndSettle();
    expect(selectedFolder?.id, 'sent');

    // Tap message in list
    await tester.tap(find.text('Hello'));
    await tester.pumpAndSettle();
    expect(selectedMessage?.id, 'm1');
  });
}
