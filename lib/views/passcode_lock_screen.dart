import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:to_do_app/views/todo_list_screen.dart';

class PasscodeLockScreen extends StatelessWidget {
  const PasscodeLockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenLock(
        deleteButton: const Text('Delete'),
        onUnlocked: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TodoListScreen(),
              ));
        },
        correctString: '123456',
      ),
    );
  }
}
