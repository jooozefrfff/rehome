import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _mois = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
];
const _jours = [
  'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'
];

String frLongDate(DateTime d) =>
    '${_jours[d.weekday - 1]} ${d.day} ${_mois[d.month - 1]}';
String frShortDate(DateTime d) => '${d.day} ${_mois[d.month - 1]}';
String two(int n) => n.toString().padLeft(2, '0');

class Session {
  final DateTime date;
  final int score; // score fictif pour l'instant
  final int reps;
  Session(this.date, this.score, this.reps);
  Map<String, dynamic> toJson() =>
      {'d': date.toIso8601String(), 's': score, 'r': reps};
  factory Session.fromJson(Map<String, dynamic> j) =>
      Session(DateTime.parse(j['d']), j['s'], j['r']);
}

class ChatMessage {
  final String text;
  final bool fromMe;
  final DateTime time;
  ChatMessage(this.text, this.fromMe, this.time);
  Map<String, dynamic> toJson() =>
      {'t': text, 'm': fromMe, 'd': time.toIso8601String()};
  factory ChatMessage.fromJson(Map<String, dynamic> j) =>
      ChatMessage(j['t'], j['m'], DateTime.parse(j['d']));
}

class Medal {
  final String title;
  final String description;
  final bool unlocked;
  const Medal(this.title, this.description, this.unlocked);
}

/// État de l'app. Connexion et données sont FICTIVES et locales (sur le
/// téléphone) : à remplacer par un vrai backend plus tard.
class AppState extends ChangeNotifier {
  late SharedPreferences _p;

  String? name;
  String? email;
  bool isLoggedIn = false;
  List<Session> sessions = [];
  List<ChatMessage> messages = [];
  bool reminderOn = false;
  TimeOfDay reminderTime = const TimeOfDay(hour: 9, minute: 0);

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    name = _p.getString('acc_name');
    email = _p.getString('acc_email');
    isLoggedIn = _p.getBool('logged_in') ?? false;
    sessions = (jsonDecode(_p.getString('sessions') ?? '[]') as List)
        .map((e) => Session.fromJson(e))
        .toList();
    messages = (jsonDecode(_p.getString('messages') ?? '[]') as List)
        .map((e) => ChatMessage.fromJson(e))
        .toList();
    reminderOn = _p.getBool('reminder_on') ?? false;
    reminderTime = TimeOfDay(
        hour: _p.getInt('reminder_h') ?? 9, minute: _p.getInt('reminder_m') ?? 0);
  }

  Future<void> _save() async {
    await _p.setString(
        'sessions', jsonEncode(sessions.map((s) => s.toJson()).toList()));
    await _p.setString(
        'messages', jsonEncode(messages.map((m) => m.toJson()).toList()));
    await _p.setBool('reminder_on', reminderOn);
    await _p.setInt('reminder_h', reminderTime.hour);
    await _p.setInt('reminder_m', reminderTime.minute);
  }

  // ---------- Compte (fictif) ----------
  String get firstName {
    final n = (name ?? '').trim();
    return n.isEmpty ? '' : n.split(' ').first;
  }

  /// Retourne un message d'erreur, ou null si tout va bien.
  Future<String?> signUp(String n, String e, String pass) async {
    if (n.trim().isEmpty) return 'Entrez votre prénom.';
    if (!e.contains('@')) return 'Entrez une adresse e-mail valide.';
    if (pass.length < 6) return 'Le mot de passe doit avoir au moins 6 caractères.';
    name = n.trim();
    email = e.trim().toLowerCase();
    await _p.setString('acc_name', name!);
    await _p.setString('acc_email', email!);
    await _p.setString('acc_pass', pass); // fictif : ne jamais faire ça en vrai
    await _p.setBool('logged_in', true);
    isLoggedIn = true;
    notifyListeners();
    return null;
  }

  Future<String?> logIn(String e, String pass) async {
    final savedEmail = _p.getString('acc_email');
    if (savedEmail == null) return 'Aucun compte trouvé. Créez un compte d\'abord.';
    if (e.trim().toLowerCase() != savedEmail ||
        pass != _p.getString('acc_pass')) {
      return 'E-mail ou mot de passe incorrect.';
    }
    await _p.setBool('logged_in', true);
    isLoggedIn = true;
    notifyListeners();
    return null;
  }

  /// Simulation du bouton Google (pas de vrai Google Sign-In pour l'instant).
  Future<void> googleDemo() async {
    name = 'Patient démo';
    email = 'patient.demo@gmail.com';
    await _p.setString('acc_name', name!);
    await _p.setString('acc_email', email!);
    await _p.setBool('logged_in', true);
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logOut() async {
    await _p.setBool('logged_in', false);
    isLoggedIn = false;
    notifyListeners();
  }

  // ---------- Séances ----------
  DateTime _day(DateTime t) => DateTime(t.year, t.month, t.day);

  Session? get todaySession {
    final today = _day(DateTime.now());
    for (final s in sessions.reversed) {
      if (_day(s.date) == today) return s;
    }
    return null;
  }

  bool get doneToday => todaySession != null;

  int get streak {
    final days = sessions.map((s) => _day(s.date)).toSet();
    var d = _day(DateTime.now());
    if (!days.contains(d)) d = DateTime(d.year, d.month, d.day - 1);
    var n = 0;
    while (days.contains(d)) {
      n++;
      d = DateTime(d.year, d.month, d.day - 1);
    }
    return n;
  }

  int get bestScore =>
      sessions.isEmpty ? 0 : sessions.map((s) => s.score).reduce((a, b) => a > b ? a : b);

  List<Medal> get badges => [
        Medal('Première séance', 'Terminer une séance', sessions.isNotEmpty),
        Medal('3 jours d\'affilée', 'Faire l\'exercice 3 jours de suite', streak >= 3),
        Medal('7 jours d\'affilée', 'Faire l\'exercice 7 jours de suite', streak >= 7),
        Medal('Score de 90', 'Atteindre 90 points ou plus', bestScore >= 90),
      ];

  /// Séance FICTIVE : score et répétitions aléatoires, en attendant la caméra.
  Future<Session> finishFakeSession() async {
    final r = DateTime.now().millisecondsSinceEpoch;
    final s = Session(DateTime.now(), 60 + (r % 41), 6 + (r % 5));
    sessions.add(s);
    await _save();
    notifyListeners();
    return s;
  }

  // ---------- Chat avec le médecin (réponses simulées) ----------
  Future<void> sendMessage(String text) async {
    messages.add(ChatMessage(text.trim(), true, DateTime.now()));
    await _save();
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    messages.add(ChatMessage(
        'Message reçu. Votre médecin vous répondra dès que possible. (Réponse automatique de démonstration.)',
        false,
        DateTime.now()));
    await _save();
    notifyListeners();
  }

  // ---------- Rappel (réglage seulement, notification pas encore branchée) ----------
  Future<void> setReminder(bool on, TimeOfDay t) async {
    reminderOn = on;
    reminderTime = t;
    await _save();
    notifyListeners();
  }
}
