import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


enum StatusType { success, warning, danger, neutral, info }


class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  // Renvoie (couleur de fond, couleur du texte) selon le type de statut
  (Color, Color) get _colors {
    switch (type) {
      case StatusType.success:
        return (AppColors.primaryGreen.withOpacity(0.15), AppColors.primaryGreen);
      case StatusType.warning:
        return (AppColors.warningAmberBackground, AppColors.warningAmberText);
      case StatusType.danger:
        return (AppColors.errorRedBackground, AppColors.errorRed);
      case StatusType.neutral:
        return (const Color(0xFFE5E7EB), AppColors.textSecondary);
      case StatusType.info:
        return (const Color(0xFFDCE5F5), const Color(0xFF2E4F8C));
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}