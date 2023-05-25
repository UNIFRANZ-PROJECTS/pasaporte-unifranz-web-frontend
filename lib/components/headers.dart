import 'package:flutter/material.dart';

class HedersComponent extends StatefulWidget {
  final String? titleHeader;
  final String? title;
  final bool center;
  final bool? stateBell;
  final GlobalKey? keyNotification;
  final bool? stateIconMuserpol;
  final bool stateBack;
  final bool initPage;
  final Function()? onPressLogin;
  final Function()? onPressLogout;
  const HedersComponent({
    Key? key,
    this.titleHeader,
    this.title,
    this.center = false,
    this.stateBell = false,
    this.keyNotification,
    this.stateIconMuserpol = true,
    this.stateBack = true,
    this.initPage = true,
    this.onPressLogin,
    this.onPressLogout,
  }) : super(key: key);

  @override
  State<HedersComponent> createState() => _HedersComponentState();
}

class _HedersComponentState extends State<HedersComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(widget.title!,
                textAlign: widget.center ? TextAlign.center : TextAlign.start,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
      ],
    );
  }
}
