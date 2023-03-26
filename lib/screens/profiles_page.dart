import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:the_dig_app/models/profile.dart';
import 'package:the_dig_app/providers/dig_firebase_provider.dart';
import 'package:the_dig_app/screens/login_page.dart';
import 'package:the_dig_app/util/bottom_navigation_bar.dart';
import 'package:the_dig_app/util/profile_card.dart';

class ProfilesPage extends StatelessWidget {
  final String email;
  const ProfilesPage({super.key, required this.email});

  @override
  Widget build(context) {
    final provider = Provider.of<DigFirebaseProvider>(context);
    bool isLoggedIn = provider.isLoggedIn;
    List<Profile> profiles = provider.profiles;
    List<ProfileCard> cards = provider.cards;
    if (isLoggedIn) {
      bool isLastCard = provider.isLastCard;
      if (profiles.isNotEmpty) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Icon(Icons.pets_outlined),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Flexible(
                  child: CardSwiper(
                    scale: 0,
                    cards: cards,
                    onEnd: () async {
                      await provider.getProfiles(email).then(
                          (value) => context.push('/profiles?email=$email'));
                    },
                    isDisabled: isLastCard,
                    onSwipe: (int index, CardSwiperDirection direction) async {
                      if (direction.name == 'top') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                '"${cards[index].card.fName}" was Superliked')));
                      } else if (direction.name == 'bottom') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                '"${cards[index].card.fName}" was Ignored(for now)')));
                      } else if (direction.name == 'left') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                '"${cards[index].card.fName}" was Rejected')));
                      } else if (direction.name == 'right') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                '"${cards[index].card.fName}" was Liked')));
                      } else {
                        throw Exception("Unsupported operation");
                      }
                      await provider.insertSwipe(index, direction);
                    },
                    padding: const EdgeInsets.all(24.0),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: DigBottomNavBar(email: email),
        );
      } else {
        provider.getCurrentUserProfile(email).then((value) async {
          await provider
              .storeNotificationToken(provider.currentProfile[0].id.toString());
        }).then((value) async => await provider.getCurrentUserProfile(email));
        provider.getProfiles(email);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Icon(Icons.pets_outlined),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "No more profiles found, but we'll keep checking...",
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
