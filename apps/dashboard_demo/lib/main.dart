import 'package:flutter/material.dart';
import 'package:ui_templates/ui_templates.dart';

void main() {
  runApp(const DashboardDemoApp());
}

class DashboardDemoApp extends StatefulWidget {
  const DashboardDemoApp({Key? key}) : super(key: key);

  @override
  State<DashboardDemoApp> createState() => _DashboardDemoAppState();
}

class _DashboardDemoAppState extends State<DashboardDemoApp> {
  bool _isDark = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData light = ThemeData.light().copyWith(
      colorScheme: ThemeData.light().colorScheme.copyWith(
            background: Colors.grey.shade50,
            surface: Colors.white,
          ),
    );

    final ThemeData dark = ThemeData.dark().copyWith(
      colorScheme: ThemeData.dark().colorScheme.copyWith(
            background: const Color(0xFF0F1720),
            surface: const Color(0xFF0B1220),
          ),
      scaffoldBackgroundColor: const Color(0xFF0F1720),
    );

    return MaterialApp(
      title: 'Dashboard Demo',
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: DashboardTemplate(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: AppBar(
            backgroundColor: _isDark ? const Color(0xFF0B1220) : Colors.white,
            elevation: 0,
            title: Row(
              children: [
                Text('Minimal Dashboard',
                    style: TextStyle(
                        color: _isDark ? Colors.white : Colors.black)),
                const Spacer(),
                IconButton(
                  icon: Icon(_isDark ? Icons.dark_mode : Icons.light_mode,
                      color: _isDark ? Colors.white : Colors.black),
                  onPressed: () => setState(() => _isDark = !_isDark),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cross = constraints.maxWidth > 1200
                  ? 3
                  : constraints.maxWidth > 800
                      ? 2
                      : 1;
              return GridView.count(
                crossAxisCount: cross,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: List.generate(6, (i) => _DashboardCard(index: i)),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final int index;
  const _DashboardCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    return Card(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Widget ${index + 1}', style: theme.textTheme.titleMedium),
                const Spacer(),
                Icon(Icons.more_vert, size: 18, color: theme.hintColor),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.12)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                    child: Text('Chart placeholder',
                        style: theme.textTheme.bodySmall)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('View')),
                const SizedBox(width: 8),
                TextButton(onPressed: () {}, child: const Text('Details')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
