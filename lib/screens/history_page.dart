import 'package:flutter/material.dart';
import '../state.dart';
import '../theme.dart';

class HistoryPage extends StatelessWidget {
  final AppState state;
  const HistoryPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final list = state.sessions.reversed.toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        const Text('Mes badges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        SizedBox(
          height: 118,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [for (final b in state.badges) _BadgeTile(b: b)],
          ),
        ),
        const SizedBox(height: 22),
        Text('Mes séances (${list.length})',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Aucune séance pour l\'instant. Revenez à l\'écran Aujourd\'hui pour commencer.',
              style: TextStyle(fontSize: 17, color: C.gris),
            ),
          ),
        for (final s in list)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: C.brume, width: 1.4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(frShortDate(s.date),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      Text('${s.reps} répétitions · Flexion du coude',
                          style: const TextStyle(color: C.gris, fontSize: 15)),
                    ],
                  ),
                ),
                Text('${s.score}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: C.bleu)),
                const SizedBox(width: 4),
                const Text('pts', style: TextStyle(color: C.gris)),
              ],
            ),
          ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final Medal b;
  const _BadgeTile({required this.b});
  @override
  Widget build(BuildContext context) {
    final on = b.unlocked;
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: on ? C.vert.withOpacity(0.14) : C.brume.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(on ? Icons.emoji_events_rounded : Icons.lock_outline_rounded,
              color: on ? C.vert : C.gris, size: 26),
          const Spacer(),
          Text(b.title,
              maxLines: 2,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: on ? C.encre : C.gris)),
        ],
      ),
    );
  }
}
