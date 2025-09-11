# MinimalFloatingActionButton

Usage examples for the `MinimalFloatingActionButton` component.

Basic FAB

```dart
MinimalFloatingActionButton(
  onPressed: () => print('pressed'),
  child: Icon(Icons.add),
)
```

Extended FAB

```dart
MinimalFloatingActionButton(
  onPressed: () => print('pressed'),
  isExtended: true,
  icon: Icon(Icons.add),
  label: Text('Add Item'),
)
```
