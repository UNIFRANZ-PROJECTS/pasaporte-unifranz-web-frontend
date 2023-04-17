import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passport_unifranz_web/provider/auth_provider.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/navigation_service.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:provider/provider.dart';

import 'package:passport_unifranz_web/components/compoents.dart';

class DialogLogin extends StatefulWidget {
  const DialogLogin({Key? key}) : super(key: key);

  @override
  State<DialogLogin> createState() => _DialogLoginState();
}

class _DialogLoginState extends State<DialogLogin> {
  bool stateLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController codeCtrl = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return FadeIn(
        child: AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: const Text(
        'Inicio de sesión',
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: formKey,
        child: InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: codeCtrl,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z.@]"))],
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'ingrese su código';
            }
          },
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.characters,
          icon: Icons.search,
          labelText: "Código de estudiante",
        ),
      ),
      actions: [
        !stateLoading
            ? ButtonComponent(text: 'Iniciar Sesión', onPressed: () => initSession())
            : Center(
                child: Image.asset(
                'assets/gifs/load.gif',
                fit: BoxFit.cover,
                height: 20,
              ))
      ],
    ));
  }

  initSession() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      setState(() => stateLoading = !stateLoading);
      FormData formData = FormData.fromMap({
        'code': codeCtrl.text.trim(),
      });
      return CafeApi.post(students(), formData).then((res) async {
        setState(() => stateLoading = !stateLoading);
        authProvider.loginStudent(res);
        Navigator.of(context).pop();
        NavigationService.replaceTo('/${res.data['uid']}');
      }).catchError((e) {
        setState(() => stateLoading = !stateLoading);
        debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
        callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
      });
    }
  }
}
