import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_state.dart';

/// Circular profile avatar: network photo for signed-in users (shimmer while
/// loading, initials/icon on failure), initials on a tonal circle when there
/// is no photo, and a distinct person icon for guests.
class ProfileHeaderAvatar extends StatelessWidget {
  const ProfileHeaderAvatar({
    super.key,
    required this.kind,
    this.imageUrl,
    this.name,
    this.size = 68,
  });

  final ProfileHeaderKind kind;
  final String? imageUrl;
  final String? name;
  final double size;

  static const double _ringThickness = 2;

  /// Up to two leading letters — first letter of the first and last word.
  /// Works for Latin and Arabic words and never splits a surrogate pair.
  static String initialsFor(String? name) {
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return '';
    final words = trimmed
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '';
    String firstLetter(String word) => word.characters.first;
    final first = firstLetter(words.first);
    if (words.length == 1) return first;
    return '$first${firstLetter(words.last)}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isGuest = kind == ProfileHeaderKind.guest;
    final ringColors = isGuest
        ? <Color>[colors.secondary, colors.secondaryVariant]
        : <Color>[colors.primary, colors.primaryVariant];
    final scaled = Responsive.adapt(size);

    return Container(
      width: scaled + _ringThickness * 2,
      height: scaled + _ringThickness * 2,
      padding: const EdgeInsets.all(_ringThickness),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: ringColors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimary.withAlpha(24),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(child: _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    final scaled = Responsive.adapt(size);
    if (kind == ProfileHeaderKind.guest) {
      return _TonalCircle(
        color: context.colors.secondary,
        iconSize: scaled * 0.45,
      );
    }

    final url = imageUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : const ShimmerBox(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 0,
              ),
        errorBuilder: (context, error, stackTrace) => _initialsOrIcon(context),
      );
    }
    return _initialsOrIcon(context);
  }

  Widget _initialsOrIcon(BuildContext context) {
    final colors = context.colors;
    final scaled = Responsive.adapt(size);
    final initials = initialsFor(name);
    if (initials.isEmpty) {
      return _TonalCircle(color: colors.primary, iconSize: scaled * 0.45);
    }
    return _TonalCircle(
      color: colors.primary,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          initials,
          maxLines: 1,
          style: context.textTheme.headlineMedium?.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _TonalCircle extends StatelessWidget {
  const _TonalCircle({required this.color, this.iconSize, this.child});

  final Color color;
  final double? iconSize;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color.withAlpha(38),
      child:
          child ??
          Center(
            child: Icon(
              Icons.person_outline_rounded,
              size: iconSize,
              color: context.colors.textPrimary,
            ),
          ),
    );
  }
}
