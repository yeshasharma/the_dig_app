import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_dig_app/models/swipe.dart';
import 'package:the_dig_app/providers/dig_firebase_provider.dart';
import 'package:the_dig_app/screens/login_page.dart';
import 'package:the_dig_app/util/bottom_navigation_bar.dart';

class SwipesPage extends StatelessWidget {
  final String direction;
  final String email;
  const SwipesPage({super.key, required this.email, required this.direction});

  @override
  Widget build(context) {
    final provider = Provider.of<DigFirebaseProvider>(context);
    bool isLoggedIn = provider.isLoggedIn;
    if (isLoggedIn) {
      List<Swipe> swipesList = provider.swipesList;

      List<Swipe> filteredSwipesList;

      filteredSwipesList =
          swipesList.where((x) => x.direction.contains(direction)).toList();

      if (filteredSwipesList.isNotEmpty && filteredSwipesList.isNotEmpty) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Icon(Icons.swipe),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Center(
                    child: ListView.builder(
                      key: ValueKey("${direction}_SwipesListViewValueKey"),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredSwipesList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xff764abc),
                          ),
                          title: Text(
                            '${filteredSwipesList[index].destinationProfileFName} ${filteredSwipesList[index].destinationProfileLName}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                              '${filteredSwipesList[index].destinationBreed}, ${filteredSwipesList[index].destinationColor}'),
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
        provider.getSwipesList(email, direction);
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
                  "No $direction swipes found, but we'll keep checking...",
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
