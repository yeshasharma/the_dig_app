import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:the_dig_app/models/profile.dart';

class ProfileCard extends StatelessWidget {
  final Profile card;

  const ProfileCard({
    required this.card,
    Key? key,
  }) : super(key: key);

  get direction => null;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.8,
        width: size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(card.profilePicture == ""
                ? "https://firebasestorage.googleapis.com/v0/b/the-dig-app-c3c6d.appspot.com/o/images%2Fsample_image.jpg?alt=media&token=76274cb8-2be8-4f4e-bb88-f825e7a6d1e7"
                : card.profilePicture),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Colors.black12, spreadRadius: 0.5),
            ],
            gradient: const LinearGradient(
              colors: [Colors.black12, Colors.black87],
              begin: Alignment.center,
              stops: [0.4, 1],
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 10,
                left: 10,
                bottom: 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildUserInfo(card: card),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16, right: 8),
                      child: Icon(Icons.info, color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildUserInfo({required Profile card}) => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              card.fName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${card.breed}, ${card.gender}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
          ],
        ),
      );
}
