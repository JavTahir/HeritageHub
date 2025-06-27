import 'package:family_tree_app/core/constants/theme/theme.dart';
import 'package:family_tree_app/core/services/firebase_service.dart';
import 'package:family_tree_app/core/widgets/buttons/moddashborad_button.dart';
import 'package:family_tree_app/core/widgets/dialogs/profile_dialog.dart';
import 'package:family_tree_app/core/widgets/dialogs/rofile_photo_viewer.dart';
import 'package:family_tree_app/models/family_member_model.dart';
import 'package:flutter/material.dart';
import 'package:family_tree_app/providers/registeration_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final currentUser = FirebaseService.auth.currentUser;
    final isHead = currentUser?.uid == provider.headData?.id;

    return Scaffold(
      backgroundColor: AppTheme.cardBackground,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: AppTheme.headingMedium.copyWith(color: AppTheme.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.primaryMagenta),
            onPressed: () async {
              await FirebaseService.auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileCard(context, provider, isHead),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Quick Actions',
                  style: AppTheme.headingSmall.copyWith(
                    color: AppTheme.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              isHead
                  ? _buildHeadDashboard(context, provider)
                  : _buildMemberDashboard(context, provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      BuildContext context, RegistrationProvider provider, bool isHead) {
    return AppTheme.gradientContainer(
      gradient: AppTheme.lightGradient,
      borderRadius: AppTheme.cardRadius,
      boxShadow: AppTheme.cardShadow,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () =>
                        _showProfilePhotoPreview(context, provider, isHead),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.white,
                          width: 3,
                        ),
                        image: DecorationImage(
                          image: _getProfileImage(provider, isHead),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getWelcomeMessage(provider, isHead),
                      style: AppTheme.headingMedium
                          .copyWith(color: AppTheme.white, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSubtitle(provider, isHead),
                      style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.white.withOpacity(0.9), fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  Icons.people,
                  'Members',
                  provider.familyMembers.length.toString(),
                ),
                _buildStatItem(
                  Icons.person,
                  'Head',
                  provider.headData != null ? '1' : '0',
                ),
                _buildStatItem(
                  Icons.temple_buddhist,
                  'Temples',
                  provider.associatedTemples.length.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.white),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.headingSmall.copyWith(
            color: AppTheme.white,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: AppTheme.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  void _showProfilePhotoPreview(
      BuildContext context, RegistrationProvider provider, bool isHead) {
    final imageUrl =
        isHead ? provider.headData?.photoUrl : provider.currentMember?.photoUrl;

    if (imageUrl == null) return;

    showDialog(
      context: context,
      builder: (context) => ProfilePhotoViewer(
        imageUrl: imageUrl,
        heroTag: 'profile-image',
      ),
    );
  }

  ImageProvider _getProfileImage(RegistrationProvider provider, bool isHead) {
    if (isHead) {
      return provider.headData?.photoUrl != null
          ? NetworkImage(provider.headData!.photoUrl!)
          : const AssetImage('assets/profilePic.jpg') as ImageProvider;
    } else {
      return provider.currentMember?.photoUrl != null
          ? NetworkImage(provider.currentMember!.photoUrl!)
          : const AssetImage('assets/profilePic.jpg') as ImageProvider;
    }
  }

  String _getWelcomeMessage(RegistrationProvider provider, bool isHead) {
    if (isHead) {
      return 'Welcome, ${provider.headData?.name ?? "Head"}!';
    } else {
      final member = provider.currentMember;
      return 'Welcome, ${member?.firstName != null && member?.lastName != null ? '${member!.firstName} ${member.lastName}' : 'Family Member'}!';
    }
  }

  String _getSubtitle(RegistrationProvider provider, bool isHead) {
    if (isHead) {
      return 'Family Head of ${provider.headData?.samajName ?? "your community"}';
    } else {
      return 'Member of ${provider.headData?.samajName ?? "the family"}';
    }
  }

  Widget _buildHeadDashboard(
      BuildContext context, RegistrationProvider provider) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      children: [
        ModernDashboardButton(
          icon: Icons.account_tree,
          label: 'Family Tree',
          gradient: AppTheme.lightGradient,
          onTap: () => Navigator.pushNamed(context, '/familyTree'),
        ),
        ModernDashboardButton(
          icon: Icons.person_add,
          label: 'Add Member',
          gradient: AppTheme.reversePrimaryGradient,
          onTap: () =>
              Navigator.pushNamed(context, '/familyMemberRegistration'),
        ),
        ModernDashboardButton(
          icon: Icons.people,
          label: 'Manage Members',
          gradient: AppTheme.primaryGradient,
          onTap: () => Navigator.pushNamed(context, '/familyMembersList'),
        ),
        ModernDashboardButton(
          icon: Icons.temple_buddhist,
          label: 'Temples',
          gradient: AppTheme.lightGradient,
          onTap: () {
            provider.loadTemples();
            Navigator.pushNamed(context, '/temples');
          },
        ),
      ],
    );
  }

  Widget _buildMemberDashboard(
      BuildContext context, RegistrationProvider provider) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      children: [
        ModernDashboardButton(
          icon: Icons.account_tree,
          label: 'Family Tree',
          gradient: AppTheme.lightGradient,
          onTap: () => Navigator.pushNamed(context, '/familyTree'),
        ),
        ModernDashboardButton(
          icon: Icons.people,
          label: 'Family Members',
          gradient: AppTheme.reversePrimaryGradient,
          onTap: () => Navigator.pushNamed(context, '/familyMembersList'),
        ),
        ModernDashboardButton(
          icon: Icons.temple_buddhist,
          label: 'Temples',
          gradient: AppTheme.primaryGradient,
          onTap: () {
            provider.loadTemples();
            Navigator.pushNamed(context, '/temples');
          },
        ),
        ModernDashboardButton(
          icon: Icons.person,
          label: 'My Profile',
          gradient: AppTheme.lightGradient,
          onTap: () =>
              _showModernProfileDialog(context, provider.currentMember!),
        ),
      ],
    );
  }

  void _showModernProfileDialog(
      BuildContext context, FamilyMemberModel member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ProfileDialog(member: member),
    );
  }

  Widget _buildProfileDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppTheme.primaryMagenta),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.lightGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
