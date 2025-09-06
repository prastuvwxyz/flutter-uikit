import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/responsive/responsive.dart';

void main() {
  testWidgets('Shows mobile child on small width', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(320, 800)),
          child: const MinimalResponsive(mobile: Text('mobile')),
        ),
      ),
    );

    expect(find.text('mobile'), findsOneWidget);
  });

  testWidgets('Builder receives correct ScreenType', (tester) async {
    ScreenType? received;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(1024, 800)),
          child: MinimalResponsive(
            builder: (ctx, type) {
              received = type;
              return const Text('built');
            },
          ),
        ),
      ),
    );

    expect(find.text('built'), findsOneWidget);
    expect(received, ScreenType.tablet);
  });
}
