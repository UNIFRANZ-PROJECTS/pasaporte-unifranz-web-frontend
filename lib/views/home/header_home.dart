import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/models/session_student_model.dart';
import 'package:passport_unifranz_web/provider/auth_provider.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';
import 'package:provider/provider.dart';

class HaaderHome extends StatelessWidget {
  final Function() logIn;
  final Function() logOut;
  final bool isBlack;
  final String title;
  const HaaderHome({super.key, required this.title, required this.logIn, required this.logOut, this.isBlack = false});

  get json => null;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    SessionStudentModel? student;
    if (authProvider.authStatusStudent == AuthStatusStudent.authenticated) {
      student = sessionStudentModelFromJson(LocalStorage.prefs.getString('student')!);
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  authProvider.authStatusStudent != AuthStatusStudent.authenticated
                      ? Text(
                          title,
                          style: TextStyle(color: isBlack ? Colors.black : Colors.white),
                        )
                      : Text(
                          'Hola ${student!.name}',
                          style: TextStyle(color: isBlack ? Colors.black : Colors.white),
                        ),
                  Text(
                    'PASAPORTE UNIFRANZ',
                    style: TextStyle(
                        color: isBlack ? Colors.black : Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            authProvider.authStatusStudent != AuthStatusStudent.authenticated
                ? ButtonBlackComponent(text: 'INGRESAR', onPressed: () => logIn())
                : ButtonBlackComponent(text: 'SALIR', onPressed: () => logOut())
          ]),
    );
  }
}
