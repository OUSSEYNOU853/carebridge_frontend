/// Les 3 états possibles d'une étape dans la timeline (ÉTAPES sur B2).
enum EtapeEtat { fait, enCours, aVenir }

/// Une étape de la timeline (ex: "Prise en charge vérifiée")
class TimelineStep {
  final String titre;
  final String description;
  final EtapeEtat etat;

  const TimelineStep({
    required this.titre,
    required this.description,
    required this.etat,
  });
}

/// Toutes les infos détaillées d'une prise en charge en cours (écran B2).
class PriseEnChargeDetail {
  final String statutLabel; // ex: "Autorisée en partie"
  final String prestataireNom; // ex: "Pharmacie partenaire · Pikine"
  final String categorie; // ex: "Médicament essentiel"
  final String dateHeure; // ex: "aujourd'hui à 10 h 42"
  final int coutTraitementFCFA;
  final int couvertBH;
  final int resteAPayerFCFA;
  final String explication; // le texte "Pourquoi ?"
  final List<TimelineStep> etapes;

  const PriseEnChargeDetail({
    required this.statutLabel,
    required this.prestataireNom,
    required this.categorie,
    required this.dateHeure,
    required this.coutTraitementFCFA,
    required this.couvertBH,
    required this.resteAPayerFCFA,
    required this.explication,
    required this.etapes,
  });
}