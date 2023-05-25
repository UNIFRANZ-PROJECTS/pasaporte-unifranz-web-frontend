import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/models/event_model.dart';

class EventDetailsContent extends StatelessWidget {
  final EventModel event;
  final Function() onPressed;
  const EventDetailsContent({super.key, required this.event, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.2),
            child: Text(event.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white))),
        const SizedBox(
          height: 170,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.guestIds.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text("INVITADOS", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                if (event.guestIds.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for (final item in event.guestIds)
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    event.description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ButtonComponent(text: 'ASISTIR', onPressed: () => onPressed()),
      ],
    );
  }
}
