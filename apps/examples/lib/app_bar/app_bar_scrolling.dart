import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example showcasing a scrolling MinimalAppBar.
class ScrollingAppBarExample extends StatelessWidget {
  /// Creates a new [ScrollingAppBarExample].
  const ScrollingAppBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar that responds to scrolling with elevation change
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverAppBar(
                  title: const Text('Scrolling App Bar'),
                  centerTitle: true,
                  floating: true,
                  snap: true,
                  pinned: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Tab 1'),
                      Tab(text: 'Tab 2'),
                      Tab(text: 'Tab 3'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _ScrollableContent(title: 'Tab 1'),
              _ScrollableContent(title: 'Tab 2'),
              _ScrollableContent(title: 'Tab 3'),
            ],
          ),
        ),
      ),
    );
  }
}

/// A scrollable content widget for demonstrating app bar scroll behavior.
class _ScrollableContent extends StatelessWidget {
  final String title;

  /// Creates a new [_ScrollableContent].
  const _ScrollableContent({required this.title});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return CustomScrollView(
          key: PageStorageKey<String>(title),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Item $index in $title',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  childCount: 30,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Custom implementation for a scrolling MinimalAppBar example
class CustomScrollingAppBarExample extends StatefulWidget {
  /// Creates a new [CustomScrollingAppBarExample].
  const CustomScrollingAppBarExample({Key? key}) : super(key: key);

  @override
  State<CustomScrollingAppBarExample> createState() =>
      _CustomScrollingAppBarExampleState();
}

class _CustomScrollingAppBarExampleState
    extends State<CustomScrollingAppBarExample> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinimalAppBar(
        title: const Text('Custom Scrolling App Bar'),
        // Elevation will change automatically when scrolled
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Scroll back to top
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 50,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
            subtitle: const Text('Scroll to see app bar elevation change'),
          );
        },
      ),
    );
  }
}

/// Entry point for the example
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const CustomScrollingAppBarExample(),
    ),
  );
}
