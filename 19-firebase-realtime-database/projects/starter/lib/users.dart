import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

class Users {
  final auth = fbAuth.FirebaseAuth.instance;

  Future<User> signUp({required String email, required String pw}) async {
    final credentials = await auth.createUserWithEmailAndPassword(
      email: email,
      password: pw,
    );
    return User.fromCredentials(credentials);
  }

  Future<User> logIn(String email, String pw) async {
    final credentials = await auth.signInWithEmailAndPassword(
      email: email,
      password: pw,
    );
    return User.fromCredentials(credentials);
  }

  Future anonymous() async {
    await auth.signInAnonymously();
  }

  Future logOut() async {
    await auth.signOut();
  }

  Stream<User?> logInState() => auth.authStateChanges().map(_userOrNull);

  User? _userOrNull(fbAuth.User? fbUser) => fbUser == null
      ? null
      : User(
          email: fbUser.email ?? 'anonymous',
          id: fbUser.uid,
        );
}

class User {
  User({required this.id, required this.email});
  factory User.fromCredentials(fbAuth.UserCredential userCredential) => User(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );

  String id;
  String email;
}
