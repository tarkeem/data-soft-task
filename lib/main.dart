import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/auth/news_cubit.dart';
import 'package:news_app/cubits/news/news_cubit.dart';
import 'package:news_app/firebase_options.dart';
import 'package:news_app/model/repositories/auth_repository.dart';
import 'package:news_app/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/view/screen/login.dart';
import 'model/repositories/news_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NewsRepository>(create: (context) => NewsRepository(
          newsApiServices: NewsApiServices(httpClient: http.Client()))),
          RepositoryProvider<AuthRepository>(create: (context) => AuthRepository(
          newsApiServices: NewsApiServices(httpClient: http.Client()))),
      ],
      
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NewsCubit>(
            create: (context) => NewsCubit(
                newsRepository: context.read<NewsRepository>()),
          ),

           BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
                authRepository: context.read<AuthRepository>()),
          ),
         
        ],
        child: MaterialApp(
          title: 'news App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Color.fromARGB(255, 219, 219, 219),
            primarySwatch: Colors.blue,
          ),
          home: const SignInScreen(),
        ),
      ),
    );
  }
}
