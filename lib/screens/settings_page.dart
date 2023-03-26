import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:the_dig_app/providers/dig_firebase_provider.dart';
import 'package:the_dig_app/screens/login_page.dart';
import 'package:the_dig_app/util/bottom_navigation_bar.dart';

class SettingsPage extends StatelessWidget {
  final String email;
  const SettingsPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DigFirebaseProvider>(context);
    bool isLoggedIn = provider.isLoggedIn;
    if (isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Icon(Icons.settings),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome, ${provider.currentProfile[0].fName}\'s owner',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 24)),
                  const Text('My Activities'),
                ],
              ),
              tiles: [
                SettingsTile(
                  title: const Text('Left Swipes'),
                  leading: const Icon(Icons.arrow_back_ios),
                  onPressed: (BuildContext context) async {
                    provider.swipesList.clear();
                    await provider.getSwipesList(email, 'left').then((value) =>
                        context.push('/swipes?email=$email&direction=left'));
                  },
                ),
                SettingsTile(
                  title: const Text('Right Swipes'),
                  leading: const Icon(Icons.arrow_forward_ios),
                  onPressed: (BuildContext context) async {
                    provider.swipesList.clear();
                    await provider.getSwipesList(email, 'right').then((value) =>
                        context.push('/swipes?email=$email&direction=right'));
                  },
                ),
                SettingsTile(
                  title: const Text('Top Swipes'),
                  leading: const Icon(Icons.arrow_upward_outlined),
                  onPressed: (BuildContext context) async {
                    provider.swipesList.clear();
                    await provider.getSwipesList(email, 'top').then((value) =>
                        context.push('/swipes?email=$email&direction=top'));
                  },
                ),
                SettingsTile(
                  title: const Text('My Requests'),
                  leading: const Icon(Icons.person_add),
                  onPressed: (BuildContext context) async {
                    provider.incomingSwipesList.clear();
                    await provider.getIncomingSwipesList(email).then((value) =>
                        context.push('/incoming/swipes?email=$email'));
                  },
                ),
                SettingsTile(
                  title: const Text('My Contacts'),
                  leading: const Icon(Icons.group),
                  onPressed: (BuildContext context) async {
                    provider.contacts.clear();
                    await provider.getContacts(email).then(
                        (value) => context.push('/contacts?email=$email'));
                  },
                ),
              ],
            ),
            SettingsSection(
              title: const Text('App Settings'),
              tiles: [
                SettingsTile(
                    title: const Text('Sign Out'),
                    leading: const Icon(Icons.power_settings_new_outlined),
                    onPressed: (BuildContext context) async {
                      await FirebaseAuth.instance
                          .signOut()
                          .then((value) => ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text('User logged out'))))
                          .then((value) => provider.checkFirebaseAuth())
                          .then((value) => provider.onLogout())
                          .then((value) => Navigator.popUntil(
                              context, ModalRoute.withName('/login')));
                    }),
              ],
            ),
          ],
        ),
        bottomNavigationBar: DigBottomNavBar(email: email),
      );
    } else {
      const CircularProgressIndicator();

      return const LoginScreen();
    }
  }
}
