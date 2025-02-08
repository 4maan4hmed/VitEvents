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

  static const listTitle = TextStyle(
    color: AppColors.blue1,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
  );

  static const bodyMedium = TextStyle(
    color: AppColors.blue2,
    fontSize: 11.0,
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
    color: AppColors.gray,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
  );
  static const searchBar = TextStyle(
    color: AppColors.blue1,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  static var cardSubtitle;

  static var headline6;

  static var subtitle1;

  static var bodyText2;

  static var headingXL;
}
