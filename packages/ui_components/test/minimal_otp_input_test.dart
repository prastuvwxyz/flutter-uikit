import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/otp_input/minimal_otp_input.dart';
import 'package:ui_components/src/otp_input/otp_controller.dart';

void main() {
  testWidgets('onCompleted triggers when full', (WidgetTester tester) async {
    final controller = OTPController();
    String? completed;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinimalOTPInput(
            length: 4,
            controller: controller,
            onCompleted: (value) => completed = value,
          ),
        ),
      ),
    );

    // enter digits into the 4 fields
    for (var i = 0; i < 4; i++) {
      await tester.enterText(find.byType(TextField).at(i), '${i + 1}');
    }

    // controller should aggregate
    expect(completed, isNull);
    controller.text = '1234';
    await tester.pumpAndSettle();
    expect(completed, '1234');
  });
}
