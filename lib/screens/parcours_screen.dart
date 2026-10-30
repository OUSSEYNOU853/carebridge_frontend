import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/beneficiaire_repository.dart';
import '../widgets/prestation_row.dart';
import '../widgets/async_builder.dart';
import '../models/prestation_couverte.dart';

class ParcoursScreen extends StatelessWidget {
  const ParcoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AsyncBuilder(
          futureFactory: () => beneficiaireRepository.getParcoursData(),
          builder: (context, data) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mon parcours', style: AppTextStyles.screenTitle),
                  const SizedBox(height: 4),
                  const Text("Suivi hypertension · jusqu'au 29 nov. 2026", style: AppTextStyles.body),
                  const SizedBox(height: 20),
                  _WhiteCard(
                    title: 'CE QUE BIOHEALTH COUVRE',
                    child: Column(
                      children: [
                        for (int i = 0; i < data.prestations.length; i++) ...[
                          PrestationRow(prestation: data.prestations[i]),
                          if (i < data.prestations.length - 1) const Divider(height: 1),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _WhiteCard(
                    title: 'OÙ UTILISER MON BUDGET',
                    child: Column(
                      children: [
                        for (int i = 0; i < data.prestataires.length; i++) ...[
                          _PrestataireRow(prestataire: data.prestataires[i]),
                          if (i < data.prestataires.length - 1) const Divider(height: 1),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "BioHealth est un budget de prise en charge pour des soins "
                    "autorisés. Il ne se retire pas en espèces et ne se transfère pas.",
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

class _WhiteCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _WhiteCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.labelCaps.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _PrestataireRow extends StatelessWidget {
  final PrestatairePartenaire prestataire;

  const _PrestataireRow({required this.prestataire});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(prestataire.nom, style: AppTextStyles.bodyBold),
                const SizedBox(height: 4),
                Text(prestataire.type, style: AppTextStyles.body),
              ],
            ),
          ),
          Text(prestataire.localisation, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}