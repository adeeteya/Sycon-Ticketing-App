import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sycon_ticketing_app/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordObscure = true;
  String email = "", password = "";

  void _emailOnChanged(String val) {
    email = val;
  }

  void _passwordOnChanged(String val) {
    password = val;
  }

  String? _emailValidator(String? val) {
    return (val?.isEmpty ?? true) ? "Please enter your Email" : null;
  }

  String? _passwordValidator(String? val) {
    return (val?.isEmpty ?? true) ? "Please enter your Password" : null;
  }

  void _changePasswordVisibility() {
    setState(() {
      _isPasswordObscure = !_isPasswordObscure;
    });
  }

  void _onSignInTap() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password)
          .then((_) => {}, onError: (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Error"),
            content: const Text("Some Unknown Error Occurred"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: kCeruleanBlue),
                ),
              )
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.08),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/sycon_logo.png',
                    ),
                  ),
                  SizedBox(height: size.height * 0.08),
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      color: kEbonyBlack,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "To Continue...",
                    style: TextStyle(
                      color: kEbonyBlack,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  TextFormField(
                    onChanged: _emailOnChanged,
                    validator: _emailValidator,
                    cursorColor: kCeruleanBlue,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: kLoginInputDecoration.copyWith(
                      hintText: 'Email',
                      prefixIcon: const Icon(
                        Icons.email,
                        color: kNickelSilver,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFormField(
                    onChanged: _passwordOnChanged,
                    validator: _passwordValidator,
                    cursorColor: kCeruleanBlue,
                    obscureText: _isPasswordObscure,
                    decoration: kLoginInputDecoration.copyWith(
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: kNickelSilver,
                      ),
                      suffixIcon: InkWell(
                        onTap: _changePasswordVisibility,
                        customBorder: const CircleBorder(),
                        child: Icon(
                          (_isPasswordObscure)
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: kNickelSilver,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.2),
                  RepaintBoundary(
                    child: ElevatedButton(
                      onPressed: _onSignInTap,
                      child: const Text(
                        "Sign In",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
