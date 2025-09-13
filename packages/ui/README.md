# UI Package

A comprehensive Flutter UI component library providing ready-to-use widgets with Material Design 3 theming support.

## Features

### Core Widgets
- **Skeleton** - Loading placeholders with shimmer effects
- **Slider** - Custom range and single value sliders
- **Tabs** - Customizable tab navigation
- **Tooltip** - Enhanced tooltips with rich content

### Extension Widgets
- **Accordion** - Expandable/collapsible content sections
- **Calendar** - Full-featured date picker with multiple selection modes
- **FAB (Floating Action Button)** - Extended FABs with speed dial and morphing capabilities
- **Rich Text Editor** - WYSIWYG editor with formatting toolbar
- **Search Bar** - Advanced search with suggestions and history
- **File Manager** - Complete file browser with multiple view modes
- **Media Gallery** - Image/video gallery with zoom and fullscreen viewing

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  ui:
    path: ../packages/ui
```

## Usage

### Basic Import

```dart
import 'package:ui/ui.dart';
```

### Core Widgets

#### Skeleton Loading
```dart
Skeleton.text(
  width: 200,
  height: 16,
)

Skeleton.avatar(radius: 24)

Skeleton.card(
  width: 300,
  height: 200,
)
```

#### Custom Slider
```dart
CustomSlider(
  value: _currentValue,
  min: 0,
  max: 100,
  onChanged: (value) {
    setState(() {
      _currentValue = value;
    });
  },
)
```

#### Tabs
```dart
TabsWidget(
  tabs: [
    TabItem(label: 'Home', content: HomeContent()),
    TabItem(label: 'Profile', content: ProfileContent()),
  ],
)
```

### Extension Widgets

#### Accordion
```dart
Accordion(
  items: [
    AccordionTypes.faq(
      question: 'What is Flutter?',
      answer: 'Flutter is Google\'s UI toolkit...',
    ),
    AccordionTypes.text(
      title: 'Features',
      content: 'Hot reload, cross-platform...',
    ),
  ],
)
```

#### Calendar
```dart
Calendar(
  selectionMode: CalendarSelectionMode.range,
  onRangeSelected: (range) {
    print('Selected range: ${range.start} - ${range.end}');
  },
)

// Or use presets
CalendarPresets.datePicker(
  onDateSelected: (date) => print('Selected: $date'),
)
```

#### Extended FAB
```dart
ExtendedFAB(
  icon: Icons.add,
  label: 'Create',
  type: FABType.extended,
  onPressed: () => print('FAB pressed'),
)

// Speed dial FAB
SpeedDialFAB(
  icon: Icons.add,
  options: [
    SpeedDialOption(
      icon: Icons.photo,
      label: 'Photo',
      onPressed: () => print('Photo'),
    ),
    SpeedDialOption(
      icon: Icons.video_library,
      label: 'Video',
      onPressed: () => print('Video'),
    ),
  ],
)
```

#### Rich Text Editor
```dart
RichTextEditor(
  placeholder: 'Start typing...',
  onChanged: (html, plainText) {
    print('Content changed: $plainText');
  },
  toolbarConfig: RichTextToolbarConfig.defaultConfig(),
)
```

#### Search Bar
```dart
SearchBar(
  hintText: 'Search...',
  suggestions: ['Flutter', 'Dart', 'Material Design'],
  showSuggestions: true,
  onChanged: (query) => print('Search: $query'),
)

// Or use presets
SearchBarPresets.withSuggestions(
  suggestions: ['Option 1', 'Option 2'],
  onSuggestionSelected: (suggestion) => print('Selected: $suggestion'),
)
```

#### File Manager
```dart
FileManager(
  currentPath: '/home/user/documents',
  items: fileItems,
  viewMode: FileViewMode.grid,
  onFileSelected: (file) => print('Selected: ${file.name}'),
  onDirectoryOpened: (directory) => print('Opened: ${directory.name}'),
)

// Or use presets
FileManagerPresets.imageGallery(
  currentPath: '/photos',
  items: imageFiles,
)
```

#### Media Gallery
```dart
MediaGallery(
  items: mediaItems,
  mode: MediaGalleryMode.fullscreen,
  allowZoom: true,
  showThumbnails: true,
  onItemSelected: (item, index) => print('Viewing: ${item.title}'),
)

// Grid gallery
MediaGalleryPresets.gridGallery(
  items: photos,
  onItemSelected: (item, index) => openFullscreen(item),
)
```

## Widget Categories

### Core Widgets (`/src/widgets/`)
Essential UI components with Material Design theming:
- Loading states and placeholders
- Form controls and inputs
- Navigation and layout components
- Feedback and status indicators

### Extension Widgets (`/src/extensions/`)
Advanced, feature-rich components:
- Complex interactions and behaviors
- Data presentation and management
- Media and file handling
- Rich content editing

## Customization

All widgets support extensive customization through:
- **Theme Integration** - Automatic Material Design 3 color scheme support
- **Custom Builders** - Override default rendering with custom widgets
- **Style Properties** - Comprehensive styling options
- **Callback Functions** - Flexible event handling

### Example Customization

```dart
Calendar(
  specialDates: {
    DateTime.now(): CalendarDateStyle(
      backgroundColor: Colors.red,
      textColor: Colors.white,
      borderColor: Colors.redAccent,
    ),
  },
  headerBuilder: (month) => CustomHeader(month),
  dayBuilder: (date, isSelected, isDisabled) => CustomDayWidget(
    date: date,
    isSelected: isSelected,
  ),
)
```

## Extension Methods

Many widgets provide extension methods for easier integration:

```dart
// Add FAB to any widget
myWidget.withFAB(
  onPressed: () => print('FAB pressed'),
  icon: Icons.add,
)

// Add search bar to any widget
myListView.withSearchBar(
  hintText: 'Search items...',
  onChanged: (query) => filterItems(query),
)

// Convert media items to gallery
mediaItems.toImageGallery(
  onItemSelected: (item, index) => viewFullscreen(item),
)
```

## Theming

The package automatically adapts to your app's theme:

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  ),
  home: MyApp(),
)
```

All widgets will use the appropriate colors, typography, and spacing from your theme.

## Contributing

This package is part of the Flutter UI Kit monorepo. To contribute:

1. Make changes to widgets in `/src/widgets/` or `/src/extensions/`
2. Update the main export file `/lib/ui.dart` if adding new widgets
3. Test your changes across different themes and screen sizes
4. Follow the existing code patterns and documentation style

## Package Structure

```
lib/
├── ui.dart                    # Main export file
└── src/
    ├── widgets/              # Core UI components
    │   ├── skeleton.dart
    │   ├── slider.dart
    │   ├── tabs.dart
    │   └── tooltip.dart
    └── extensions/           # Advanced components
        ├── accordion.dart
        ├── calendar.dart
        ├── fab.dart
        ├── rich_text_editor.dart
        ├── search_bar.dart
        ├── file_manager.dart
        └── media_gallery.dart
```