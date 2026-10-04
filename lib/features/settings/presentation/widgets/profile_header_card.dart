import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_surface_card.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_state.dart';
import 'package:qeema/features/settings/presentation/widgets/profile_header_avatar.dart';

/// Display-only account header for the top of Settings: photo/name/email for
/// signed-in users, a guest title with a status badge for anonymous users,
/// a shimmer while the auth state loads, and a neutral card when there is no
/// user.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  static const double _radius = 24;
  static const EdgeInsets _contentPadding = EdgeInsets.all(20);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProfileHeaderCubit,
      ProfileHeaderState,
      ProfileHeaderState
    >(
      selector: (state) => state,
      builder: (context, state) {
        final card = Container(
          foregroundDecoration: BoxDecoration(
            border: Border.all(color: context.colors.divider),
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: AppSurfaceCard(
            borderRadius: _radius,
            padding: _contentPadding,
            child: AnimatedSwitcher(
              duration: AppMotion.normal,
              switchInCurve: AppMotion.entrance,
              switchOutCurve: AppMotion.exit,
              child: KeyedSubtree(
                key: ValueKey(state.runtimeType),
                child: _buildState(context, state),
              ),
            ),
          ),
        );

        final label = _semanticLabel(context, state);
        if (label == null) return card;
        return Semantics(label: label, excludeSemantics: true, child: card);
      },
    );
  }

  Widget _buildState(BuildContext context, ProfileHeaderState state) {
    return switch (state) {
      ProfileHeaderLoading() => _buildSkeleton(),
      ProfileHeaderSignedOut() => _buildNeutral(context),
      ProfileHeaderLoaded(:final data) => _buildLoaded(context, data),
    };
  }

  String? _semanticLabel(BuildContext context, ProfileHeaderState state) {
    final t = context.t.settings.profile;
    return switch (state) {
      ProfileHeaderLoaded(:final data) =>
        data.kind == ProfileHeaderKind.guest
            ? t.signedInAsGuest
            : t.semanticLabel.replaceAll(
                '{name}',
                data.displayName ?? t.fallbackName,
              ),
      ProfileHeaderLoading() => null,
      ProfileHeaderSignedOut() => null,
    };
  }

  Widget _buildSkeleton() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShimmerBox(width: 72, height: 72, borderRadius: 36),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 160, height: 16, borderRadius: 8),
              SizedBox(height: AppSpacing.xs),
              ShimmerBox(width: 110, height: 12, borderRadius: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNeutral(BuildContext context) {
    final t = context.t.settings.profile;
    return _layout(
      context: context,
      avatar: const ProfileHeaderAvatar(kind: ProfileHeaderKind.user),
      title: t.fallbackName,
    );
  }

  Widget _buildLoaded(BuildContext context, ProfileHeaderData data) {
    final t = context.t.settings.profile;
    final isGuest = data.kind == ProfileHeaderKind.guest;
    return _layout(
      context: context,
      avatar: ProfileHeaderAvatar(
        kind: data.kind,
        imageUrl: data.avatarUrl,
        name: data.displayName,
      ),
      title: isGuest ? t.guest : (data.displayName ?? t.fallbackName),
      subtitle: isGuest ? null : data.email,
      badge: isGuest ? _guestBadge(context) : null,
    );
  }

  Widget _layout({
    required BuildContext context,
    required Widget avatar,
    required String title,
    String? subtitle,
    Widget? badge,
  }) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        avatar,
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleLarge?.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
              if (badge != null) ...[
                const SizedBox(height: AppSpacing.xs),
                badge,
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _guestBadge(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.secondary.withAlpha(45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_outline_rounded,
            size: 14,
            color: colors.textPrimary,
          ),
          const SizedBox(width: 4),
          Text(
            context.t.settings.profile.signedInAsGuest,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
