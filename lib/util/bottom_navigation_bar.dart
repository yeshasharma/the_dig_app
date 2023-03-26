import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:the_dig_app/providers/dig_firebase_provider.dart';

class DigBottomNavBar extends StatelessWidget {
  final String email;

  const DigBottomNavBar({
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DigFirebaseProvider>(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Theme.of(context).primaryColor,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat,
            color: Theme.of(context).primaryColor,
          ),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          ),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).primaryColor,
          ),
          label: 'Settings',
        ),
      ],
      onTap: (index) async {
        var route = ModalRoute.of(context);
        if (route?.settings.name != '/profiles' && index == 0) {
          context.push('/profiles?email=$email');
        } else if (route?.settings.name != '/contacts' && index == 1) {
          provider.contacts.clear();
          await provider
              .getContacts(email)
              .then((value) => context.push('/contacts?email=$email'));
        } else if (route?.settings.name != '/profile' && index == 2) {
          context.push('/profile?email=$email');
          // } else if (route?.settings.name != '/add/owner/profile' && index == 2) {
          //   context.push('/add/owner/profile?email=$email');
        } else if (route?.settings.name != '/settings' && index == 3) {
          context.push('/settings?email=$email');
        } else {}
      },
    );
  }
}
