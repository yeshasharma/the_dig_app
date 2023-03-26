import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_dig_app/models/profile.dart';
import 'package:the_dig_app/providers/dig_firebase_provider.dart';
import 'package:the_dig_app/screens/login_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:the_dig_app/util/bottom_navigation_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.email});
  final String email;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Profile profile;

  String? _imagePath;

  @override
  void initState() {
    super.initState();
  }

  Future<String?> _takePhotoWithCamera(int profileId) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile == null) return null;

    final imageFile = File(pickedFile.path);
    final fileName = '${profileId}_profile.jpg';
    final destination = 'images/$profileId/$fileName';

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .putFile(imageFile);
      final url = await firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .getDownloadURL();
      setState(() {
        // _imagePath = destination;
        _imagePath = url;
      });
      //update profile picture path in firestore profile doc
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection('profile')
          .doc(profileId.toString());
      await documentReference.update({
        'profilePicture': url,
      }).then((value) {
        debugPrint('Update picture to main profile successful');
      }).catchError((error) {
        debugPrint('Update failed: $error');
      });
      return url;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  Future<String?> _getImageFromGallery(int profileId) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    final imageFile = File(pickedFile.path);
    final fileName = '${profileId}_profile.jpg';
    final destination = 'images/$profileId/$fileName';

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .putFile(imageFile);
      final url = await firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .getDownloadURL();
      setState(() {
        // _imagePath = destination;
        _imagePath = url;
      });
      //update profile picture path in firestore profile doc
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection('profile')
          .doc(profileId.toString());
      await documentReference.update({
        'profilePicture': url,
      }).then((value) {
        debugPrint('Update picture to main profile successful');
      }).catchError((error) {
        debugPrint('Update failed: $error');
      });
      return url;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  void _showImagePicker(BuildContext context, int profileId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _getImageFromGallery(profileId);
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: <Widget>[
                          const Icon(
                            Icons.photo_library,
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          Text('Gallery',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _takePhotoWithCamera(profileId);
                        context.pop();
                      },
                      child: Column(
                        children: <Widget>[
                          const Icon(
                            Icons.camera_alt,
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          Text('Camera',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DigFirebaseProvider>(context);
    bool isLoggedIn = provider.isLoggedIn;
    if (isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              onPressed: () {
                provider.readProfiles(widget.email);
                context.push("/edit/owner/profile?email=${widget.email}");
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Center(
                child: FutureBuilder<List<Profile>>(
                    future: provider.readProfiles(widget.email),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        var profileList = snapshot.data as List<Profile>;
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: profileList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              CircleAvatar(
                                                radius: 150,
                                                backgroundImage: _imagePath !=
                                                        null
                                                    ? NetworkImage(_imagePath!)
                                                    : profileList[index]
                                                                .profilePicture !=
                                                            ""
                                                        ? NetworkImage(
                                                            profileList[index]
                                                                .profilePicture)
                                                        : const NetworkImage(
                                                            "https://firebasestorage.googleapis.com/v0/b/the-dig-app-c3c6d.appspot.com/o/images%2Fsample_image.jpg?alt=media&token=76274cb8-2be8-4f4e-bb88-f825e7a6d1e7"),
                                              ),
                                              Positioned(
                                                top: 210,
                                                right: 0,
                                                child: InkWell(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        _showImagePicker(
                                                            context,
                                                            profileList[index]
                                                                .id);
                                                      },
                                                      icon: const Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 25, bottom: 25),
                                            // child: Container(),
                                            child: Text(
                                              'Owner Details',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading: const Icon(Icons.person),
                                            title: const Text('Name'),
                                            subtitle: Text(
                                                "${profileList[index].ownerfName} ${profileList[index].ownerlName}"),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading: const Icon(Icons.email),
                                            title: const Text('Email'),
                                            subtitle:
                                                Text(profileList[index].email),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading: const Icon(Icons.phone),
                                            title: const Text('Phone'),
                                            subtitle: Text(profileList[index]
                                                .phone
                                                .toString()),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.location_city),
                                            title: const Text('City'),
                                            subtitle:
                                                Text(profileList[index].city),
                                          ),
                                          const Divider(),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 25, bottom: 25),
                                            child: Text(
                                              'Furry Friend Details',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading: const Icon(Icons.pets),
                                            title: const Text('Name'),
                                            subtitle: Text(
                                                "${profileList[index].fName} ${profileList[index].lName}"),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading:
                                                profileList[index].gender ==
                                                        "male"
                                                    ? const Icon(Icons.male)
                                                    : const Icon(Icons.female),
                                            title: const Text('Gender'),
                                            subtitle:
                                                Text(profileList[index].gender),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading: const Icon(Icons.pets),
                                            title: const Text('Breed'),
                                            subtitle:
                                                Text(profileList[index].breed),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.color_lens),
                                            title: const Text('Color'),
                                            subtitle:
                                                Text(profileList[index].color),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading: const Icon(Icons.vaccines),
                                            title: const Text('Vaccinated'),
                                            subtitle: Text(profileList[index]
                                                .isVaccinated
                                                .toString()),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.date_range),
                                            title:
                                                const Text('Registration Date'),
                                            subtitle: Text(profileList[index]
                                                .registrationDate
                                                .toString()),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.date_range),
                                            title: const Text('Joining Date'),
                                            subtitle: Text(profileList[index]
                                                .joiningDate
                                                .toString()
                                                .substring(0, 10)),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.stacked_bar_chart),
                                            title: const Text('Size'),
                                            subtitle:
                                                Text(profileList[index].size),
                                          ),
                                          const Divider(),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 25, bottom: 25),
                                            child: Text(
                                              'Additional Details',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const Divider(),
                                          if (profileList[index]
                                                  .socialIndexHumans !=
                                              null)
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.hotel_class),
                                              title: const Text(
                                                  'Rate for social with Humans'),
                                              subtitle: Text(profileList[index]
                                                  .socialIndexHumans
                                                  .toString()),
                                            ),
                                          if (profileList[index]
                                                  .socialIndexDogs !=
                                              null)
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.hotel_class),
                                              title: const Text(
                                                  'Rate for social with Dogs'),
                                              subtitle: Text(profileList[index]
                                                  .socialIndexDogs
                                                  .toString()),
                                            ),
                                          if (profileList[index]
                                                  .isFoodAggressive !=
                                              null)
                                            ListTile(
                                              leading: const Icon(Icons.sick),
                                              title: const Text(
                                                  'Aggressive When Hungry'),
                                              subtitle: Text(profileList[index]
                                                  .isFoodAggressive
                                                  .toString()),
                                            ),
                                          if (profileList[index]
                                                  .isNewHumanAggressive !=
                                              null)
                                            ListTile(
                                              leading: const Icon(Icons.sick),
                                              title: const Text(
                                                  'Aggressive when meets new humans'),
                                              subtitle: Text(profileList[index]
                                                  .isNewHumanAggressive
                                                  .toString()),
                                            ),
                                          if (profileList[index]
                                                  .isNewDogAggressive !=
                                              null)
                                            ListTile(
                                              leading: const Icon(Icons.sick),
                                              title: const Text(
                                                  'Aggressive when meets new dogs'),
                                              subtitle: Text(profileList[index]
                                                  .isNewDogAggressive
                                                  .toString()),
                                            ),
                                          if (profileList[index].foodName !=
                                              null)
                                            ListTile(
                                              leading: const Icon(Icons.cookie),
                                              title:
                                                  const Text('Favorite Food'),
                                              subtitle: Text(profileList[index]
                                                  .foodName
                                                  .toString()),
                                            ),
                                          if (profileList[index]
                                                  .foodLikingIndex !=
                                              null)
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.hotel_class),
                                              title:
                                                  const Text('Rating for food'),
                                              subtitle: Text(profileList[index]
                                                  .foodLikingIndex
                                                  .toString()),
                                            ),
                                          if (profileList[index].activityName !=
                                              null)
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.local_activity),
                                              title: const Text(
                                                  'Favortie activity'),
                                              subtitle: Text(profileList[index]
                                                  .activityName!),
                                            ),
                                          if (profileList[index]
                                                  .activityLikingIndex !=
                                              null)
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.hotel_class),
                                              title: const Text(
                                                  'Rate for favortie activity'),
                                              subtitle: Text(profileList[index]
                                                  .activityLikingIndex
                                                  .toString()),
                                            ),
                                          if (profileList[index].skillName !=
                                              null)
                                            ListTile(
                                              leading: const Icon(Icons.pets),
                                              title: const Text('Skill Name'),
                                              subtitle: Text(profileList[index]
                                                  .skillName
                                                  .toString()),
                                            ),
                                          if (profileList[index]
                                                  .skillProficiency !=
                                              null)
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.hotel_class),
                                              title: const Text(
                                                  'Skill Proficiency'),
                                              subtitle: Text(profileList[index]
                                                  .skillProficiency!),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else {
                        return const Center(child: Text('No profile yet'));
                      }
                    }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: DigBottomNavBar(email: widget.email),
      );
    } else {
      const CircularProgressIndicator();

      return const LoginScreen();
    }
  }
}
