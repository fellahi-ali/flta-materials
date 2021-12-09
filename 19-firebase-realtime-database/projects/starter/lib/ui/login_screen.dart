import 'package:flutter/material.dart';
import '../users.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Users _users;
  Future _loginStatus = Future.value();

  @override
  void initState() {
    _users = context.read<Users>();
    super.initState();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ray Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(),
                _emailField(),
                const SizedBox(height: 8),
                _passwordField(),
                const SizedBox(height: 8),
                _loginErrors(),
                const Spacer(),
                _loginButton(),
                _signUpButton(),
              ],
            )),
      ),
    );
  }

  Widget _loginErrors() => FutureBuilder(
        future: _loginStatus,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LinearProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(
              '${snapshot.error}',
              style: const TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
            );
          }
          return Container();
        },
      );

  Widget _emailField() => TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Email Address',
        ),
        autofocus: false,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        keyboardType: TextInputType.emailAddress,
        controller: _emailCtrl,
        validator: (input) =>
            (input == null || input.isEmpty) ? 'Email is required' : '',
      );

  Widget _passwordField() => TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Password',
        ),
        autofocus: false,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        controller: _passwordCtrl,
        validator: (input) =>
            (input == null || input.isEmpty) ? 'Password is required' : '',
      );

  Widget _loginButton() => Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _loginStatus =
                      _users.logIn(_emailCtrl.text, _passwordCtrl.text);
                });
              },
              child: const Text('Login'),
            ),
          ),
        ],
      );

  Widget _signUpButton() => Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _loginStatus = _users.signUp(
                    email: _emailCtrl.text,
                    pw: _passwordCtrl.text,
                  );
                });
              },
              child: const Text('Sign Up'),
            ),
          ),
        ],
      );
}
