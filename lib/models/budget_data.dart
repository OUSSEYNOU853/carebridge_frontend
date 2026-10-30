/// Décrit l'état du budget BioHealth d'un bénéficiaire.
/// Toutes ces valeurs viendront de l'API plus tard (GET /beneficiaire/budget par ex.).
class BudgetData {
  final String nomBeneficiaire;
  final int utilise; // en BH
  final int enCours; // en BH
  final int disponible; // en BH
  final int attribue; // en BH (total : utilisé + en cours + disponible)
  final String parcoursNom; // ex: "suivi hypertension"
  final String validiteDate; // ex: "29 nov. 2026"
  final String identifiant; // ex: "CB-4F7K-21"

  const BudgetData({
    required this.nomBeneficiaire,
    required this.utilise,
    required this.enCours,
    required this.disponible,
    required this.attribue,
    required this.parcoursNom,
    required this.validiteDate,
    required this.identifiant,
  });

  // L'équivalence BH -> FCFA est actuellement 1:1 selon la maquette M3
  // (marquée "à confirmer par la Compliance & Legal Officer" dans le doc MVP).
  // On isole ce calcul ici pour ne le changer qu'à un seul endroit le jour
  // où cette convention change.
  int get disponibleEnFCFA => disponible;
}

/// Décrit une prise en charge actuellement en cours (carte orange sur B1).
/// Null si aucune prise en charge n'est en cours.
class PriseEnChargeEnCours {
  final String prestataireNom; // ex: "Pharmacie partenaire · Pikine"
  final int montantCouvertBH;
  final int resteAPayerFCFA;

  const PriseEnChargeEnCours({
    required this.prestataireNom,
    required this.montantCouvertBH,
    required this.resteAPayerFCFA,
  });
}