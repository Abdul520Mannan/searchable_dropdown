import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:searable_dropdown/searable_dropdown.dart';

void main() {
  testWidgets('CustomSearchDropdownWidget can be created', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return CustomSearchDropdownWidget<String>(
                topContext: context,
                itemsList: const ['A', 'B'],
                backgroundColor: Colors.white,
                onChange: (v) {},
                headerBuilder: (context, selectedItem, enabled) => Text(selectedItem ?? 'Select an item'),
                listItemBuilder: (context, item, isSelected) => Text(item),
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(CustomSearchDropdownWidget<String>), findsOneWidget);
    expect(find.text('Select an item'), findsOneWidget);
  });
}
