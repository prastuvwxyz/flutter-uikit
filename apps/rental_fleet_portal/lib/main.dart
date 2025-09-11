import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:design_system/design_system.dart';
import 'config/routes.dart';

void main() {
  usePathUrlStrategy();
  runApp(const RentalFleetPortalApp());
}

class RentalFleetPortalApp extends StatelessWidget {
  const RentalFleetPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = UiTokens.standard();
    
    return MaterialApp.router(
      title: 'Rental Fleet Portal',
      routerConfig: AppRoutes.router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: tokens.colorTokens.primary.shade500,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
        extensions: [tokens],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: tokens.colorTokens.primary.shade500,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
        extensions: [tokens.dark],
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
