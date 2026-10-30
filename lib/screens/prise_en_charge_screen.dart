import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/prise_en_charge_detail.dart';
import '../services/beneficiaire_repository.dart';
import '../widgets/status_badge.dart';
import '../widgets/timeline_step_row.dart';
import '../widgets/async_builder.dart';

class PriseEnChargeScreen extends StatelessWidget {
  const PriseEnChargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prise en charge en cours'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: AsyncBuilder(
          futureFactory: () => beneficiaireRepository.getPriseEnChargeDetail(),
          builder: (context, detail) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailCard(detail: detail),
                  const SizedBox(height: 16),
                  _EtapesCard(etapes: detail.etapes),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Flux de signalement à définir avec l\'équipe'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Ce n'est pas moi · signaler un problème",
                      style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Si le traitement n'est pas remis, les 1 000 BH reviennent dans "
                    'votre budget disponible.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final PriseEnChargeDetail detail;

  const _DetailCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: StatusBadge(label: detail.statutLabel, type: StatusType.warning),
          ),
          const SizedBox(height: 12),
          Text(detail.prestataireNom, style: AppTextStyles.screenTitle.copyWith(fontSize: 18)),
          const SizedBox(height: 2),
          Text('${detail.categorie} · ${detail.dateHeure}', style: AppTextStyles.body),
          const SizedBox(height: 16),
          _MontantRow(label: 'Coût du traitement', valeur: '${detail.coutTraitementFCFA} FCFA'),
          const SizedBox(height: 8),
          _MontantRow(label: 'BioHealth couvre', valeur: '− ${detail.couvertBH} BH', valeurColor: AppColors.primaryGreen),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RESTE À PAYER À LA PHARMACIE', style: AppTextStyles.labelCaps.copyWith(color: AppColors.primaryGreen)),
                const SizedBox(height: 6),
                Text('${detail.resteAPayerFCFA} FCFA', style: AppTextStyles.amountLarge.copyWith(fontSize: 36)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('Pourquoi ? ${detail.explication}', style: AppTextStyles.body),
        ],
      ),
    );
  }
}

class _MontantRow extends StatelessWidget {
  final String label;
  final String valeur;
  final Color? valeurColor;

  const _MontantRow({required this.label, required this.valeur, this.valeurColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body),
        Text(valeur, style: AppTextStyles.bodyBold.copyWith(color: valeurColor ?? AppColors.textPrimary)),
      ],
    );
  }
}

class _EtapesCard extends StatelessWidget {
  final List<TimelineStep> etapes;

  const _EtapesCard({required this.etapes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ÉTAPES', style: AppTextStyles.labelCaps.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          for (int i = 0; i < etapes.length; i++)
            TimelineStepRow(step: etapes[i], isLast: i == etapes.length - 1),
        ],
      ),
    );
  }
}