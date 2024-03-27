import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/view_model/todo_list_provider.dart';
import 'package:to_do_app/views/passcode_lock_screen.dart';
import 'package:to_do_app/views/todo_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferences.getInstance().then((prefs) {
    // Access shared preferences here
    final isExpired = prefs.getBool('isExpire') ?? true;
    runApp(MyApp(isExpired: isExpired));
  });
}

class MyApp extends StatelessWidget {
  final bool isExpired;
  const MyApp({super.key, required this.isExpired});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoListProvider()..fetchTasks()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: isExpired ? const PasscodeLockScreen() : const TodoListScreen(),
      ),
    );
  }
}
