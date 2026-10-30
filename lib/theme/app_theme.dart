import 'package:flutter/material.dart';

/// Toutes les couleurs et styles de l'app CareBridge, centralisés ici.
/// Si on doit changer une couleur plus tard, on la change une seule fois,
/// à cet endroit — pas besoin de chercher dans chaque écran.
class AppColors {
  // Fond général de l'app (vert très clair, presque blanc)
  static const Color background = Color(0xFFF2F5F2);

  // Le bloc sombre "Mon budget BioHealth" sur B1
  static const Color darkCard = Color(0xFF0B2E2A);

  // Vert vif utilisé pour les montants, succès, "Disponible"
  static const Color primaryGreen = Color(0xFF1FAE8E);

  // Orange/ambre utilisé pour "En cours", "Partiellement autorisée"
  static const Color warningAmber = Color(0xFFF5C77E);
  static const Color warningAmberBackground = Color(0xFFFBE8C8);
  static const Color warningAmberText = Color(0xFF8A5A14);

  // Rouge utilisé pour "Refusée", "Échec"
  static const Color errorRed = Color(0xFFD64545);
  static const Color errorRedBackground = Color(0xFFFBE2E2);

  // Gris utilisé pour le texte secondaire, les statuts inactifs
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textPrimary = Color(0xFF111827);

  // Blanc pour les cartes sur fond clair
  static const Color white = Color(0xFFFFFFFF);
}

class AppTextStyles {
  // Le très gros chiffre du montant BH sur B1 (ex: "5 000")
  static const TextStyle amountLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // Titres d'écran (ex: "Mon parcours", "Historique")
  static const TextStyle screenTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Sous-titres / labels en majuscules (ex: "MON BUDGET BIOHEALTH")
  static const TextStyle labelCaps = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Texte normal du corps
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  // Texte important en gras (ex: nom du bénéficiaire, titres de carte)
  static const TextStyle bodyBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}

/// Le thème complet de l'app, à brancher dans MaterialApp
ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Roboto', // police par défaut, à remplacer si vous en choisissez une autre
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryGreen,
    primary: AppColors.primaryGreen,
  ),
);