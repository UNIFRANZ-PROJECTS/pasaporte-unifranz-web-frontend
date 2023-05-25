import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passport_unifranz_web/components/compoents.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controllerText;
  final Function(String) onChanged;
  final bool isWhite;
  const SearchWidget({
    super.key,
    required this.controllerText,
    required this.onChanged,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: InputComponent(
          isWhite: isWhite,
          textInputAction: TextInputAction.done,
          controllerText: controllerText,
          onChanged: (value) => onChanged(value),
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'complemento';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          icon: Icons.search,
          labelText: "Buscar",
        ),
      ),
    );
  }
}
