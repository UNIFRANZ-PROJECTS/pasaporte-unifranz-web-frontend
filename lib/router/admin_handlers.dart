import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';
import 'package:passport_unifranz_web/views/admin/login_view.dart';
import 'package:passport_unifranz_web/views/admin/pages/dashboard/dashboard_view.dart';
import 'package:passport_unifranz_web/views/home/campus.dart';
import 'package:passport_unifranz_web/views/home/home.dart';
import 'package:passport_unifranz_web/provider/auth_provider.dart';
import 'package:passport_unifranz_web/provider/sidemenu_provider.dart';
import 'package:passport_unifranz_web/router/router.dart';

import 'package:provider/provider.dart';

class Home {
  //home
  static Handler home = Handler(handlerFunc: (context, params) {
    return const CampusScreen();
  });

  //campus
  static Handler campus = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.dashboardRoute);
      return const DashboardView();
    }
    if (authProvider.authStatusStudent == AuthStatusStudent.authenticated) {
      if (params['uid']!.first != 'lp' &&
          params['uid']!.first != 'ea' &&
          params['uid']!.first != 'cbba' &&
          params['uid']!.first != 'sc' &&
          params['uid']!.first != json.decode(LocalStorage.prefs.getString('student')!)['uid']) {
        return const CampusScreen();
      }
      return const HomeScreen();
    }
    if (params['uid']!.first == 'lp' ||
        params['uid']!.first == 'ea' ||
        params['uid']!.first == 'cbba' ||
        params['uid']!.first == 'sc') {
      return const HomeScreen();
    } else {
      debugPrint('HOMEEEEEEE');
      // return const CampusScreen();
      if (authProvider.authStatus == AuthStatus.notAuthenticated) {
        return const CampusScreen();
      } else {
        Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.dashboardRoute);
        return const DashboardView();
      }
    }
  });
}

//login admin
class AdminHandlers {
  static Handler login = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);

    if (authProvider.authStatus == AuthStatus.notAuthenticated) {
      return const LoginView();
    } else {
      Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.dashboardRoute);
      return const DashboardView();
    }
  });
}
