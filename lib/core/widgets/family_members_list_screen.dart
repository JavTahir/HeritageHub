import 'package:family_tree_app/core/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:family_tree_app/models/family_member_model.dart';
import 'package:family_tree_app/providers/registeration_provider.dart';
import 'package:provider/provider.dart';

class FamilyMembersListScreen extends StatelessWidget {
  const FamilyMembersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final members = provider.familyMembers;
    final currentUser = FirebaseService.auth.currentUser;
    final isHead = currentUser?.uid == provider.headData?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Members'),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: member.photoUrl != null
                    ? NetworkImage(member.photoUrl!)
                    : const AssetImage('assets/profilePic.png')
                        as ImageProvider,
              ),
              title: Text(member.firstName!),
              subtitle: Text(member.relationWithHead!),
              trailing: isHead
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteMember(context, member),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteMember(
      BuildContext context, FamilyMemberModel member) async {
    final provider = Provider.of<RegistrationProvider>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: Text('Are you sure you want to delete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await provider.deleteFamilyMember(member.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Member removed from family')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: ${e.toString()}')),
        );
      }
    }
  }
}
