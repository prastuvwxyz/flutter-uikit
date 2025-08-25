import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';
import 'package:ui_tokens/ui_tokens.dart';

void main() {
  group('MinimalAlert Golden Tests', () {
    Widget buildAlertWrapper(Widget child) {
      return MaterialApp(
        theme: ThemeData(extensions: [UiTokens.standard()]),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(width: 400, child: child),
            ),
          ),
        ),
      );
    }

    testWidgets('renders success alert correctly', (tester) async {
      await tester.pumpWidget(
        buildAlertWrapper(
          const MinimalAlert(
            type: AlertType.success,
            title: 'Success',
            message: 'Your changes have been saved successfully.',
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalAlert),
        matchesGoldenFile('goldens/minimal_alert_success.png'),
      );
    });

    testWidgets('renders warning alert correctly', (tester) async {
      await tester.pumpWidget(
        buildAlertWrapper(
          const MinimalAlert(
            type: AlertType.warning,
            title: 'Warning',
            message: 'Please review your information before continuing.',
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalAlert),
        matchesGoldenFile('goldens/minimal_alert_warning.png'),
      );
    });

    testWidgets('renders error alert correctly', (tester) async {
      await tester.pumpWidget(
        buildAlertWrapper(
          const MinimalAlert(
            type: AlertType.error,
            title: 'Error',
            message: 'There was a problem processing your request.',
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalAlert),
        matchesGoldenFile('goldens/minimal_alert_error.png'),
      );
    });

    testWidgets('renders info alert correctly', (tester) async {
      await tester.pumpWidget(
        buildAlertWrapper(
          const MinimalAlert(
            type: AlertType.info,
            title: 'Information',
            message: 'The system will be under maintenance on Sunday.',
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalAlert),
        matchesGoldenFile('goldens/minimal_alert_info.png'),
      );
    });

    testWidgets('renders with actions correctly', (tester) async {
      await tester.pumpWidget(
        buildAlertWrapper(
          MinimalAlert(
            type: AlertType.warning,
            title: 'Delete Confirmation',
            message: 'Are you sure you want to delete this item?',
            actions: [
              TextButton(onPressed: () {}, child: const Text('Cancel')),
              TextButton(onPressed: () {}, child: const Text('Delete')),
            ],
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalAlert),
        matchesGoldenFile('goldens/minimal_alert_with_actions.png'),
      );
    });

    testWidgets('renders outlined variant correctly', (tester) async {
      await tester.pumpWidget(
        buildAlertWrapper(
          const MinimalAlert(
            type: AlertType.info,
            title: 'Information',
            message: 'This is an outlined alert variant.',
            variant: AlertVariant.outlined,
          ),
        ),
      );

      await expectLater(
        find.byType(MinimalAlert),
        matchesGoldenFile('goldens/minimal_alert_outlined.png'),
      );
    });
  });
}
