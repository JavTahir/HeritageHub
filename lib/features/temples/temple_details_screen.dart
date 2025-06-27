import 'package:flutter/material.dart';
import 'package:family_tree_app/core/constants/theme/theme.dart';
import '../../models/temple_model.dart';

class TempleDetailsScreen extends StatelessWidget {
  final TempleModel temple;

  const TempleDetailsScreen({Key? key, required this.temple}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.Background,
      extendBodyBehindAppBar: temple.imageUrl != null,
      appBar: AppBar(
        title: Text(
          temple.name,
          style: AppTheme.headingMedium.copyWith(color: AppTheme.white),
        ),
        centerTitle: true,
        backgroundColor: temple.imageUrl != null
            ? Colors.transparent
            : AppTheme.primaryMagenta,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.white),
        flexibleSpace: temple.imageUrl != null
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (temple.imageUrl != null)
              Hero(
                tag: 'temple-${temple.id}',
                child: Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(temple.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    temple.name,
                    style: AppTheme.headingLarge.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: AppTheme.primaryMagenta,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        temple.location,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.darkGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (temple.contactNumber != null)
                    _buildInfoCard(
                      context,
                      title: 'Contact Information',
                      content: Column(
                        children: [
                          _buildDetailRow(
                            icon: Icons.call,
                            label: 'Phone',
                            value: temple.contactNumber!,
                            isPhone: true,
                          ),
                        ],
                      ),
                    ),
                  if (temple.description != null)
                    _buildInfoCard(
                      context,
                      title: 'About Temple',
                      content: Text(
                        temple.description!,
                        style: AppTheme.bodyMedium,
                      ),
                    ),
                  _buildInfoCard(
                    context,
                    title: 'Community Information',
                    content: _buildDetailRow(
                      icon: Icons.people,
                      label: 'Associated Samaj',
                      value: temple.samaj,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppTheme.headingSmall.copyWith(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.primaryMagenta,
          ),
          const SizedBox(width: 12),
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
                if (isPhone)
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
}
