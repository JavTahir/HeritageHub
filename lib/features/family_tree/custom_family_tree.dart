// modern_family_tree_visualization.dart
import 'package:flutter/material.dart';
import 'package:family_tree_app/models/head_model.dart';
import 'package:family_tree_app/models/family_member_model.dart';
import 'package:family_tree_app/core/constants/theme/theme.dart';

class ModernFamilyTreeVisualization extends StatelessWidget {
  final HeadModel head;
  final List<FamilyMemberModel> members;

  const ModernFamilyTreeVisualization({
    Key? key,
    required this.head,
    required this.members,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group members by relationship
    final spouses =
        members.where((m) => m.relationWithHead == 'Spouse').toList();
    final children = members
        .where((m) =>
            m.relationWithHead == 'Son' || m.relationWithHead == 'Daughter')
        .toList();
    final parents = members
        .where((m) =>
            m.relationWithHead == 'Father' || m.relationWithHead == 'Mother')
        .toList();
    final others = members
        .where((m) => !['Spouse', 'Son', 'Daughter', 'Father', 'Mother']
            .contains(m.relationWithHead))
        .toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          if (parents.isNotEmpty) ...[
            _buildGenerationRow(parents, 'Parents'),
            _buildConnectorLine(),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMemberCard(head, isHead: true),
              if (spouses.isNotEmpty) ...[
                const SizedBox(width: 40),
                _buildMemberCard(spouses.first),
              ],
            ],
          ),
          if (children.isNotEmpty) ...[
            _buildConnectorLine(),
            _buildGenerationRow(children, 'Children'),
          ],
          if (others.isNotEmpty) ...[
            const SizedBox(height: 40),
            _buildGenerationRow(others, 'Other Relatives'),
          ],
        ],
      ),
    );
  }

  Widget _buildGenerationRow(List<FamilyMemberModel> members, String title) {
    return Column(
      children: [
        Text(title,
            style:
                AppTheme.bodyMedium.copyWith(color: AppTheme.primaryMagenta)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: members.map((member) => _buildMemberCard(member)).toList(),
        ),
      ],
    );
  }

  Widget _buildConnectorLine() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 40,
      width: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryMagenta.withOpacity(0.5),
            Colors.transparent
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildMemberCard(dynamic member, {bool isHead = false}) {
    final name = member is HeadModel
        ? member.name ?? 'Head'
        : '${member.firstName ?? ''} ${member.lastName ?? ''}'.trim();

    final relation =
        member is FamilyMemberModel ? member.relationWithHead : null;
    final photoUrl = member.photoUrl;

    return Container(
      margin: const EdgeInsets.all(8),
      width: 140,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient:
                  isHead ? AppTheme.primaryGradient : AppTheme.lightGradient,
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: AppTheme.white,
              child: CircleAvatar(
                radius: 32,
                backgroundImage: _getImageProvider(photoUrl),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: [
                Text(
                  name,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isHead ? AppTheme.primaryMagenta : AppTheme.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (relation != null && relation.isNotEmpty)
                  Text(
                    relation,
                    style:
                        AppTheme.caption.copyWith(color: AppTheme.primaryGray),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String? photoUrl) {
    if (photoUrl != null &&
        (photoUrl.startsWith('http://') || photoUrl.startsWith('https://'))) {
      return NetworkImage(photoUrl);
    }
    return const AssetImage('assets/profilePic.png');
  }
}
