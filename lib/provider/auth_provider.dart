import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/router/router.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';
import 'package:passport_unifranz_web/services/navigation_service.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

enum AuthStatusStudent { checking, authenticated, notAuthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.checking;
  AuthStatusStudent authStatusStudent = AuthStatusStudent.checking;

  AuthProvider() {
    isAuthenticated();
  }

  login(Response<dynamic> resp) {
    debugPrint('authResponse.token ${resp.data}');
    authStatus = AuthStatus.authenticated;
    LocalStorage.prefs.setString('token', resp.data['token']);
    LocalStorage.prefs.setString('mode', 'admin');
    LocalStorage.prefs.setString('userData', json.encode(resp.data));
    NavigationService.replaceTo(Flurorouter.dashboardRoute);

    CafeApi.configureDio();

    notifyListeners();
  }

  loginStudent(Response<dynamic> resp) {
    debugPrint('authResponse.token ${resp.data}');
    authStatusStudent = AuthStatusStudent.authenticated;
    LocalStorage.prefs.setString('tokenStudent', resp.data['token']);
    LocalStorage.prefs.setString('mode', 'student');
    // Map<String, dynamic> decodedToken = decodeJwt(res.data['token']);
    // debugPrint('${decodedToken}');
    LocalStorage.prefs.setString('student', json.encode(resp.data['cliente']));
    CafeApi.configureDio();

    notifyListeners();
  }

  register(String email, String password, String name) {
    // final data = {'nombre': name, 'correo': email, 'password': password};

    // CafeApi.post('/usuarios', data ).then(
    //   (json) {
    //     print(json);
    //     final authResponse = AuthResponse.fromMap(json);
    //     this.user = authResponse.usuario;

    //     authStatus = AuthStatus.authenticated;
    //     LocalStorage.prefs.setString('token', authResponse.token );
    //     NavigationService.replaceTo(Flurorouter.dashboardRoute);

    //     CafeApi.configureDio();
    //     notifyListeners();

    //   }

    // ).catchError( (e){
    //   print('error en: $e');
    //   NotificationsService.showSnackbarError('Usuario / Password no válidos');
    // });
  }

  Future<bool> isAuthenticated() async {
    final token = LocalStorage.prefs.getString('token');
    final tokenStudent = LocalStorage.prefs.getString('tokenStudent');
    debugPrint('tokentokentokentoken $token');
    // final mode = LocalStorage.prefs.getString('mode');
    // if (mode == 'student') {
    //   authStatus = AuthStatus.notAuthenticated;
    //   notifyListeners();
    //   return false;
    // }
    if (token != null) {
      authStatus = AuthStatus.authenticated;
      authStatusStudent = AuthStatusStudent.notAuthenticated;
      notifyListeners();
      return true;
    }
    if (tokenStudent != null) {
      debugPrint('estudiante Autenticado');
      authStatusStudent = AuthStatusStudent.authenticated;
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return true;
    }
    try {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('e $e');
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
  }

  logout() {
    LocalStorage.prefs.remove('token');
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }

  logoutStudent() {
    LocalStorage.prefs.remove('tokenStudent');
    authStatusStudent = AuthStatusStudent.notAuthenticated;
    notifyListeners();
  }
}
