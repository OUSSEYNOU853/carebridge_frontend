import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// La barre de progression à 3 couleurs qu'on voit sur B1 :
/// [gris = utilisé] [orange = en cours] [vert = disponible]

class BudgetProgressBar extends StatelessWidget {
  final int utilise;
  final int enCours;
  final int disponible;

  const BudgetProgressBar({
    super.key,
    required this.utilise,
    required this.enCours,
    required this.disponible,
  });

  @override
  Widget build(BuildContext context) {
    final total = utilise + enCours + disponible;

    // Sécurité : si jamais le total est à 0 (pas encore de budget attribué),
    // on évite une division par zéro en affichant une barre vide grise.
    if (total == 0) {
      return Container(
        height: 8,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return ClipRRect(
      // ClipRRect arrondit les coins de tout ce qu'il contient, même la
      // Row à l'intérieur - sinon seul le rectangle extérieur serait arrondi.
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 8,
        child: Row(
          children: [
            // Expanded + flex : chaque segment prend une proportion de la largeur
            // totale équivalente à (sa valeur / le total). C'est l'équivalent
            // Flutter d'un "flex-grow" en CSS.
            Expanded(
              flex: utilise,
              child: Container(color: Colors.white38),
            ),
            Expanded(
              flex: enCours,
              child: Container(color: AppColors.warningAmber),
            ),
            Expanded(
              flex: disponible,
              child: Container(color: AppColors.primaryGreen),
            ),
          ],
        ),
      ),
    );
  }
}