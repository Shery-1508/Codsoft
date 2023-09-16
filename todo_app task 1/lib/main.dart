import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_notifier.dart';
import 'todo_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> _initializeApp() async {
    // Place your app initialization logic here, e.g., fetching data, initializing resources, etc.
    await Future.delayed(Duration(seconds: 2)); // Simulate some loading time
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider<ThemeNotifier>(
            create: (_) => ThemeNotifier(),
            child: Builder(
              builder: (context) {
                final themeNotifier = Provider.of<ThemeNotifier>(context);
                return MaterialApp(
                  title: 'Todo App',
                  // ThemeData.dark() theme if themeNotifier.isDark is true else ThemeData.light() with custom appbar color
                  theme: themeNotifier.isDark
                      ? ThemeData.dark()
                      : ThemeData(
                          scaffoldBackgroundColor: Colors.grey[200],
                          appBarTheme: AppBarTheme(
                            // purple color with a bit of transparency
                            color: Colors.purple.withOpacity(0.3),
                          ),
                        ),
                  home: TodoListScreen(),
                );
              },
            ),
          );
        } else {
          return MaterialApp(
            home: Scaffold(
              // show a progress indicator along with a message while waiting for the app to initialize
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                  SizedBox(height: 20),
                  // initialize app message
                  Text(
                    'Initializing app...',
                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  ),
                  // developer name '@sheharyar'
                  Text(
                    '@sheharyar',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
// codsoft sheharyar
