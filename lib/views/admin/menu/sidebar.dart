import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/session_model.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';
import 'package:passport_unifranz_web/views/admin/menu/logo.dart';
import 'package:passport_unifranz_web/components/widgets/menu_item.dart';
import 'package:passport_unifranz_web/components/widgets/text_separator.dart';
import 'package:passport_unifranz_web/provider/auth_provider.dart';
import 'package:passport_unifranz_web/provider/sidemenu_provider.dart';
import 'package:passport_unifranz_web/router/router.dart';
import 'package:passport_unifranz_web/services/navigation_service.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void navigateTo(String routeName) {
    NavigationService.replaceTo(routeName);
    SideMenuProvider.closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
    final session = sessionModelFromJson(LocalStorage.prefs.getString('userData')!);
    return Container(
      width: 200,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: Column(
        children: [
          const Logo(),
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                const TextSeparator(text: 'Principal'),
                MenuItem(
                  text: 'Dashboard',
                  icon: Icons.compass_calibration_outlined,
                  onPressed: () => navigateTo(Flurorouter.dashboardRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
                ),
                MenuItem(
                  text: 'Calendario',
                  icon: Icons.event_available_sharp,
                  onPressed: () => navigateTo(Flurorouter.calendarRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.calendarRoute,
                ),
                if (session.permisions
                    .where((e) => e.category == 'Eventos' || e.category == 'Expositores' || e.category == 'Categorias')
                    .isNotEmpty)
                  const TextSeparator(text: 'Administración de eventos'),
                if (session.permisions.where((e) => e.category == 'Eventos').isNotEmpty)
                  MenuItem(
                    text: 'Eventos',
                    icon: Icons.event_available_sharp,
                    onPressed: () => navigateTo(Flurorouter.eventsRoute),
                    isActive: sideMenuProvider.currentPage == Flurorouter.eventsRoute,
                  ),
                if (session.permisions.where((e) => e.category == 'Expositores').isNotEmpty)
                  MenuItem(
                    text: 'Expositores',
                    icon: Icons.co_present_rounded,
                    onPressed: () => navigateTo(Flurorouter.guestsRoute),
                    isActive: sideMenuProvider.currentPage == Flurorouter.guestsRoute,
                  ),
                if (session.permisions.where((e) => e.category == 'Categorias').isNotEmpty)
                  MenuItem(
                    text: 'Categorias',
                    icon: Icons.layers_outlined,
                    onPressed: () => navigateTo(Flurorouter.categoriesRoute),
                    isActive: sideMenuProvider.currentPage == Flurorouter.categoriesRoute,
                  ),
                if (session.permisions
                    .where((e) =>
                        e.category == 'Usuarios' ||
                        e.category == 'Tipos de usuario' ||
                        e.category == 'Roles' ||
                        e.category == 'Permisos')
                    .isNotEmpty)
                  const TextSeparator(text: 'Administración de usuarios'),
                if (session.permisions.where((e) => e.category == 'Usuarios').isNotEmpty)
                  MenuItem(
                    text: 'Usuarios',
                    icon: Icons.people_alt_outlined,
                    onPressed: () => navigateTo(Flurorouter.usersRoute),
                    isActive: sideMenuProvider.currentPage == Flurorouter.usersRoute,
                  ),
                if (session.permisions.where((e) => e.category == 'Tipos de usuario').isNotEmpty)
                  MenuItem(
                    text: 'Tipos de usuario',
                    icon: Icons.people_alt_outlined,
                    onPressed: () => navigateTo(Flurorouter.typeUsersRoute),
                    isActive: sideMenuProvider.currentPage == Flurorouter.typeUsersRoute,
                  ),
                if (session.permisions.where((e) => e.category == 'Roles').isNotEmpty)
                  MenuItem(
                    text: 'Roles',
                    icon: Icons.people_alt_outlined,
                    onPressed: () => navigateTo(Flurorouter.rolesRoute),
                    isActive: sideMenuProvider.currentPage == Flurorouter.rolesRoute,
                  ),
                if (session.permisions.where((e) => e.category == 'Permisos').isNotEmpty)
                  MenuItem(
                    text: 'Permisos',
                    icon: Icons.check_box,
                    onPressed: () => navigateTo(Flurorouter.permisionsRoute),
                    isActive: sideMenuProvider.currentPage == Flurorouter.permisionsRoute,
                  ),
                if (session.permisions.where((e) => e.category == 'Estudiantes').isNotEmpty)
                  const TextSeparator(text: 'Administración de estudiantes'),
                if (session.permisions.where((e) => e.category == 'Estudiantes').isNotEmpty)
                  MenuItem(
                    text: 'Estudiantes',
                    icon: Icons.people_alt_outlined,
                    onPressed: () => navigateTo(Flurorouter.studentsRoute),
                    isActive: sideMenuProvider.currentPage == Flurorouter.studentsRoute,
                  ),
                if (session.permisions.where((e) => e.category == 'Reportes').isNotEmpty)
                  const TextSeparator(text: 'Reportes'),
                if (session.permisions.where((e) => e.category == 'Reportes').isNotEmpty)
                  MenuItem(
                    text: 'Reportes',
                    icon: Icons.people_alt_outlined,
                    onPressed: () => navigateTo(Flurorouter.reportsRoute),
                    isActive: sideMenuProvider.currentPage == Flurorouter.reportsRoute,
                  ),
                const SizedBox(height: 30),
                const TextSeparator(text: 'Salir'),
                MenuItem(
                    text: 'Salir sesión',
                    icon: Icons.exit_to_app_outlined,
                    onPressed: () {
                      Provider.of<AuthProvider>(context, listen: false).logout();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => const BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xff092044),
        Color(0xff092042),
      ]),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]);
}
