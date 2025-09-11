# MinimalAppBar Component

A responsive application bar component with configurable appearance and behavior.

## Features

- Platform-adaptive title positioning (centered on iOS/macOS, left-aligned on Android)
- Automatic back button handling when navigating
- Support for custom leading and action widgets
- Elevation response to scroll events
- Integration with bottom widgets (tabs, progress indicators)
- Flexible space for expandable content
- Accessibility support with proper semantics
- Dark theme adaptations
- RTL layout support

## Usage

```dart
MinimalAppBar(
  title: Text('App Title'),
  leading: IconButton(
    icon: Icon(Icons.menu),
    onPressed: () {
      // Open drawer
    },
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        // Open search
      },
    ),
  ],
)
```

## Properties

| Property | Type | Description |
|----------|------|-------------|
| title | Widget? | The widget displayed in the center/left of the app bar. |
| leading | Widget? | A widget to display before the title. |
| actions | List<Widget>? | List of widgets to display in a row after the title. |
| backgroundColor | Color? | Background color of the app bar. |
| foregroundColor | Color? | The color used for the app bar's text and icons. |
| elevation | double? | The elevation of the app bar shadow. |
| centerTitle | bool? | Whether the title should be centered. |
| titleSpacing | double? | The spacing around the title content. |
| toolbarHeight | double | The height of the app bar's toolbar section. |
| bottom | PreferredSizeWidget? | A widget to display at the bottom of the app bar. |
| flexibleSpace | Widget? | A widget displayed behind the toolbar and the bottom widget. |
| onLeadingPressed | VoidCallback? | Callback when the leading widget is pressed. |
| automaticallyImplyLeading | bool | Whether to automatically add a back button if available. |

## Examples

See the example directory for complete examples:
- [Basic AppBar](/apps/examples/lib/app_bar/app_bar_basic.dart)
- [AppBar with Actions](/apps/examples/lib/app_bar/app_bar_actions.dart)
- [Scrolling AppBar](/apps/examples/lib/app_bar/app_bar_scrolling.dart)
