import 'package:family_tree_app/core/constants/theme/theme.dart';
import 'package:family_tree_app/core/services/auth_wrapper.dart';
import 'package:family_tree_app/core/widgets/dashboard_screen.dart';
import 'package:family_tree_app/core/widgets/family_members_list_screen.dart';
import 'package:family_tree_app/features/registeration/family_member_registeration.dart';
import 'package:family_tree_app/features/registeration/head_registeration.dart';
import 'package:family_tree_app/providers/registeration_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/firebase_service.dart';
import 'features/family_tree/family_tree_screen.dart';
import 'features/temples/temple_association.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseService.initialize();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
      ],
      child: MaterialApp(
        title: 'Wallet Hunter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
          '/headRegistration': (context) => const HeadRegistrationForm(),
          '/familyMemberRegistration': (context) =>
              const FamilyMemberRegistration(),
          '/familyTree': (context) => const FamilyTreeScreen(),
          '/familyMembersList': (context) => const FamilyMembersListScreen(),
          '/temples': (context) => const TempleAssociation(),
        },
      ),
    );
  }
}
