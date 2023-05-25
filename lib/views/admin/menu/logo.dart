import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset('assets/images/logo.png'),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              'Pasaporte Unifranz',
              // style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
