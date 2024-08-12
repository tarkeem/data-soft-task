import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/cubits/auth/news_cubit.dart';
import 'package:news_app/view/screen/login.dart';
import 'package:news_app/view/widgets/error_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _signInWithEmailAndPassword() async {
    bool isvalid = _formKey.currentState!.validate();
    if (isvalid) {
      context
          .read<AuthCubit>()
          .SignUpScreen(_emailController.text, _passwordController.text);
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please check your E-mail')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
        if (state.status == AuthStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
        else if(state.status==AuthStatus.loaded)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen(),));
        }
      }, builder: (context, state) {
        if (state.status==AuthStatus.loading)
          {
            return const Center(child: CircularProgressIndicator(),);
          }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Expanded(child: LottieBuilder.asset('assets/news.json')),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required field";
                    }
                    return null;
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required field";
                    }
                    return null;
                  },
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required field";
                    }
                    if (value != _passwordController.text) {
                      return "Password does not match";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                      )),
                  onPressed: _signInWithEmailAndPassword,
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  },
                  child: const Text('Do you have an account? Sign In'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
