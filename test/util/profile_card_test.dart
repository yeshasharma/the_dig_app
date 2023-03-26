import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:the_dig_app/models/profile.dart';
import 'package:the_dig_app/util/profile_card.dart';

void main() {
  testWidgets('Should render the user info', (WidgetTester tester) async {
    final profile = Profile(
      id: 1,
      fName: 'John',
      lName: 'Doe',
      breed: 'Golden Retriever',
      gender: 'Male',
      profilePicture: '',
      city: '',
      color: '',
      email: '',
      isVaccinated: true,
      joiningDate: '',
      ownerId: 1,
      ownerfName: '',
      ownerlName: '',
      ownerprofilePicture: '',
      phone: 1,
      registrationDate: '',
      size: '',
    );
    final profileCard = ProfileCard(card: profile);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: profileCard),
      ),
    );

    final userInfoFinder =
        find.text('${profile.fName} ${profile.breed}, ${profile.gender}');
    expect(userInfoFinder, findsOneWidget);
  });
}
