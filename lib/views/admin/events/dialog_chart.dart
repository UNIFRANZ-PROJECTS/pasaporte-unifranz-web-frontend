import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passport_unifranz_web/models/event_model.dart';

class DialogChartEvent extends StatefulWidget {
  final EventModel event;

  const DialogChartEvent({super.key, required this.event});

  @override
  State<DialogChartEvent> createState() => _DialogChartEventState();
}

class _DialogChartEventState extends State<DialogChartEvent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleCtrl = TextEditingController();
  String? imageFile;
  Uint8List? bytes;
  bool stateLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: const [],
        ));
  }
}
