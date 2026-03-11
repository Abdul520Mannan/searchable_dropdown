# Searchable Dropdown

A highly customizable, searchable dropdown package for Flutter. It provides two distinct widgets to handle single selection and multi-selection with checkboxes.

## Features

*   **Single Select Dropdown**: A standard searchable dropdown for picking one item.
*   **Multi Select Dropdown**: Allows picking multiple items with a checkbox UI.
*   **Generic Type Support `<T>`**: Fully supports generic types for both items and selection.
*   **Custom Filtering**: Use `itemToString` or default to `item.toString()`.
*   **Customizable UI**: Fully customizable headers and list items via builders.
*   **Debounced Search**: Built-in 500ms debounce for search input.
*   **Safe Overlay Handling**: Automatically checks if the overlay is mounted before removal.

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  searable_dropdown: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Single Select

```dart
CustomSearchDropdownWidget<String>(
  itemsList: ['Apple', 'Banana', 'Cherry'],
  onChange: (value) => print(value),
  headerBuilder: (context, selectedItem, enabled) => Text(selectedItem ?? 'Pick a fruit'),
  listItemBuilder: (context, item, isSelected) => Text(item),
)
```

### Multi Select

```dart
CustomMultiSearchDropdownWidget<User>(
  itemsList: users,
  selectedItems: selectedUsers,
  onChanged: (values) => setState(() => selectedUsers = values),
  headerBuilder: (context, items, enabled) => Text(items.isEmpty ? 'Select Users' : items.map((e) => e.name).join(', ')),
  listItemBuilder: (context, item, isSelected) => Text(item.name),
)
```

```

## Additional information

- Source code and issue tracker:
[https://github.com/Abdul520Mannan/searchable_dropdown](https://github.com/Abdul520Mannan/searchable_dropdown)

If you find a bug or want to request a feature, please open an issue on GitHub.
