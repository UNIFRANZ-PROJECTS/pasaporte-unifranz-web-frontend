import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/session_model.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';
import 'package:passport_unifranz_web/components/navbar_avatar.dart';
import 'package:passport_unifranz_web/provider/sidemenu_provider.dart';

class Navbar extends StatefulWidget {
  final Function() infoUser;
  const Navbar({super.key, required this.infoUser});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  TextEditingController searchCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final session = sessionModelFromJson(LocalStorage.prefs.getString('userData')!);

    return Container(
      width: double.infinity,
      height: 50,
      decoration: buildBoxDecoration(),
      child: Row(
        children: [
          if (size.width <= 700)
            IconButton(icon: const Icon(Icons.menu_outlined), onPressed: () => SideMenuProvider.openMenu()),
          const Spacer(),
          const SizedBox(width: 10),
          IconButton(
              icon: NavbarAvatar(
                name: session.name,
                image: session.image,
              ),
              onPressed: () => widget.infoUser()),
          const SizedBox(width: 10)
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() =>
      const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]);
}
