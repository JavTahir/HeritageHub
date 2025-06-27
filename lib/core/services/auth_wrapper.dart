import 'package:family_tree_app/core/services/firebase_service.dart';
import 'package:family_tree_app/core/widgets/dashboard_screen.dart';
import 'package:family_tree_app/features/auth/otp_screen.dart';
import 'package:family_tree_app/features/registeration/head_registeration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:family_tree_app/providers/registeration_provider.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseService.auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) return const OTPScreen();

        return FutureBuilder<AuthResolution>(
          future: _resolveUserType(context),
          builder: (context, typeSnapshot) {
            if (!typeSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final resolution = typeSnapshot.data!;
            return resolution.isHead
                ? const DashboardScreen()
                : resolution.existsAsMember
                    ? const DashboardScreen()
                    : const HeadRegistrationForm();
          },
        );
      },
    );
  }

  Future<AuthResolution> _resolveUserType(BuildContext context) async {
    final provider = Provider.of<RegistrationProvider>(context, listen: false);

    // Check if user is head
    final isHead = await provider.loadFamilyData();
    if (isHead) return AuthResolution(isHead: true, existsAsMember: true);

    final memberQuery = await FirebaseService.firestore
        .collection('familyMembers')
        .where('phoneNumber',
            isEqualTo: FirebaseService.auth.currentUser?.phoneNumber)
        .limit(1)
        .get();

    return AuthResolution(
      isHead: false,
      existsAsMember: memberQuery.docs.isNotEmpty,
    );
  }
}

class AuthResolution {
  final bool isHead;
  final bool existsAsMember;

  AuthResolution({required this.isHead, required this.existsAsMember});
}
