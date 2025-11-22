import 'package:flutter/material.dart';

import '/../data/models/user.dart';
import '/../core/theme/app_pallet.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // Card
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppPallet.gradient2,
          child: Text(
            user.username[0],
            style: const TextStyle(color: AppPallet.whiteCcolor),
          ),
        ),
        title: Text(
          user.username,
          style: const TextStyle(
            color: AppPallet.whiteCcolor, 
            fontWeight: FontWeight.bold,
          )),
        subtitle: Text(user.email!),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16, color: Color.fromARGB(255, 158, 158, 158)
        ),
      ),
    );
  }
}