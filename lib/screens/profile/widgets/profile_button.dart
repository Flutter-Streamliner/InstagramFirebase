import 'package:flutter/material.dart';

class ProfileButtton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButtton({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? ElevatedButton(
            onPressed: () {},
            child: const Text(
              'Edit profile',
              style: TextStyle(fontSize: 16.0),
            ),
          )
        : ElevatedButton(
            style: isFollowing
                ? ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                    onPrimary: Colors.black,
                  )
                : ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Colors.white),
            onPressed: () {},
            child: Text(
              isFollowing ? 'Unfollow' : 'Follow',
              style: TextStyle(fontSize: 16.0),
            ),
          );
  }
}