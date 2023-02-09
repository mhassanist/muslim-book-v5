//palette.dart
import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = const MaterialColor(
    0XFF347D53, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff2f714b), //10%
      100: const Color(0xff2a6442), //20%
      200: const Color(0xff24583a), //30%
      300: const Color(0xff1f4b32), //40%
      400: const Color(0xff1a3f2a), //50%
      500: const Color(0xff153221), //60%
      600: const Color(0xff102519), //70%
      700: const Color(0xff0a1911), //80%
      800: const Color(0xff050c08), //90%
      900: const Color(0xff000000), //100%
    },
  );
} // you can define define int 500 as the default shade and add your lighter tints above and darker tints below.
