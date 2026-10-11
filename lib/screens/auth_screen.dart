import 'package:flutter/material.dart';
import '../state.dart';
import '../theme.dart';

class AuthScreen extends StatefulWidget {
  final AppState state;
  const AuthScreen({super.key, required this.state});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool signup = true;
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  String? error;
  bool busy = false;

  Future<void> submit() async {
    setState(() {
      busy = true;
      error = null;
    });
    final err = signup
        ? await widget.state.signUp(nameC.text, emailC.text, passC.text)
        : await widget.state.logIn(emailC.text, passC.text);
    if (mounted) setState(() {
      busy = false;
      error = err;
    });
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [C.bleu, C.vert]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 38),
            ),
            const SizedBox(height: 24),
            Text(appName,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Vos exercices de rééducation, à la maison.',
                style: TextStyle(fontSize: 18, color: C.gris)),
            const SizedBox(height: 32),
            Text(signup ? 'Créer un compte' : 'Se connecter',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            if (signup) ...[
              TextField(
                controller: nameC,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Prénom'),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Adresse e-mail'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passC,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Color(0xFFB3261E), fontSize: 16)),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: busy ? null : submit,
              child: Text(signup ? 'Créer mon compte' : 'Me connecter'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: busy ? null : widget.state.googleDemo,
              icon: const Icon(Icons.g_mobiledata_rounded, size: 32),
              label: const Text('Continuer avec Google (démo)'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() {
                signup = !signup;
                error = null;
              }),
              child: Text(
                signup ? 'J\'ai déjà un compte' : 'Je n\'ai pas de compte',
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Version de démonstration : le compte reste sur ce téléphone et le bouton Google est simulé.',
              style: TextStyle(color: C.gris, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
