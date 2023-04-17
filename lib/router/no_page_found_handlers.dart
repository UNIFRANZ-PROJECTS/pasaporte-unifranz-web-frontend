import 'package:passport_unifranz_web/views/pages/view_404.dart';
import 'package:passport_unifranz_web/provider/sidemenu_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';

class NoPageFoundHandlers {
  static Handler noPageFound = Handler(handlerFunc: (context, params) {
    Provider.of<SideMenuProvider>(context!, listen: false).setCurrentPageUrl('/404');

    return const View404();
  });
}
