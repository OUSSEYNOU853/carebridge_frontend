/// Décrit une catégorie de soin couverte par le parcours (ex: "Consultation de suivi").
/// Plus tard, ces objets viendront de l'API backend au lieu d'être écrits en dur.
class PrestationCouverte {
  final String nom; // ex: "Consultation de suivi"
  final String detail; // ex: "Jusqu'à 1 500 BH · 2 par période"
  final String compteur; // ex: "0 restante", "2 restants"
  final bool epuise; // true si le compteur est à 0 (pour griser le badge)

  const PrestationCouverte({
    required this.nom,
    required this.detail,
    required this.compteur,
    this.epuise = false,
  });
}

/// Décrit un prestataire partenaire (centre ou pharmacie) où utiliser le budget.
class PrestatairePartenaire {
  final String nom; // ex: "Pharmacie partenaire 1"
  final String type; // ex: "Médicaments sur ordonnance"
  final String localisation; // ex: "Pikine"

  const PrestatairePartenaire({
    required this.nom,
    required this.type,
    required this.localisation,
  });
}