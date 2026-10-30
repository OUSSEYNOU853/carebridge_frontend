import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_theme.dart';
import '../models/budget_data.dart';
import '../services/beneficiaire_repository.dart';
import '../widgets/status_badge.dart';
import '../widgets/budget_progress_bar.dart';
import '../widgets/async_builder.dart';
import 'prise_en_charge_screen.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // AsyncBuilder remplace les données en dur d'avant : il appelle
        // le repository, affiche un loader pendant l'attente, une erreur
        // avec bouton "Réessayer" si ça échoue, ou le contenu une fois prêt.
        child: AsyncBuilder(
          futureFactory: () => beneficiaireRepository.getBudgetScreenData(),
          builder: (context, data) {
            final budget = data.budget;
            final priseEnCours = data.priseEnCours;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(nom: budget.nomBeneficiaire),
                  const SizedBox(height: 20),
                  _BudgetCard(budget: budget),
                  if (priseEnCours != null) ...[
                    const SizedBox(height: 16),
                    _PriseEnChargeCard(
                      priseEnCours: priseEnCours,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PriseEnChargeScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  _QrCard(identifiant: budget.identifiant),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String nom;

  const _Header({required this.nom});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bonjour,', style: AppTextStyles.body),
            Text(nom, style: AppTextStyles.screenTitle.copyWith(fontSize: 22)),
          ],
        ),
        const StatusBadge(label: 'Couverture active', type: StatusType.success),
      ],
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final BudgetData budget;

  const _BudgetCard({required this.budget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MON BUDGET BIOHEALTH',
            style: AppTextStyles.labelCaps.copyWith(color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${budget.disponible}', style: AppTextStyles.amountLarge),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'BH disponibles',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Couvre jusqu\'à ${budget.disponibleEnFCFA} FCFA de soins éligibles',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          BudgetProgressBar(
            utilise: budget.utilise,
            enCours: budget.enCours,
            disponible: budget.disponible,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatColumn(label: 'Utilisé', valeur: '${budget.utilise} BH'),
              _StatColumn(label: 'En cours', valeur: '${budget.enCours} BH', color: AppColors.warningAmber),
              _StatColumn(label: 'Disponible', valeur: '${budget.disponible} BH', color: AppColors.primaryGreen),
              _StatColumn(label: 'Attribué', valeur: '${budget.attribue} BH'),
            ],
          ),
          const Divider(color: Colors.white24, height: 32),
          Text(
            'Parcours : ${budget.parcoursNom} · valable jusqu\'au ${budget.validiteDate}. '
            'Utilisable dans les centres et pharmacies partenaires.',
            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String valeur;
  final Color color;

  const _StatColumn({required this.label, required this.valeur, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 4),
          Text(valeur, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

class _PriseEnChargeCard extends StatelessWidget {
  final PriseEnChargeEnCours priseEnCours;
  final VoidCallback onTap;

  const _PriseEnChargeCard({required this.priseEnCours, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.warningAmberBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRISE EN CHARGE EN COURS',
                    style: AppTextStyles.labelCaps.copyWith(color: AppColors.warningAmberText),
                  ),
                  const SizedBox(height: 6),
                  Text(priseEnCours.prestataireNom, style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  Text(
                    'BioHealth couvre ${priseEnCours.montantCouvertBH} BH · '
                    'reste à payer ${priseEnCours.resteAPayerFCFA} FCFA',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.warningAmberText),
          ],
        ),
      ),
    );
  }
}

class _QrCard extends StatelessWidget {
  final String identifiant;

  const _QrCard({required this.identifiant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QrImageView(data: identifiant, size: 90, backgroundColor: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MON IDENTIFIANT CAREBRIDGE',
                  style: AppTextStyles.labelCaps.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Text(identifiant, style: AppTextStyles.screenTitle.copyWith(fontSize: 20)),
                const SizedBox(height: 6),
                const Text(
                  'À présenter au centre ou à la pharmacie. Ce code ne contient '
                  'aucune donnée de santé.',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}