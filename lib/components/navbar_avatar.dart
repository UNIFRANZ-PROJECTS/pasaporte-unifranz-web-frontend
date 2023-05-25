import 'package:flutter/material.dart';

class NavbarAvatar extends StatelessWidget {
  final String name;
  final String image;
  const NavbarAvatar({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: SizedBox(
            width: 30,
            height: 30,
            child: Image.network(image),
          ),
        ),
        Text(name),
      ],
    );
  }
}
