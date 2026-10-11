import 'package:flutter/material.dart';
import '../state.dart';
import '../theme.dart';
import 'chat_page.dart';
import 'history_page.dart';
import 'today_page.dart';

/// Écran principal : on glisse (swipe) entre Aujourd'hui, Historique et Médecin.
class Shell extends StatefulWidget {
  final AppState state;
  const Shell({super.key, required this.state});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  final _ctrl = PageController();
  int _i = 0;
  static const _titles = ['Aujourd\'hui', 'Historique', 'Mon médecin'];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) => _Settings(state: widget.state),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_i]),
        actions: [
          IconButton(
            tooltip: 'Réglages',
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: PageView(
        controller: _ctrl,
        onPageChanged: (i) => setState(() => _i = i),
        children: [
          ListenableBuilder(listenable: s, builder: (_, __) => TodayPage(state: s)),
          ListenableBuilder(listenable: s, builder: (_, __) => HistoryPage(state: s)),
          ListenableBuilder(listenable: s, builder: (_, __) => ChatPage(state: s)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _i,
        onDestinationSelected: (i) => _ctrl.animateToPage(i,
            duration: const Duration(milliseconds: 280), curve: Curves.easeOut),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today), label: 'Aujourd\'hui'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Historique'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Médecin'),
        ],
      ),
    );
  }
}

class _Settings extends StatefulWidget {
  final AppState state;
  const _Settings({required this.state});
  @override
  State<_Settings> createState() => _SettingsState();
}

class _SettingsState extends State<_Settings> {
  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final t = s.reminderTime;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.name ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            Text(s.email ?? '', style: const TextStyle(color: C.gris, fontSize: 16)),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Rappel quotidien', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Pour penser à faire l\'exercice du jour'),
              value: s.reminderOn,
              onChanged: (v) async {
                await s.setReminder(v, t);
                setState(() {});
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              enabled: s.reminderOn,
              title: const Text('Heure du rappel', style: TextStyle(fontSize: 18)),
              trailing: Text('${two(t.hour)}:${two(t.minute)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: t);
                if (picked != null) {
                  await s.setReminder(s.reminderOn, picked);
                  setState(() {});
                }
              },
            ),
            const Text(
              'Le rappel est enregistré, mais la notification n\'est pas encore branchée dans cette version.',
              style: TextStyle(color: C.gris, fontSize: 14),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                s.logOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
