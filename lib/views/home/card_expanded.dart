import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/event_model.dart';
import 'package:passport_unifranz_web/provider/auth_provider.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/home/access/login_client.dart';

import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/views/home/event_details_background.dart';
import 'package:passport_unifranz_web/views/home/event_details_content.dart';
import 'package:provider/provider.dart';

class CardExpanded extends StatefulWidget {
  final EventModel event;
  const CardExpanded({Key? key, required this.event}) : super(key: key);

  @override
  State<CardExpanded> createState() => _CardExpandedState();
}

class _CardExpandedState extends State<CardExpanded> {
  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0.5),
        body: GestureDetector(
          child: Center(
            child: Hero(
                tag: 'flipcardHero${widget.event.id}',
                child: Material(
                  type: MaterialType.transparency,
                  child: GestureDetector(
                      onTap: () {},
                      child: ContainerComponent(
                          radius: (size.width > 1000) ? 30 : 0,
                          height: (size.width > 1000) ? sizeHeight / 1.5 : size.height,
                          width: (size.width > 1000) ? MediaQuery.of(context).size.width / 1.1 : size.width,
                          child: (size.width > 1000)
                              ? Row(
                                  children: cards(sizeHeight),
                                )
                              : Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    EventDetailBackground(event: widget.event),
                                    EventDetailsContent(
                                      event: widget.event,
                                      onPressed: () => loginshow(context),
                                    ),
                                  ],
                                ))),
                )),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  List<Widget> cards(double sizeHeight) {
    final authProvider = Provider.of<AuthProvider>(context);
    return [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            child: Image.network(
              widget.event.image,
              height: sizeHeight / 1.5,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: Text(widget.event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
              const SizedBox(height: 8),
              Flexible(child: Text(widget.event.description)),
              if (widget.event.guestIds.isNotEmpty)
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Invitados",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          for (final item in widget.event.guestIds)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ClipOval(
                                child: Image.network(
                                  item.image,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              authProvider.authStatusStudent != AuthStatusStudent.authenticated
                  ? ButtonComponent(text: 'ASISTIR', onPressed: () => loginshow(context))
                  : !widget.event.studentIds
                          .map((e) => e.id)
                          .contains(json.decode(LocalStorage.prefs.getString('student')!)['id'])
                      ? ButtonComponent(text: 'ASISTIR', onPressed: () => loginshow(context))
                      : Container()
            ],
          ),
        ),
      ),
    ];
  }

  void loginshow(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.authStatusStudent != AuthStatusStudent.authenticated) {
      showDialog(context: context, builder: (BuildContext context) => const DialogLogin());
    } else {
      CafeApi.configureDio();
      // callDialogAction(context, 'Se agrego correctamente el evento');
      CafeApi.put(studentsAddEvent(widget.event.id), null).then((res) async {
        // setState(() => stateLoading = !stateLoading);
        // authProvider.loginStudent(res);
        Navigator.of(context).pop();
      }).catchError((e) {
        // setState(() => stateLoading = !stateLoading);
        debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
        callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
      });
    }
  }
}
