import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../services/beneficiaire_repository.dart';
import 'otp_verification_screen.dart';


class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  
  final TextEditingController _phoneController = TextEditingController();
  String? _errorText; // message d'erreur affiché sous le champ, null = pas d'erreur
  bool _isLoading = false; // pour afficher un indicateur pendant "l'envoi" du code

  @override
  void dispose() {
    // dispose() nettoie les ressources quand l'écran est détruit.
    // Toujours libérer un TextEditingController pour éviter les fuites mémoire.
    _phoneController.dispose();
    super.dispose();
  }

 
  bool _isValidSenegalPhone(String phone) {
    final cleaned = phone.replaceAll(' ', '');
    final regex = RegExp(r'^7[0-8][0-9]{7}$');
    return regex.hasMatch(cleaned);
  }

  Future<void> _onSubmit() async {
    final phone = _phoneController.text.trim();

    if (!_isValidSenegalPhone(phone)) {
      setState(() {
        _errorText = 'Entrez un numéro sénégalais valide (9 chiffres)';
      });
      return;
    }

    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    try {
      
      await beneficiaireRepository.sendOtp(phone);

      if (!mounted) return; // sécurité : vérifie que l'écran existe encore
      setState(() => _isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(phoneNumber: phone),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorText = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Petit logo/titre CareBridge en haut
              Text(
                'CareBridge',
                style: AppTextStyles.screenTitle.copyWith(
                  fontSize: 28,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Entrez votre numéro de téléphone pour accéder à votre budget BioHealth.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 32),

              const Text('Numéro de téléphone', style: AppTextStyles.bodyBold),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                // N'autorise que les chiffres à la saisie, max 9 caractères
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: '77 123 45 67',
                  prefixText: '+221  ',
                  errorText: _errorText,
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                onSubmitted: (_) => _onSubmit(),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Affiche un petit indicateur de chargement pendant l'envoi,
                  // sinon le texte normal du bouton.
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Recevoir le code',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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