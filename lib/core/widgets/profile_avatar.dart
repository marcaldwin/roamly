import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.displayName,
    this.avatarUrl,
    this.radius = 32,
  });

  final String displayName;
  final String? avatarUrl;
  final double radius;

  String get initial {
    final trimmedName = displayName.trim();

    if (trimmedName.isEmpty) {
      return '?';
    }

    return trimmedName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    return CircleAvatar(
      radius: radius,
      backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
      child: hasAvatar
          ? null
          : Text(
              initial,
              style: TextStyle(
                fontSize: radius * 0.8,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
