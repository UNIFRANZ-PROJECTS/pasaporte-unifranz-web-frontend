import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/provider/auth_provider.dart';
import 'package:passport_unifranz_web/services/navigation_service.dart';
import 'package:passport_unifranz_web/views/client/access/login_client.dart';
import 'package:passport_unifranz_web/views/client/headers.dart';
import 'package:provider/provider.dart';

class CampusScreen extends StatefulWidget {
  const CampusScreen({super.key});

  @override
  State<CampusScreen> createState() => _CampusScreenState();
}

class _CampusScreenState extends State<CampusScreen> {
  bool isHovering01 = false;
  bool isHovering02 = false;
  bool isHovering03 = false;
  bool isHovering04 = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        HedersComponent(
          onPressLogin: () => loginshow(context),
          onPressLogout: () => logout(context),
        ),
        Expanded(
            child: (size.width > 1000)
                ? Row(
                    children: [
                      cardCampus('assets/images/home-01.jpg', 'La Paz', isHovering01),
                      cardCampus('assets/images/home-02.jpg', 'El Alto', isHovering02),
                      cardCampus('assets/images/home-03.jpg', 'Cochabamba', isHovering03),
                      cardCampus('assets/images/home-04.jpg', 'Santa Cruz', isHovering04),
                    ],
                  )
                : Column(
                    children: [
                      cardCampus('assets/images/home-01.jpg', 'La Paz', isHovering01),
                      cardCampus('assets/images/home-02.jpg', 'El Alto', isHovering02),
                      cardCampus('assets/images/home-03.jpg', 'Cochabamba', isHovering03),
                      cardCampus('assets/images/home-04.jpg', 'Santa Cruz', isHovering04),
                    ],
                  ))
      ],
    );
  }

  void loginshow(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) => const DialogLogin());
  }

  void logout(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logoutStudent();
    NavigationService.replaceTo('/');
  }

  Widget cardCampus(String img, String name, bool state) {
    return Expanded(
      child: InkWell(
        onTap: () {
          switch (name) {
            case 'La Paz':
              NavigationService.replaceTo('/lp');
              break;
            case 'El Alto':
              NavigationService.replaceTo('/ea');
              break;
            case 'Cochabamba':
              NavigationService.replaceTo('/cbba');
              break;
            case 'Santa Cruz':
              NavigationService.replaceTo('/sc');
              break;
          }
        },
        onHover: (hovering) {
          switch (name) {
            case 'La Paz':
              setState(() => isHovering01 = hovering);
              break;
            case 'El Alto':
              setState(() => isHovering02 = hovering);
              break;
            case 'Cochabamba':
              setState(() => isHovering03 = hovering);
              break;
            case 'Santa Cruz':
              setState(() => isHovering04 = hovering);
              break;
          }
        },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
            padding: EdgeInsets.all(state ? 0 : 10),
            child: Stack(children: <Widget>[
              ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
                    ),
                  )),
              Container(
                color: state ? const Color.fromRGBO(255, 255, 255, 0.19) : Colors.transparent,
              ),
              Container(
                alignment: Alignment.center,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.white),
                        )),
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}
