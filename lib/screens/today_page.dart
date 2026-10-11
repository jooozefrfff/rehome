import 'package:flutter/material.dart';
import '../state.dart';
import '../theme.dart';

class TodayPage extends StatelessWidget {
  final AppState state;
  const TodayPage({super.key, required this.state});

  Future<void> _finish(BuildContext context) async {
    final s = await state.finishFakeSession();
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Bravo, séance terminée'),
        content: Text(
            'Score : ${s.score} points\nRépétitions : ${s.reps}\n\n(Score fictif pour la démonstration.)',
            style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final done = state.todaySession;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        Text(
          state.firstName.isEmpty ? 'Bonjour' : 'Bonjour ${state.firstName}',
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(frLongDate(DateTime.now()), style: const TextStyle(fontSize: 17, color: C.gris)),
        const SizedBox(height: 16),
        _Streak(streak: state.streak),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: C.brume, width: 1.6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: C.brume, borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.accessibility_new_rounded, color: C.bleu, size: 30),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Flexion du coude',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                        Text('10 répétitions, côté atteint',
                            style: TextStyle(fontSize: 16, color: C.gris)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _Step(1, 'Asseyez-vous sur une chaise, le dos droit.'),
              const _Step(2, 'Posez le téléphone en face de vous, de façon à ce que votre buste et vos bras soient visibles.'),
              const _Step(3, 'Pliez le coude du côté atteint, puis revenez lentement.'),
              const _Step(4, 'Faites 10 répétitions, sans forcer.'),
              const SizedBox(height: 4),
              const Text(
                'Exercice d\'exemple : à faire valider par le kiné ou le médecin.',
                style: TextStyle(fontSize: 14, color: C.gris),
              ),
              const SizedBox(height: 18),
              if (done != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: C.vert.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Séance faite aujourd\'hui : ${done.score} points, ${done.reps} répétitions.',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              if (done != null) const SizedBox(height: 12),
              FilledButton(
                onPressed: () => _finish(context),
                child: Text(done == null ? 'Terminer la séance (score simulé)' : 'Refaire une séance (score simulé)'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Glissez vers la gauche pour voir votre historique.',
          textAlign: TextAlign.center,
          style: TextStyle(color: C.gris, fontSize: 15),
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final int n;
  final String text;
  const _Step(this.n, this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: C.bleu, shape: BoxShape.circle),
              child: Text('$n', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 17, height: 1.35))),
          ],
        ),
      );
}

class _Streak extends StatelessWidget {
  final int streak;
  const _Streak({required this.streak});
  @override
  Widget build(BuildContext context) {
    final txt = streak == 0
        ? 'Faites votre première séance pour démarrer une série.'
        : streak == 1
            ? '1 jour d\'affilée. Continuez demain !'
            : '$streak jours d\'affilée. Continuez comme ça !';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE6F4EE), Color(0xFFE3EEF8)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded, color: C.vert, size: 28),
          const SizedBox(width: 10),
          Expanded(child: Text(txt, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
