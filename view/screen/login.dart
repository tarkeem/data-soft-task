import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/auth/news_cubit.dart';
import 'package:news_app/view/screen/home.dart';
import 'package:news_app/view/screen/signup.dart';
import 'package:news_app/view/widgets/error_dialog.dart';
import 'package:lottie/lottie.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
     bool isvalid=_formKey.currentState!.validate();
   if(isvalid)
   {
     context.read<AuthCubit>().SignIn(_emailController.text, _passwordController.text);
   }
    
  }
final GlobalKey<FormState> _formKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: BlocConsumer<AuthCubit,AuthState>(
       listener: (context, state) {
        if (state.status == AuthStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
        else if(state.status==AuthStatus.loaded)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage(),));
        }
      },
        builder: (context, state) {
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
                      if(value==null ||value.isEmpty)
                      {
                        return "Required field";
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if(value==null ||value.isEmpty)
                      {
                        return "Required field";
                      }
                      return null;
                    },
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
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
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
