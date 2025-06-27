// family_tree_screen.dart
import 'package:family_tree_app/core/utils/pdf_export.dart';
import 'package:family_tree_app/core/widgets/buttons/moddashborad_button.dart';
import 'package:family_tree_app/features/family_tree/custom_family_tree.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:family_tree_app/providers/registeration_provider.dart';
import 'package:family_tree_app/core/constants/theme/theme.dart';

class FamilyTreeScreen extends StatelessWidget {
  const FamilyTreeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final head = provider.headData;
    final members = provider.familyMembers;

    if (head == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Family Tree'),
          backgroundColor: AppTheme.white,
          foregroundColor: AppTheme.black,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No family data available', style: AppTheme.bodyMedium),
              const SizedBox(height: 20),
              ModernDashboardButton(
                icon: Icons.person_add,
                label: 'Register as Head',
                gradient: AppTheme.primaryGradient,
                onTap: () => Navigator.pushNamed(context, '/headRegistration'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.cardBackground,
      appBar: AppBar(
        title: Text(
          'Family Tree',
          style: AppTheme.headingMedium.copyWith(color: AppTheme.black),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => exportFamilyTreeToPdf(context, head, members),
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppTheme.primaryMagenta,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 2.0,
        child: Center(
          child: ModernFamilyTreeVisualization(head: head, members: members),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryMagenta,
        foregroundColor: AppTheme.white,
        onPressed: () =>
            Navigator.pushNamed(context, '/familyMemberRegistration'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
