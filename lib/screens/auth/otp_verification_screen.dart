import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../services/beneficiaire_repository.dart';
import '../home_shell.dart';

/// Deuxième écran du flux de connexion : le bénéficiaire tape le code à
/// 6 chiffres reçu par SMS pour confirmer que ce numéro lui appartient.
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // 6 contrôleurs, un par case de chiffre, + 6 FocusNode pour gérer
  // automatiquement le passage d'une case à la suivante en tapant.
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String? _errorText;
  bool _isVerifying = false;

  // Minuteur pour le renvoi du code (30 secondes avant de pouvoir le redemander)
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();
    // Timer.periodic exécute une action toutes les X secondes, en boucle.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Appelé à chaque fois qu'un chiffre est tapé dans une case.
  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      // Un chiffre vient d'être tapé : on passe le focus à la case suivante
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      // Effacement (backspace) : on revient à la case précédente
      _focusNodes[index - 1].requestFocus();
    }

    // Si les 6 cases sont remplies, on vérifie automatiquement
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 6) {
      _verifyCode(code);
    }
  }

  Future<void> _verifyCode(String code) async {
    setState(() {
      _errorText = null;
      _isVerifying = true;
    });

    try {
      // Passe maintenant par le repository. Le code de test "123456" est
      // défini dans FakeBeneficiaireRepository, à remplacer par le vrai
      // backend plus tard - cet écran n'aura rien à changer.
      final isValid = await beneficiaireRepository.verifyOtp(widget.phoneNumber, code);
      if (!mounted) return;

      if (isValid) {
        // pushReplacement remplace l'écran actuel au lieu de l'empiler :
        // une fois connecté, on ne veut pas que l'utilisateur puisse
        // "revenir en arrière" jusqu'à l'écran de connexion avec le bouton retour.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeShell()),
        );
      } else {
        setState(() {
          _isVerifying = false;
          _errorText = 'Code incorrect, réessayez';
        });
        for (final controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
        _errorText = e.message;
      });
    }
  }

  void _resendCode() {
    if (_secondsRemaining > 0) return;
    _startResendTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code renvoyé par SMS'), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Vérification', style: AppTextStyles.screenTitle),
              const SizedBox(height: 8),
              Text(
                'Entrez le code à 6 chiffres envoyé au +221 ${widget.phoneNumber}',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 32),

              // Les 6 cases de saisie, générées avec une boucle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _OtpBox(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      hasError: _errorText != null,
                      onChanged: (value) => _onDigitChanged(index, value),
                    )),
              ),

              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(_errorText!, style: const TextStyle(color: AppColors.errorRed)),
              ],

              if (_isVerifying) ...[
                const SizedBox(height: 20),
                const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
              ],

              const SizedBox(height: 32),

              Center(
                child: TextButton(
                  onPressed: _secondsRemaining == 0 ? _resendCode : null,
                  child: Text(
                    _secondsRemaining > 0
                        ? 'Renvoyer le code (${_secondsRemaining}s)'
                        : 'Renvoyer le code',
                    style: TextStyle(
                      color: _secondsRemaining == 0
                          ? AppColors.primaryGreen
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Une seule case de saisie de chiffre (réutilisée 6 fois via List.generate)
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '', // cache le petit compteur "0/1" sous le champ
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? AppColors.errorRed : Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? AppColors.errorRed : Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}