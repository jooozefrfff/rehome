import 'package:flutter/material.dart';
import '../state.dart';
import '../theme.dart';

class ChatPage extends StatefulWidget {
  final AppState state;
  const ChatPage({super.key, required this.state});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _send() {
    final t = _c.text.trim();
    if (t.isEmpty) return;
    _c.clear();
    widget.state.sendMessage(t);
  }

  @override
  Widget build(BuildContext context) {
    final msgs = widget.state.messages;
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: C.brume, borderRadius: BorderRadius.circular(14)),
          child: const Text(
            'Ce chat n\'est pas fait pour les urgences. En cas de problème grave, contactez les secours.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          child: msgs.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Écrivez votre première question à votre médecin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17, color: C.gris)),
                  ),
                )
              : ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: msgs.length,
                  itemBuilder: (_, i) {
                    final m = msgs[msgs.length - 1 - i];
                    return Align(
                      alignment: m.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: m.fromMe ? C.bleu : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: m.fromMe ? null : Border.all(color: C.brume, width: 1.4),
                        ),
                        child: Text(m.text,
                            style: TextStyle(fontSize: 17, color: m.fromMe ? Colors.white : C.encre)),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _c,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: const InputDecoration(hintText: 'Votre message'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _send,
                icon: const Icon(Icons.send_rounded),
                style: IconButton.styleFrom(minimumSize: const Size(54, 54)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
