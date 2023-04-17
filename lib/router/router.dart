import 'package:fluro/fluro.dart';
import 'package:passport_unifranz_web/router/dashboard_handlers.dart';
import 'package:passport_unifranz_web/router/no_page_found_handlers.dart';

import 'admin_handlers.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static String rootRoute = '/';
  static String campusHomeRoute = '/:uid';

  // Auth Router
  static String loginRoute = '/admin/login';

  //Dashboard
  static String dashboardRoute = '/dashboard';
  //calendar
  static String calendarRoute = '/dashboard/calendar';
  //users
  static String usersRoute = '/dashboard/users';
  //eventos
  static String eventsRoute = '/dashboard/events';
  //categorias
  static String categoriesRoute = '/dashboard/categories';
  //expositores
  static String guestsRoute = '/dashboard/guests';
  //permisos
  static String permisionsRoute = '/dashboard/permisions';
  //roles
  static String rolesRoute = '/dashboard/roles';
  //tipos de usuarios
  static String typeUsersRoute = '/dashboard/typeusers';
  //estudiantes
  static String studentsRoute = '/dashboard/students';
  //reportes
  static String reportsRoute = '/dashbard/reports';

  static void configureRoutes() {
    router.define(rootRoute, handler: Home.home, transitionType: TransitionType.none);
    router.define(campusHomeRoute, handler: Home.campus, transitionType: TransitionType.fadeIn);

    router.define(loginRoute, handler: AdminHandlers.login, transitionType: TransitionType.fadeIn);
    // Dashboard
    router.define(dashboardRoute, handler: DashboardHandlers.dashboard, transitionType: TransitionType.fadeIn);
    // Usuarios
    router.define(usersRoute, handler: DashboardHandlers.users, transitionType: TransitionType.fadeIn);
    // Calendario
    router.define(calendarRoute, handler: DashboardHandlers.calendar, transitionType: TransitionType.fadeIn);
    // Eventos
    router.define(eventsRoute, handler: DashboardHandlers.events, transitionType: TransitionType.fadeIn);
    // Categorias
    router.define(categoriesRoute, handler: DashboardHandlers.categories, transitionType: TransitionType.fadeIn);
    //expositores
    router.define(guestsRoute, handler: DashboardHandlers.guests, transitionType: TransitionType.fadeIn);
    // Permisos
    router.define(permisionsRoute, handler: DashboardHandlers.permisions, transitionType: TransitionType.fadeIn);
    // Roles
    router.define(rolesRoute, handler: DashboardHandlers.roles, transitionType: TransitionType.fadeIn);
    // Tipos de usuarios
    router.define(typeUsersRoute, handler: DashboardHandlers.typeUsers, transitionType: TransitionType.fadeIn);
    //estudiantes
    router.define(studentsRoute, handler: DashboardHandlers.students, transitionType: TransitionType.fadeIn);
    //reportes
    router.define(reportsRoute, handler: DashboardHandlers.reports, transitionType: TransitionType.fadeIn);
    // 404 - Not Page Found
    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}
