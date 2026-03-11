import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Search Dropdown Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _selectedFruit;
  final List<String> _fruits = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grapes',
    'Honeydew',
    'Kiwi',
    'Lemon',
    'Mango',
    'Nectarine',
    'Orange',
    'Papaya',
    'Quince',
    'Raspberry',
    'Strawberry',
    'Tangerine',
    'Watermelon',
  ];

  List<User> _selectedUsers = [];

  final List<User> _users = [
    User(name: 'Alice Johnson', email: 'alice@example.com'),
    User(name: 'Bob Smith', email: 'bob@example.com'),
    User(name: 'Charlie Brown', email: 'charlie@example.com'),
    User(name: 'David Wilson', email: 'david@example.com'),
    User(name: 'Eva Davis', email: 'eva@example.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Searchable Dropdown Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Widgets Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // 1. Single Select
            const Text('1. Single Select Dropdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            CustomSearchDropdownWidget<String>(
              itemsList: _fruits,
              backgroundColor: Colors.white,
              onChange: (value) {
                setState(() {
                  _selectedFruit = value;
                });
              },
              selectedItem: _selectedFruit,
              headerBuilder: (context, selectedItem, enabled) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(selectedItem ?? 'Select a fruit'),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                );
              },
              listItemBuilder: (context, item, isSelected) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                  child: Text(item, style: TextStyle(color: isSelected ? Colors.blue : Colors.black)),
                );
              },
            ),
            const SizedBox(height: 32),

            // 2. Multi Select
            const Text('2. Multi Select Dropdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            CustomMultiSearchDropdownWidget<User>(
              itemsList: _users,
              backgroundColor: Colors.white,
              selectedItems: _selectedUsers,
              onChanged: (values) {
                setState(() {
                  _selectedUsers = values;
                });
              },
              headerBuilder: (context, selectedItems, enabled) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedItems.isEmpty
                              ? 'Select users'
                              : selectedItems.map((e) => e.name).join(', '),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                );
              },
              listItemBuilder: (context, item, isSelected) {
                return Text(item.name);
              },
            ),
            const SizedBox(height: 32),

            const SizedBox(height: 48),

            // Display Results
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selections:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  Text('Fruit: ${_selectedFruit ?? "None"}'),
                  Text('Multi Users: ${_selectedUsers.map((e) => e.name).join(", ")}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  @override
  String toString() => name; // Used for local search

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && name == other.name && email == other.email;

  @override
  int get hashCode => name.hashCode ^ email.hashCode;
}
