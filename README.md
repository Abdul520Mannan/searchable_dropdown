# Searable Dropdown

A highly customizable, searchable dropdown package for Flutter. It provides three distinct widgets to handle single selection, multi-selection with checkboxes, and radio-button selection.

## Features

*   **Single Select Dropdown**: A standard searchable dropdown for picking one item.
*   **Multi Select Dropdown**: Allows picking multiple items with a checkbox UI.
*   **Radio Select Dropdown**: A single-select variant using radio buttons for list items.
*   **Conditional Local Search**: 
    *   If `onSearch` is provided, it handles remote/server-side searching.
    *   If `onSearch` is `null`, it automatically performs local filtering using `item.toString()`.
*   **Customizable UI**: Fully customizable headers and list items via builders.
*   **Debounced Search**: Built-in 500ms debounce for search input.

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
  topContext: context,
  itemsList: ['Apple', 'Banana', 'Cherry'],
  onChange: (value) => print(value),
  headerBuilder: (context, selectedItem, enabled) => Text(selectedItem ?? 'Pick a fruit'),
  listItemBuilder: (context, item, isSelected) => Text(item),
)
```

### Multi Select

```dart
CustomMultiSearchDropdownWidget<User>(
  topContext: context,
  itemsList: users,
  selectedItems: selectedUsers,
  onChanged: (values) => setState(() => selectedUsers = values),
  headerBuilder: (context, items, enabled) => Text(items.isEmpty ? 'Select Users' : items.join(', ')),
  listItemBuilder: (context, item, isSelected) => Text(item.name),
)
```

### Radio Select

```dart
CustomRadioSearchDropdownWidget<User>(
  topContext: context,
  itemsList: users,
  selectedItem: selectedUser,
  onChange: (value) => setState(() => selectedUser = value),
  headerBuilder: (context, item, enabled) => Text(item?.name ?? 'Select User'),
  listItemBuilder: (context, item, isSelected) => Text(item.name),
)
```

## Additional information

For documentation and issues, please visit the [GitHub repository](https://github.com/Abdul/searable_dropdown).
