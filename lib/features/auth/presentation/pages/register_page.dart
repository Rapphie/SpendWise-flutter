import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;
    final authCubit = context.read<AuthCubit>();

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        authCubit.register(name: name, email: email, password: password);
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Passwords do not match!'),
          backgroundColor: Colors.redAccent,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all fields!'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_create_account.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter your New Account',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: 'now_regular',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Name',
                        hintStyle: TextStyle(fontSize: 14.0),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 18.0,
                          horizontal: 20.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        hintStyle: TextStyle(fontSize: 14.0),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 18.0,
                          horizontal: 20.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Password',
                        hintStyle: const TextStyle(fontSize: 14.0),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18.0,
                          horizontal: 20.0,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(fontSize: 14.0),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18.0,
                          horizontal: 20.0,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      register();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF091057),
                      padding: const EdgeInsets.symmetric(horizontal: 107.0, vertical: 15.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'now_regular',
                        fontWeight: FontWeight.bold,
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
