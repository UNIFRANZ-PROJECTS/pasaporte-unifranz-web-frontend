import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/provider/auth_provider.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool stateLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailCtrl = TextEditingController(text: 'moisic.mo@gmail.com');
  TextEditingController passwordCtrl = TextEditingController(text: '123123');
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            body: (size.width > 1000)
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [logo(), credentials()])
                : Column(
                    children: [logo(), credentials()],
                  )));
  }

  Future<bool> _onBackPressed() async {
    return false;
  }

  Widget logo() {
    final size = MediaQuery.of(context).size;
    return Expanded(
        flex: 1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: (size.width > 1000) ? 80 : 20),
          child: const Center(
            child: Image(
              image: AssetImage(
                'assets/images/logo.png',
              ),
            ),
          ),
        ));
  }

  Widget credentials() {
    final size = MediaQuery.of(context).size;
    return Expanded(
        flex: (size.width > 1000) ? 1 : 3,
        child: Center(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: (size.width > 1000) ? 80 : 20),
                child: Form(
                    key: formKey,
                    child: Column(children: [
                      const Text(
                        'PASAPORTE UNIFRANZ',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          InputComponent(
                            textInputAction: TextInputAction.done,
                            controllerText: emailCtrl,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z.@]"))],
                            onEditingComplete: () {},
                            validator: (value) {
                              if (value.isNotEmpty) {
                                if (value.contains("@") && value.contains(".com")) {
                                  return null;
                                } else {
                                  return 'ingrese su correo valido';
                                }
                              } else {
                                return 'ingrese su correo';
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.characters,
                            icon: Icons.search,
                            labelText: "Correo",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InputComponent(
                              textInputAction: TextInputAction.done,
                              controllerText: passwordCtrl,
                              onEditingComplete: () => initSession(),
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  if (value.length >= 6) {
                                    return null;
                                  } else {
                                    return 'Debe tener un mínimo de 6 caracteres.';
                                  }
                                } else {
                                  return 'Ingrese su contraseña';
                                }
                              },
                              // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                              keyboardType: TextInputType.text,
                              icon: Icons.lock,
                              labelText: "Contraseña",
                              obscureText: hidePassword,
                              onTap: () => setState(() => hidePassword = !hidePassword),
                              iconOnTap: hidePassword ? Icons.lock_outline : Icons.lock_open_sharp),
                          const SizedBox(
                            height: 10,
                          ),
                          stateLoading
                              ? Center(
                                  child: Image.asset(
                                  'assets/gifs/load.gif',
                                  fit: BoxFit.cover,
                                  height: 20,
                                ))
                              : ButtonComponent(text: 'INGRESAR', onPressed: () => initSession()),
                          // ButtonWhiteComponent(
                          //     text: 'Olvidé mi contraseña', onPressed: () => Navigator.pushNamed(context, '/forgot')),
                          // ButtonWhiteComponent(
                          //   text: 'Política de privacidad',
                          //   onPressed: () {},
                          // )
                        ],
                      ),
                    ])))));
  }

  initSession() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      setState(() => stateLoading = !stateLoading);
      FormData formData = FormData.fromMap({
        'email': emailCtrl.text.trim(),
        'password': passwordCtrl.text.trim(),
      });
      return CafeApi.post(setLogin(), formData).then((res) async {
        setState(() => stateLoading = !stateLoading);
        authProvider.login(res);
      }).catchError((e) {
        setState(() => stateLoading = !stateLoading);
        debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
        callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
      });
    }
  }
}
