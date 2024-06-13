import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String email;
  final String? profileImageUrl;
  final VoidCallback onProfilePressed;

  const ProfileHeader({
    super.key,
    required this.email,
    required this.onProfilePressed,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          // Profile img
          CircleAvatar(
            radius: 25,
            backgroundImage: profileImageUrl != null
                ? NetworkImage(profileImageUrl!)
                : const AssetImage('assets/default_profile.png')
                    as ImageProvider,
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 12.0),

          // Email
          Expanded(
            child: Text(
              email,
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Profile btn
          IconButton(
            icon: const Icon(Icons.account_circle),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: onProfilePressed,
          ),
        ],
      ),
    );
  }
}
