import 'dart:ui';

class Parse {
  Parse._();

  static Color? color(String? value) {
    if (value != null) {
      try {
        return Color(int.parse('0xFF$value'));
      } catch (_) {}
    }

    return null;
  }
}