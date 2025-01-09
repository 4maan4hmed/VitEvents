import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application typography definition
class AppTypography {
  static const displayLarge = TextStyle(
    color: AppColors.blue1,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );

  static const bodyLarge = TextStyle(
    color: AppColors.blue1,
    fontSize: 16.0,
  );

  static const bodyMedium = TextStyle(
    color: AppColors.blue2,
    fontSize: 14.0,
  );

  static const cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.blue1,
  );

  static const cardPrice = TextStyle(
    color: AppColors.priceText,
    fontSize: 16,
  );

  static const cardDate = TextStyle(
    color: AppColors.cardDateText,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const cardMonth = TextStyle(
    color: AppColors.cardDateText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const pageTitle = TextStyle(
    color: AppColors.gray2,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );
}
