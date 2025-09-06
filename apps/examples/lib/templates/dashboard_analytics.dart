import 'package:flutter/material.dart';
import '../../../../packages/ui_templates/lib/ui_templates.dart';

class DashboardAnalyticsPage extends StatelessWidget {
  const DashboardAnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DashboardTemplate(
      body: Padding(padding: EdgeInsets.all(16.0), child: _DemoGrid()),
    );
  }
}

class _DemoGrid extends StatelessWidget {
  const _DemoGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 1,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: List.generate(
        6,
        (i) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card ${i + 1}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Expanded(child: Center(child: Text('Chart placeholder'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
