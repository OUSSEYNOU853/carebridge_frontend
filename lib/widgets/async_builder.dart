import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/beneficiaire_repository.dart';

/// Widget générique qui gère les 3 états possibles d'un appel API :
/// chargement, erreur (avec bouton "Réessayer"), ou données prêtes.
///
/// <T> est un "type générique" : ce widget fonctionne avec N'IMPORTE QUEL
/// type de données (BudgetData, List<HistoriqueItem>, etc.) sans avoir à
/// dupliquer ce code pour chaque écran.
///
/// On lui donne une FONCTION qui produit le Future (futureFactory) plutôt
/// qu'un Future déjà créé, pour pouvoir relancer un nouvel appel au clic
/// sur "Réessayer" (un Future ne peut être exécuté qu'une seule fois,
/// il faut donc en recréer un nouveau à chaque tentative).
class AsyncBuilder<T> extends StatefulWidget {
  final Future<T> Function() futureFactory;
  final Widget Function(BuildContext context, T data) builder;

  const AsyncBuilder({
    super.key,
    required this.futureFactory,
    required this.builder,
  });

  @override
  State<AsyncBuilder<T>> createState() => _AsyncBuilderState<T>();
}

class _AsyncBuilderState<T> extends State<AsyncBuilder<T>> {
  late Future<T> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.futureFactory();
  }

  void _retry() {
    setState(() {
      _future = widget.futureFactory(); // on relance un nouvel appel
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        // Cas 1 : toujours en train de charger
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            ),
          );
        }

        // Cas 2 : une erreur s'est produite
        if (snapshot.hasError) {
          final message = snapshot.error is ApiException
              ? (snapshot.error as ApiException).message
              : 'Une erreur est survenue. Vérifiez votre connexion.';

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  Text(message, textAlign: TextAlign.center, style: AppTextStyles.body),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retry,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                    child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        }

        // Cas 3 : les données sont prêtes
        return widget.builder(context, snapshot.data as T);
      },
    );
  }
}