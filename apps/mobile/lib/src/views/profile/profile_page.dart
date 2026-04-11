import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../shared/shared.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: CachedNetworkImageProvider(
                      'https://avatars.githubusercontent.com/u/2840?v=4',
                    ),
                  ),
                  Text(
                    'The Makita Verse',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.code),
                  trailing: Icon(Icons.navigate_next, size: 16),
                  title: Text(
                    'See on GitHub',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Launch.openLink(
                      'https://github.com/ayusuke7/the_makita_verse',
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.open_in_browser),
                  trailing: Icon(Icons.navigate_next, size: 16),
                  title: Text(
                    'The Makita Chronicles',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Launch.openLink('https://blog.themakitachronicles.com/');
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.open_in_browser),
                  trailing: Icon(Icons.navigate_next, size: 16),
                  title: Text(
                    'AkitaOnRails Blog',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Launch.openLink('https://akitaonrails.com');
                  },
                ),
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: InkWell(
              onTap: () {
                Launch.openLink('https://github.com/ayusuke7');
              },
              child: Text(
                'Developed by @ayusuke7',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
