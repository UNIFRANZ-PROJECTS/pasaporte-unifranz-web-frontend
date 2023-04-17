import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/views/admin/dashboard_layout.dart';
import 'package:passport_unifranz_web/views/layout.dart';
import 'package:passport_unifranz_web/views/pages/splash_layout.dart';
import 'package:passport_unifranz_web/provider/app_state.dart';
import 'package:passport_unifranz_web/provider/auth_provider.dart';
import 'package:passport_unifranz_web/provider/sidemenu_provider.dart';
import 'package:passport_unifranz_web/router/router.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';
import 'package:passport_unifranz_web/services/notifications_service.dart';
import 'package:passport_unifranz_web/utils/style.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'bloc/blocs.dart';
import 'locator.dart';
import 'services/navigation_service.dart';

void main() async {
  setupLocator();
  Flurorouter.configureRoutes();
  WidgetsFlutterBinding.ensureInitialized();
  CafeApi.configureDio();
  await LocalStorage.configurePrefs();
  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => UserBloc()),
          BlocProvider(create: (_) => EventBloc()),
          BlocProvider(create: (_) => CategoryBloc()),
          BlocProvider(create: (_) => PermisionBloc()),
          BlocProvider(create: (_) => RolBloc()),
          BlocProvider(create: (_) => TypeUserBloc()),
          BlocProvider(create: (_) => StudentBloc()),
          BlocProvider(create: (_) => GuestBloc()),
          BlocProvider(create: (_) => CareerBloc()),
          BlocProvider(create: (_) => DashboardBloc()),
          BlocProvider(create: (_) => ReportBloc()),
        ],
        child: MultiProvider(providers: [
          ChangeNotifierProvider(lazy: false, create: (_) => AuthProvider()),
          ChangeNotifierProvider(lazy: false, create: (_) => SideMenuProvider()),
          ChangeNotifierProvider(create: (_) => AppState()),
        ], child: const MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Spanish
        Locale('en', 'US'), // English
      ],
      debugShowCheckedModeBanner: false,
      theme: styleLigth(),
      title: 'PASAPORTE UNIFRANZ',
      initialRoute: '/',
      onGenerateRoute: Flurorouter.router.generator,
      navigatorKey: NavigationService.navigatorKey,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      builder: (_, child) {
        final authProvider = Provider.of<AuthProvider>(context);

        if (authProvider.authStatus == AuthStatus.checking) return const SplashLayout();

        if (authProvider.authStatus == AuthStatus.authenticated) {
          debugPrint('ESTOY LOGUEADO');
          return DashboardLayout(child: child!);
        } else {
          return LayoutScreen(child: child!);
        }
      },
    );
  }
}
