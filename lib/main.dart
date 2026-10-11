import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/shell.dart';
import 'state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  runApp(RehomeApp(state: state));
}

class RehomeApp extends StatelessWidget {
  final AppState state;
  const RehomeApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: state.isLoggedIn
            ? Shell(state: state)
            : AuthScreen(state: state),
      ),
    );
  }
}
