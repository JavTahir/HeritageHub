import 'package:family_tree_app/core/constants/theme/theme.dart';
import 'package:family_tree_app/features/temples/temple_details_screen.dart';
import 'package:family_tree_app/models/temple_model.dart';
import 'package:family_tree_app/providers/registeration_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TempleAssociation extends StatelessWidget {
  const TempleAssociation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final temples = provider.associatedTemples;
    final samajName = provider.headData?.samajName ?? 'your community';

    return Scaffold(
      backgroundColor: AppTheme.Background,
      appBar: AppBar(
        title: Text(
          'Temples',
          style: AppTheme.headingMedium.copyWith(color: AppTheme.white),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryMagenta,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.white),
      ),
      body: temples.isEmpty
          ? _buildEmptyState(context, samajName)
          : _buildTempleList(context, temples),
    );
  }

  Widget _buildEmptyState(BuildContext context, String samajName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.temple_buddhist,
              size: 80,
              color: AppTheme.primaryMagenta.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No Temples Found',
              style: AppTheme.headingMedium.copyWith(
                color: AppTheme.darkGray,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'There are currently no temples associated with $samajName',
              textAlign: TextAlign.center,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.lightGray,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryMagenta,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Contact Support'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTempleList(BuildContext context, List<TempleModel> temples) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: temples.length,
              itemBuilder: (context, index) {
                final temple = temples[index];
                return _buildTempleCard(context, temple);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempleCard(BuildContext context, TempleModel temple) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TempleDetailsScreen(temple: temple),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryMagenta.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.temple_buddhist,
                  size: 32,
                  color: AppTheme.primaryMagenta,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      temple.name,
                      style: AppTheme.headingSmall.copyWith(
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      temple.location,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.darkGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (temple.contactNumber != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: AppTheme.primaryMagenta,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            temple.contactNumber!,
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.lightGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.lightGray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
