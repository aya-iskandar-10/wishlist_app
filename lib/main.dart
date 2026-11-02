import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ---------------------------------------------------------------
// 1. THE PROVIDER: holds the global wishlist
// ---------------------------------------------------------------
class WishlistData extends ChangeNotifier {
  final List<String> _items = [];

  // Read-only access to the list
  List<String> get items => _items;

  void addItem(String item) {
    if (!_items.contains(item)) {
      _items.add(item);
      notifyListeners(); // tells the UI to rebuild
    }
  }

  void removeItem(String item) {
    _items.remove(item);
    notifyListeners(); // don't forget this!
  }
}

// ---------------------------------------------------------------
// App entry point: wrap the app so every screen can reach the data
// ---------------------------------------------------------------
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WishlistData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wishlist App',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const StoreScreen(),
    );
  }
}

// ---------------------------------------------------------------
// 2. SCREEN 1: THE STORE
// ---------------------------------------------------------------
class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  final List<String> products = const [
    'iPhone',
    'MacBook',
    'AirPods',
    'iPad',
    'Apple Watch',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return ListTile(
            title: Text(item),
            trailing: ElevatedButton(
              onPressed: () {
                // context.read = call a method, don't listen for changes
                context.read<WishlistData>().addItem(item);
              },
              child: const Text('Add to Wishlist'),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------
// 3. SCREEN 2: MY WISHLIST
// ---------------------------------------------------------------
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      // Consumer rebuilds this part whenever notifyListeners() is called
      body: Consumer<WishlistData>(
        builder: (context, wishlist, child) {
          if (wishlist.items.isEmpty) {
            return const Center(child: Text('Your wishlist is empty'));
          }
          return ListView.builder(
            itemCount: wishlist.items.length,
            itemBuilder: (context, index) {
              final item = wishlist.items[index];
              return ListTile(
                title: Text(item),
                // BONUS: delete button
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => wishlist.removeItem(item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}