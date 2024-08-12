import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'http_error_handler.dart';

class NewsApiServices {
  final http.Client httpClient;
  NewsApiServices({
    required this.httpClient,
  });

  

  Future SignUp(String email,String password) async {
     final FirebaseAuth auth = FirebaseAuth.instance;

    try {
   UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
        
        
      }
    } catch (e) {
      rethrow;
    }
  }







  Future SignIn(String email,String password) async {
    
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
   UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email to continue.',
      );
    }
    } catch (e) {
      rethrow;
    }
  }






  Future<Map<String,dynamic>> getNews(String category) async {
    log("get news..........");
    
    final Uri uri = Uri(
  scheme: 'https',
  host: 'newsapi.org',
  path: '/v2/top-headlines',
  queryParameters: {
    'country': 'us',
    'category': category,
    'apiKey': 'd7acf3a18c224626ad6e05f2521d8316',
  },
);

    try {
  final http.Response response = await httpClient.get(uri);
   log("called api..........");
 final newsJson =json.decode(response.body);


      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }


      return newsJson;
    } catch (e) {
      rethrow;
    }
  }
 
}
