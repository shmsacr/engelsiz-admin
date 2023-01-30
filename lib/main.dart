import 'package:engelsiz_admin/controller/auth_controller.dart';
import 'package:engelsiz_admin/firebase_options.dart';
import 'package:engelsiz_admin/ui/screens/dashboard/dashboard_screen.dart';
import 'package:engelsiz_admin/ui/screens/login/login_screen.dart';
import 'package:engelsiz_admin/ui/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      locale: const Locale('tr', "TR"),
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: ref.watch(userProvider) != null
          ? const DashboardScreen()
          : const LoginScreen(),
    );
  }
}