import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class TestItem {
  final String name;
  final String category;

  TestItem({required this.name, required this.category});

  @override
  String toString() => name;
}

void main() {
  testWidgets('CustomSearchDropdownWidget itemToString filters correctly', (WidgetTester tester) async {
    final items = [
      TestItem(name: 'Apple', category: 'Fruit'),
      TestItem(name: 'Carrot', category: 'Vegetable'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomSearchDropdownWidget<TestItem>(
            itemsList: items,
            backgroundColor: Colors.white,
            onChange: (v) {},
            itemToString: (item) => item.category,
            headerBuilder: (context, selectedItem, enabled) => const Text('Header'),
            listItemBuilder: (context, item, isSelected) => Text(item.name),
          ),
        ),
      ),
    );

    // Open overlay
    await tester.tap(find.text('Header'));
    await tester.pumpAndSettle();

    // Enter search text
    await tester.enterText(find.byType(TextField), 'Fruit');
    // Wait for 500ms debounce timer
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify filter
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Carrot'), findsNothing);

    // Close overlay (tap outside)
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
  });

  testWidgets('CustomMultiSearchDropdownWidget itemToString filters correctly', (WidgetTester tester) async {
    final items = [
      TestItem(name: 'Apple', category: 'Fruit'),
      TestItem(name: 'Carrot', category: 'Vegetable'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomMultiSearchDropdownWidget<TestItem>(
            itemsList: items,
            selectedItems: const [],
            backgroundColor: Colors.white,
            onChanged: (v) {},
            itemToString: (item) => item.category,
            headerBuilder: (context, selectedItems, enabled) => const Text('Multi Header'),
            listItemBuilder: (context, item, isSelected) => Text(item.name),
          ),
        ),
      ),
    );

    // Open overlay
    await tester.tap(find.text('Multi Header'));
    await tester.pumpAndSettle();

    // Enter search text
    await tester.enterText(find.byType(TextField), 'Vegetable');
    // Wait for 500ms debounce timer
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify filter
    expect(find.text('Carrot'), findsOneWidget);
    expect(find.text('Apple'), findsNothing);

    // Close overlay (tap outside)
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
  });
}
