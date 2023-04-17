import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/views/pages/admin/widgets/logo.dart';
import 'package:passport_unifranz_web/views/pages/admin/widgets/menu_item.dart';
import 'package:passport_unifranz_web/views/pages/admin/widgets/text_separator.dart';
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

    return Container(
      width: 200,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          const Logo(),
          const SizedBox(height: 50),
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
          const TextSeparator(text: 'Administración de eventos'),
          MenuItem(
            text: 'Eventos',
            icon: Icons.event_available_sharp,
            onPressed: () => navigateTo(Flurorouter.eventsRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.eventsRoute,
          ),
          MenuItem(
            text: 'Expositores',
            icon: Icons.co_present_rounded,
            onPressed: () => navigateTo(Flurorouter.guestsRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.guestsRoute,
          ),
          MenuItem(
            text: 'Categorias',
            icon: Icons.layers_outlined,
            onPressed: () => navigateTo(Flurorouter.categoriesRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.categoriesRoute,
          ),
          const TextSeparator(text: 'Administración de usuarios'),
          MenuItem(
            text: 'Usuarios',
            icon: Icons.people_alt_outlined,
            onPressed: () => navigateTo(Flurorouter.usersRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.usersRoute,
          ),
          MenuItem(
            text: 'Tipos de usuario',
            icon: Icons.people_alt_outlined,
            onPressed: () => navigateTo(Flurorouter.typeUsersRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.typeUsersRoute,
          ),
          MenuItem(
            text: 'Roles',
            icon: Icons.people_alt_outlined,
            onPressed: () => navigateTo(Flurorouter.rolesRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.rolesRoute,
          ),
          MenuItem(
            text: 'Permisos',
            icon: Icons.check_box,
            onPressed: () => navigateTo(Flurorouter.permisionsRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.permisionsRoute,
          ),
          const TextSeparator(text: 'Administración de usuarios'),
          MenuItem(
            text: 'Estudiantes',
            icon: Icons.people_alt_outlined,
            onPressed: () => navigateTo(Flurorouter.studentsRoute),
            isActive: sideMenuProvider.currentPage == Flurorouter.studentsRoute,
          ),
          const TextSeparator(text: 'Reportes'),
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
    );
  }

  BoxDecoration buildBoxDecoration() => const BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xff092044),
        Color(0xff092042),
      ]),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]);
}
