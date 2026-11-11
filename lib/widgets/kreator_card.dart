import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/user_model.dart';
import '../widgets/loading_shimmer.dart';

class KreatorCard extends StatelessWidget {
  final UserModel kreator;
  final VoidCallback? onTap;

  const KreatorCard({
    super.key,
    required this.kreator,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1,
                child: kreator.profileImage != null
                    ? CachedNetworkImage(
                        imageUrl: kreator.profileImage!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const ShimmerBox(
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        errorWidget: (_, __, ___) => _buildPlaceholder(theme),
                      )
                    : _buildPlaceholder(theme),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kreator.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Rating row
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          size: 14, color: Colors.amber.shade600),
                      const SizedBox(width: 2),
                      Text(
                        kreator.rating.toStringAsFixed(1),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.amber.shade700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${kreator.jobCount} job)',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Specialization chip
                  if (kreator.skills.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        kreator.skills.first,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.primaryContainer,
      child: Center(
        child: Text(
          kreator.name.isNotEmpty ? kreator.name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
