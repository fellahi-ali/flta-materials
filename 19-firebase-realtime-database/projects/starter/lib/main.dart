import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/login_screen.dart';
import 'users.dart';
import 'messages.dart';
import 'ui/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  final _users = Users();
  @override
  Widget build(BuildContext context) {
    return Provider<Users>(
      create: (_) => _users,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RayChat',
        theme: ThemeData(primaryColor: const Color(0xFF3D814A)),
        home: StreamBuilder<User?>(
          stream: _users.logInState(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            // user is logged in
            if (snapshot.hasData) {
              final user = snapshot.data!;
              return Provider<Messages>(
                create: (_) => FirestoreMessages(email: user.email),
                lazy: false,
                child: const MessageList(),
              );
            }
            // otherwise
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
