import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/historique_item.dart';
import '../services/beneficiaire_repository.dart';
import '../widgets/status_badge.dart';
import '../widgets/async_builder.dart';

class HistoriqueScreen extends StatelessWidget {
  const HistoriqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AsyncBuilder(
          futureFactory: () => beneficiaireRepository.getHistorique(),
          builder: (context, items) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Historique', style: AppTextStyles.screenTitle),
                const SizedBox(height: 4),
                const Text('Mes soins pris en charge depuis le 1 sept. 2026', style: AppTextStyles.body),
                const SizedBox(height: 20),
                for (final item in items) ...[
                  _HistoriqueCard(item: item),
                  const SizedBox(height: 12),
                ],
                _AttributionCard(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HistoriqueCard extends StatelessWidget {
  final HistoriqueItem item;

  const _HistoriqueCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.date, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
              StatusBadge(label: item.statutLabel, type: item.statutType),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.titre, style: AppTextStyles.bodyBold),
          const SizedBox(height: 2),
          Text(item.prestataire, style: AppTextStyles.body),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: AppTextStyles.body,
                  children: [
                    const TextSpan(text: 'BioHealth : '),
                    TextSpan(
                      text: item.montantBH,
                      style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text('Payé par moi : ${item.montantPaye}', style: AppTextStyles.bodyBold.copyWith(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttributionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(child: Text('1 sept. · Budget attribué par ma mutuelle', style: AppTextStyles.body)),
          Text('10 000 BH', style: AppTextStyles.bodyBold),
        ],
      ),
    );
  }
}