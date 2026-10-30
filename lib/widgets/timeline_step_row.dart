import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/prise_en_charge_detail.dart';

/// Une ligne de la timeline : un cercle (coché / en cours / vide) + titre + description.
/// On pourra réutiliser ce widget sur P5 plus tard, qui a une timeline similaire.
class TimelineStepRow extends StatelessWidget {
  final TimelineStep step;
  final bool isLast; // true si c'est la dernière étape (pas de ligne verticale après)

  const TimelineStepRow({
    super.key,
    required this.step,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _buildCircle(),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE5E7EB),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.titre,
                    style: AppTextStyles.bodyBold.copyWith(
                      color: step.etat == EtapeEtat.aVenir
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(step.description, style: AppTextStyles.body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle() {
    switch (step.etat) {
      case EtapeEtat.fait:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 16),
        );
      case EtapeEtat.enCours:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.warningAmber, width: 2.5),
          ),
        );
      case EtapeEtat.aVenir:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD1D5DB), width: 2),
          ),
        );
    }
  }
}