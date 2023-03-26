import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:the_dig_app/models/swipe.dart';
import 'package:the_dig_app/providers/dig_firebase_provider.dart';
import 'package:the_dig_app/screens/login_page.dart';
import 'package:the_dig_app/util/bottom_navigation_bar.dart';

class IncomingSwipesPage extends StatelessWidget {
  final String email;
  const IncomingSwipesPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DigFirebaseProvider>(context, listen: false);
    bool isLoggedIn = provider.isLoggedIn;
    if (isLoggedIn) {
      List<Swipe> incomingSwipesList = provider.incomingSwipesList;

      //Users who have requested to connect with current user
      List<Swipe> filteredIncomingSwipesList;

      filteredIncomingSwipesList = incomingSwipesList
          .where((element) =>
              (element.direction == 'top' || element.direction == 'right') &&
              (element.status == 'Pending'))
          .toList();

      if (filteredIncomingSwipesList.isNotEmpty) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Icon(Icons.person_add),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Center(
                    child: ListView.builder(
                      key: const ValueKey("IncomingSwipesListViewValueKey"),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredIncomingSwipesList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xff764abc),
                          ),
                          title: Text(
                            '${filteredIncomingSwipesList[index].sourceProfileFName} ${filteredIncomingSwipesList[index].sourceProfileLName}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                              '${filteredIncomingSwipesList[index].sourceBreed}, ${filteredIncomingSwipesList[index].sourceColor} \nAction: ${filteredIncomingSwipesList[index].direction == "top" ? "Superlike" : filteredIncomingSwipesList[index].direction == "right" ? "Like" : "Invalid"}'),
                          trailing: Wrap(
                            spacing: 12,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.brown,
                                child: IconButton(
                                  icon: const Icon(Icons.check_circle_outline),
                                  onPressed: () async {
                                    Swipe swipe =
                                        filteredIncomingSwipesList[index];
                                    await provider
                                        .respondToRequest(
                                            filteredIncomingSwipesList[index]
                                                .id,
                                            'Accepted')
                                        .then((value) async =>
                                            await provider.createContact(swipe))
                                        .then((value) =>
                                            provider.contacts.clear())
                                        .then((value) async =>
                                            await provider.getContacts(email))
                                        .then((value) => context
                                            .push('/contacts?email=$email'));
                                  },
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.brown,
                                child: IconButton(
                                  icon: const Icon(Icons.highlight_off),
                                  onPressed: () async {
                                    await provider
                                        .respondToRequest(
                                            filteredIncomingSwipesList[index]
                                                .id,
                                            'Rejected')
                                        .then((value) =>
                                            provider.clearIncomingSwipesList())
                                        .then((value) => provider
                                            .getIncomingSwipesList(email))
                                        .then((value) => context.push(
                                            '/incoming/swipes?email=$email'));
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: DigBottomNavBar(email: email),
        );
      } else {
        provider.getIncomingSwipesList(email);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Icon(Icons.swipe),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "No incoming Likes/Superlikes found, but we'll keep checking...",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: DigBottomNavBar(email: email),
        );
      }
    } else {
      const CircularProgressIndicator();

      return const LoginScreen();
    }
  }
}
