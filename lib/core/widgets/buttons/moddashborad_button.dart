// lib/core/widgets/modern_dashboard_button.dart

import 'package:flutter/material.dart';
import 'package:family_tree_app/core/constants/theme/theme.dart';

class ModernDashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const ModernDashboardButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.cardRadius,
        child: AppTheme.gradientContainer(
          gradient: gradient,
          borderRadius: AppTheme.cardRadius,
          boxShadow: AppTheme.buttonShadow,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: AppTheme.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: AppTheme.buttonText.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
