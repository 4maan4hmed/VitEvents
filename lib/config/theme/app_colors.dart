import 'dart:ui';

/// Application color palette definition
class AppColors {
  // Base colors
  static const white = Color.fromARGB(255, 248, 248, 248); //
  static const gray = Color(0xFF9BA8AB); //
  static const gray1 = Color(0xFF4A5C6A); //
  static const gray2 = Color(0xFF253745); //
  static const blue = Color(0xFF11212D); //
  static const blue1 = Color(0xFF2C3E50);
  static const blue2 = Color(0xFF34495E);
  static const blueDark = Color(0xFF06141B); //

  // Semantic colors
  static const primary = gray2;
  static const secondary = gray1;
  static const background = white;
  static const surface = white;
  static const onBackground = white;
  static const onSurface = white;

  // Additional semantic colors
  static const cardDateBackground = Color.fromARGB(165, 0, 0, 0);
  static const cardDateText = Color(0xFFFFFFFF);
  static const priceText = Color(0xFF191975);
}
