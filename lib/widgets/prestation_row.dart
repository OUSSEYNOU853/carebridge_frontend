import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/prestation_couverte.dart';


class PrestationRow extends StatelessWidget {
  final PrestationCouverte prestation;

  const PrestationRow({super.key, required this.prestation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(prestation.nom, style: AppTextStyles.bodyBold),
                const SizedBox(height: 4),
                Text(prestation.detail, style: AppTextStyles.body),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _Badge(texte: prestation.compteur, epuise: prestation.epuise),
        ],
      ),
    );
  }
}


class _Badge extends StatelessWidget {
  final String texte;
  final bool epuise;

  const _Badge({required this.texte, required this.epuise});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: epuise
            ? const Color(0xFFE5E7EB) // gris clair si épuisé
            : AppColors.primaryGreen.withOpacity(0.15), // vert clair sinon
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texte,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: epuise ? AppColors.textSecondary : AppColors.primaryGreen,
        ),
      ),
    );
  }
}