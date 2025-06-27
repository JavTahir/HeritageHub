// lib/core/widgets/modern_profile_dialog.dart
import 'package:family_tree_app/core/constants/theme/theme.dart';
import 'package:family_tree_app/models/family_member_model.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  final FamilyMemberModel member;

  const ProfileDialog({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 32,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _showProfilePhotoPreview(context),
                      child: Hero(
                        tag: 'profile-image',
                        child: Container(
                          margin: const EdgeInsets.only(top: 40),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppTheme.white,
                            backgroundImage: member.photoUrl != null
                                ? NetworkImage(member.photoUrl!)
                                : const AssetImage('assets/profilePic.jpg')
                                    as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${member.firstName} ${member.lastName}',
                      style: AppTheme.headingMedium.copyWith(
                        color: AppTheme.white,
                        fontSize: 22,
                      ),
                    ),
                    if (member.relationWithHead != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          member.relationWithHead!,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                    Icons.cake, 'Age', member.age?.toString() ?? '-'),
                _buildStatItem(
                    Icons.transgender, 'Gender', member.gender ?? '-'),
                _buildStatItem(
                  Icons.family_restroom,
                  'Relation',
                  member.relationWithHead ?? '-',
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Personal Information'),
                  if (member.birthDate != null)
                    _buildDetailItem(
                      Icons.calendar_today,
                      'Birth Date',
                      '${member.birthDate!.day}/${member.birthDate!.month}/${member.birthDate!.year}',
                    ),
                  if (member.maritalStatus != null)
                    _buildDetailItem(
                      Icons.favorite,
                      'Marital Status',
                      member.maritalStatus!,
                    ),
                  if (member.bloodGroup != null)
                    _buildDetailItem(
                      Icons.bloodtype,
                      'Blood Group',
                      member.bloodGroup!,
                    ),
                  _buildSectionTitle('Contact Information'),
                  if (member.phoneNumber != null)
                    _buildDetailItem(
                      Icons.phone,
                      'Phone',
                      member.phoneNumber!,
                    ),
                  if (member.email != null)
                    _buildDetailItem(
                      Icons.email,
                      'Email',
                      member.email!,
                    ),
                  if (member.socialMedia != null)
                    _buildDetailItem(
                      Icons.link,
                      'Social Media',
                      member.socialMedia!,
                      isLink: true,
                    ),
                  _buildSectionTitle('Professional Information'),
                  if (member.qualification != null)
                    _buildDetailItem(
                      Icons.school,
                      'Qualification',
                      member.qualification!,
                    ),
                  if (member.occupation != null)
                    _buildDetailItem(
                      Icons.work,
                      'Occupation',
                      member.occupation!,
                    ),
                  if (member.dutiesNature != null)
                    _buildDetailItem(
                      Icons.description,
                      'Nature of Duties',
                      member.dutiesNature!,
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: AppTheme.headingSmall.copyWith(
          color: AppTheme.primaryMagenta,
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppTheme.primaryMagenta),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.headingSmall.copyWith(fontSize: 16),
        ),
        Text(
          label,
          style: AppTheme.caption,
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value, {
    bool isLink = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 4),
                if (isLink)
                  Text(
                    value,
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  )
                else
                  Text(
                    value,
                    style: AppTheme.bodyMedium,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProfilePhotoPreview(BuildContext context) {
    if (member.photoUrl == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 3.0,
            child: Hero(
              tag: 'profile-image',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  member.photoUrl!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
