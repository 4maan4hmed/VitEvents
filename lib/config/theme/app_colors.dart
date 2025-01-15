import 'dart:ui';

/// Application color palette definition
class AppColors {
  // Base colors
  static const white = Color(0xFFFFFFFF);
  static const white2 = Color(0xAAFFFFFF);
  static const gray1 = Color(0xFFF5F5F5);
  static const gray2 = Color(0xFFE0E0E0);
  static const gray3 = Color(0xFF9E9E9E);
  static const blue1 = Color(0xFF2C3E50);
  static const blue2 = Color(0xFF34495E);
  static const blueDark = Color(0xFF253745);

  // Semantic colors
  static const primary = blueDark;
  static const secondary = blue2;
  static const background = gray1;
  static const surface = white;
  static const onBackground = blue1;
  static const onSurface = blue1;

  // Additional semantic colors
  static const cardDateBackground = Color.fromARGB(165, 0, 0, 0);
  static const cardDateText = Color(0xFFFFFFFF);
  static const priceText = Color(0xFF191975);
}
