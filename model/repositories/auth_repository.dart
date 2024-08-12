import 'dart:developer';

import '../../utils/weather_exception.dart';
import '../models/custom_error.dart';
import '../../services/api_services.dart';

class AuthRepository {
  final NewsApiServices newsApiServices;
  AuthRepository({
    required this.newsApiServices,
  });

  Future SignIn(String email,String password) async {
   
    try {
      final  res  =await newsApiServices.SignIn(email, password);
    } on NewsException catch (e) {
      log(".......error..........");
      throw CustomError(errMsg: e.message);
    } catch (e) {
      log(".......error..........");
      throw CustomError(errMsg: e.toString());
    }
  }
  Future SignUp(String email,String password) async {
   
    try {
      final  res  =await newsApiServices.SignUp(email, password);
    } on NewsException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}