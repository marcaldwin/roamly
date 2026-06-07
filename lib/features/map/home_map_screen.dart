import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/widgets/profile_avatar.dart';

class HomeMapScreen extends StatelessWidget {
  const HomeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    final metadata = user?.userMetadata ?? {};

    final displayName =
        metadata['display_name']?.toString() ?? 'Roamly Explorer';

    final username = metadata['username']?.toString() ?? 'No username';

    final avatarUrl = metadata['avatar_url']?.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roamly'),
        actions: [
          IconButton(
            onPressed: () async {
              await supabase.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileAvatar(
                displayName: displayName,
                avatarUrl: avatarUrl,
                radius: 42,
              ),
              const SizedBox(height: 16),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('@$username'),
              const SizedBox(height: 24),
              Text(
                'Logged in as:\n${user?.email ?? 'No email'}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'Map system coming next.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
