import 'package:flutter/material.dart';
import '../widgets/status_badge.dart';

/// Décrit une ligne de l'historique (un soin pris en charge, ou l'attribution
/// initiale du budget par la mutuelle).
class HistoriqueItem {
  final String date; // ex: "Aujourd'hui · 10 h 42" ou "28 sept. 2026"
  final String titre; // ex: "Médicament essentiel"
  final String prestataire; // ex: "Pharmacie partenaire · Pikine"
  final String montantBH; // ex: "1 000 BH"
  final String montantPaye; // ex: "800 FCFA"
  final String statutLabel; // ex: "En cours", "Pris en charge"
  final StatusType statutType;

  const HistoriqueItem({
    required this.date,
    required this.titre,
    required this.prestataire,
    required this.montantBH,
    required this.montantPaye,
    required this.statutLabel,
    required this.statutType,
  });
}