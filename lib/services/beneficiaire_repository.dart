import '../models/budget_data.dart';
import '../models/prestation_couverte.dart';
import '../models/historique_item.dart';
import '../models/prise_en_charge_detail.dart';
import '../widgets/status_badge.dart';

/// Erreur levée quand un appel API échoue (réseau, serveur, etc.).
/// On distingue ce type d'erreur des autres bugs pour pouvoir afficher
/// un message clair à l'utilisateur ("Vérifiez votre connexion", etc.)
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Le "contrat" : toutes les données dont l'app bénéficiaire a besoin,
/// sans dire COMMENT elles sont obtenues. Les écrans dépendent uniquement
/// de cette interface abstraite, jamais de l'implémentation concrète -
/// ça permettra de brancher le vrai backend Spring Boot plus tard sans
/// toucher au code des écrans.
abstract class BeneficiaireRepository {
  Future<void> sendOtp(String phoneNumber);
  Future<bool> verifyOtp(String phoneNumber, String code);

  Future<({BudgetData budget, PriseEnChargeEnCours? priseEnCours})> getBudgetScreenData();
  Future<({List<PrestationCouverte> prestations, List<PrestatairePartenaire> prestataires})> getParcoursData();
  Future<List<HistoriqueItem>> getHistorique();
  Future<PriseEnChargeDetail> getPriseEnChargeDetail();
}

/// Implémentation SIMULÉE : renvoie des données fictives après un petit délai
/// (pour imiter une vraie latence réseau). À remplacer par une implémentation
/// qui appelle réellement l'API Spring Boot (ex: HttpBeneficiaireRepository)
/// une fois le backend prêt - le reste de l'app n'aura rien à changer.
class FakeBeneficiaireRepository implements BeneficiaireRepository {
  @override
  Future<void> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: appel réel POST /auth/otp/send { phoneNumber }
  }

  @override
  Future<bool> verifyOtp(String phoneNumber, String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: appel réel POST /auth/otp/verify { phoneNumber, code }
    // Code de test en attendant le vrai backend :
    return code == '123456';
  }

  @override
  Future<({BudgetData budget, PriseEnChargeEnCours? priseEnCours})> getBudgetScreenData() async {
    await Future.delayed(const Duration(milliseconds: 700));
    // TODO: appel réel GET /beneficiaire/budget

    const budget = BudgetData(
      nomBeneficiaire: 'Aminata Sow',
      utilise: 4000,
      enCours: 1000,
      disponible: 5000,
      attribue: 10000,
      parcoursNom: 'suivi hypertension',
      validiteDate: '29 nov. 2026',
      identifiant: 'CB-4F7K-21',
    );

    const priseEnCours = PriseEnChargeEnCours(
      prestataireNom: 'Pharmacie partenaire · Pikine',
      montantCouvertBH: 1000,
      resteAPayerFCFA: 800,
    );

    return (budget: budget, priseEnCours: priseEnCours);
  }

  @override
  Future<({List<PrestationCouverte> prestations, List<PrestatairePartenaire> prestataires})> getParcoursData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: appel réel GET /beneficiaire/parcours

    const prestations = [
      PrestationCouverte(
        nom: 'Consultation de suivi',
        detail: "Jusqu'à 1 500 BH · 2 par période",
        compteur: '0 restante',
        epuise: true,
      ),
      PrestationCouverte(
        nom: 'Examen prescrit',
        detail: "Jusqu'à 1 500 BH · sur prescription",
        compteur: '2 restants',
      ),
      PrestationCouverte(
        nom: 'Médicament essentiel',
        detail: "Jusqu'à 1 000 BH · sur ordonnance",
        compteur: '1 restant',
      ),
    ];

    const prestataires = [
      PrestatairePartenaire(
        nom: 'Centre de santé partenaire',
        type: 'Consultations et examens',
        localisation: 'Guédiawaye',
      ),
      PrestatairePartenaire(
        nom: 'Pharmacie partenaire 1',
        type: 'Médicaments sur ordonnance',
        localisation: 'Pikine',
      ),
      PrestatairePartenaire(
        nom: 'Pharmacie partenaire 2',
        type: 'Médicaments sur ordonnance',
        localisation: 'Parcelles',
      ),
      PrestatairePartenaire(
        nom: 'Pharmacie partenaire 3',
        type: 'Médicaments sur ordonnance',
        localisation: 'Grand Yoff',
      ),
    ];

    return (prestations: prestations, prestataires: prestataires);
  }

  @override
  Future<List<HistoriqueItem>> getHistorique() async {
    await Future.delayed(const Duration(milliseconds: 650));
    // TODO: appel réel GET /beneficiaire/historique

    return const [
      HistoriqueItem(
        date: "Aujourd'hui · 10 h 42",
        titre: 'Médicament essentiel',
        prestataire: 'Pharmacie partenaire · Pikine',
        montantBH: '1 000 BH',
        montantPaye: '800 FCFA',
        statutLabel: 'En cours',
        statutType: StatusType.warning,
      ),
      HistoriqueItem(
        date: '28 sept. 2026',
        titre: 'Consultation de suivi',
        prestataire: 'Centre de santé partenaire · Guédiawaye',
        montantBH: '1 500 BH',
        montantPaye: '0 FCFA',
        statutLabel: 'Pris en charge',
        statutType: StatusType.success,
      ),
      HistoriqueItem(
        date: '3 sept. 2026',
        titre: 'Médicament essentiel',
        prestataire: 'Pharmacie partenaire · Pikine',
        montantBH: '1 000 BH',
        montantPaye: '600 FCFA',
        statutLabel: 'Pris en charge',
        statutType: StatusType.success,
      ),
      HistoriqueItem(
        date: '2 sept. 2026',
        titre: 'Consultation de suivi',
        prestataire: 'Centre de santé partenaire · Guédiawaye',
        montantBH: '1 500 BH',
        montantPaye: '0 FCFA',
        statutLabel: 'Pris en charge',
        statutType: StatusType.success,
      ),
    ];
  }

  @override
  Future<PriseEnChargeDetail> getPriseEnChargeDetail() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: appel réel GET /beneficiaire/prise-en-charge/{id}

    return const PriseEnChargeDetail(
      statutLabel: 'Autorisée en partie',
      prestataireNom: 'Pharmacie partenaire · Pikine',
      categorie: 'Médicament essentiel',
      dateHeure: "aujourd'hui à 10 h 42",
      coutTraitementFCFA: 1800,
      couvertBH: 1000,
      resteAPayerFCFA: 800,
      explication: "Votre budget couvre jusqu'à 1 000 BH par délivrance de "
          'médicament. Vous réglez seulement la différence, directement à la '
          'pharmacie.',
      etapes: [
        TimelineStep(
          titre: 'Prise en charge vérifiée',
          description: '1 000 BH mis de côté pour ce traitement',
          etat: EtapeEtat.fait,
        ),
        TimelineStep(
          titre: 'La pharmacie vous remet le traitement',
          description: 'Elle confirme la délivrance devant vous',
          etat: EtapeEtat.enCours,
        ),
        TimelineStep(
          titre: 'Votre budget est mis à jour',
          description: 'Vous recevez un SMS de confirmation',
          etat: EtapeEtat.aVenir,
        ),
      ],
    );
  }
}

/// Instance unique partagée par toute l'app (pattern "singleton" simple).
/// Les écrans importent cette variable plutôt que de créer leur propre
/// instance - ça garantit que tout le monde parle au même repository.
/// Le jour où on branche le vrai backend, on changera UNIQUEMENT cette ligne :
/// FakeBeneficiaireRepository() -> HttpBeneficiaireRepository()
final BeneficiaireRepository beneficiaireRepository = FakeBeneficiaireRepository();