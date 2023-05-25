import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/views/admin/login_view.dart';
import 'package:passport_unifranz_web/provider/auth_provider.dart';
import 'package:passport_unifranz_web/provider/sidemenu_provider.dart';
import 'package:passport_unifranz_web/router/router.dart';
import 'package:passport_unifranz_web/views/admin/pages/calendar/calendar_view.dart';
import 'package:passport_unifranz_web/views/admin/pages/categories/categories_view.dart';
import 'package:passport_unifranz_web/views/admin/pages/dashboard/dashboard_view.dart';
import 'package:passport_unifranz_web/views/admin/pages/events/events_view.dart';
import 'package:passport_unifranz_web/views/admin/pages/guests/guests_view.dart';
import 'package:passport_unifranz_web/views/admin/pages/permisions/permisions_view.dart';
import 'package:passport_unifranz_web/views/admin/pages/reports/reports_view.dart';
import 'package:passport_unifranz_web/views/admin/pages/roles/roles_view.dart';
import 'package:passport_unifranz_web/views/admin/pages/students/students_view.dart';
import 'package:passport_unifranz_web/views/admin/pages/type_users/type_users_view.dart';
import 'package:passport_unifranz_web/views/admin/pages/users/users_view.dart';
import 'package:provider/provider.dart';

class DashboardHandlers {
  //dashboard
  static Handler dashboard = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.dashboardRoute);
    debugPrint('LLEGUEEEEEEEE');
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const DashboardView();
    } else {
      return const LoginView();
    }
    // return LoginView();
  });
  //calendario
  static Handler calendar = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.calendarRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const CalendarScreen();
    } else {
      return const LoginView();
    }
  });
  //calendario
  static Handler events = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.eventsRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const EventsView();
    } else {
      return const LoginView();
    }
  });
  //categorias
  static Handler categories = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.categoriesRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const CategoriesView();
    } else {
      return const LoginView();
    }
  });
  //expositores
  static Handler guests = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.guestsRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const GuestsView();
    } else {
      return const LoginView();
    }
  });
  // users
  static Handler users = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.usersRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const UsersView();
    } else {
      return const LoginView();
    }
  });
  // permisos
  static Handler permisions = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.permisionsRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const PermisionsView();
    } else {
      return const LoginView();
    }
  });
  // roles
  static Handler roles = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.rolesRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const RolesView();
    } else {
      return const LoginView();
    }
  });
  // tipos de usuarios
  static Handler typeUsers = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.typeUsersRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const TypeUsersView();
    } else {
      return const LoginView();
    }
  });
  // estudiantes
  static Handler students = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.studentsRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const StudentsView();
    } else {
      return const LoginView();
    }
  });
  // reportes
  static Handler reports = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.reportsRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const ReportsView();
    } else {
      return const LoginView();
    }
  });
}
