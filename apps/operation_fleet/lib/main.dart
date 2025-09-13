import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'core/routes.dart';
import 'core/theme.dart';

void main() {
  usePathUrlStrategy();

  runApp(const ProviderScope(child: OperationFleetApp()));
}

class OperationFleetApp extends ConsumerWidget {
  const OperationFleetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Operation Fleet',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
