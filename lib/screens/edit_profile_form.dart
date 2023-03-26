import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:the_dig_app/models/profile.dart';
import 'package:the_dig_app/providers/dig_firebase_provider.dart';
import 'package:intl/intl.dart';
import 'package:the_dig_app/screens/login_page.dart';
// import 'package:simple_permissions/simple_permissions.dart';

enum RadioValue { Male, Female }

// const List<String> aggression = ['Yes', 'No'];

class EditProfileForm extends StatefulWidget {
  final String email;
  EditProfileForm({super.key, required this.email});

  @override
  createState() => _EditProfileForm();
}

class _EditProfileForm extends State<EditProfileForm> {
  final sizes = ['Small', 'Medium', 'Large'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  String? _gender;
  String? genderRadio;
  bool? isVaccinated;
  bool? isSterilized;
  bool? _isChecked;
  DateTime _selectedDate = DateTime.now();
  String? ownerfName;
  String? ownerlName;
  int? phone;
  String? city;
  String? fName;
  String? lName;
  String? bio;
  String? breed;
  String? color;
  String? size;
  int? socialHumans;
  int? socialDogs;
  int? favfoodIndex;
  String? activityName;
  String? foodName;
  String? skillName;
  String? skillProficiency;
  int? activityIndex;
  bool? _isFoodAggressive;
  bool? _isHumanAggressive;
  bool? _isDogAggressive;

  final alphabetsPattern = RegExp(r'^[a-zA-Z]+$');
  final digitsPattern = RegExp(r'^[1-9]$|^10$');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    if (picked != null)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(_selectedDate);
      });
  }
  // final RadioValue radioValue;
  // final Function(RadioValue?)? onRadioValueChange;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DigFirebaseProvider>(context);
    final profileList = provider.readProfiles(widget.email);
    // String? _gender = profileList.gender;
    bool isLoggedIn = provider.isLoggedIn;
    if (isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Your Details"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<List<Profile>>(
                  future: profileList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      var profiles = snapshot.data as List<Profile>;
                      // _gender = profiles[0].gender;
                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Divider(
                              color: Colors.black,
                              height: 25,
                              thickness: 2,
                              indent: 5,
                              endIndent: 5,
                            ),
                            const Text("Your Profile"),
                            TextFormField(
                              initialValue: profiles[0].ownerfName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                if (!alphabetsPattern.hasMatch(value)) {
                                  return 'Please enter valid first name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                ownerfName = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Your First Name',
                              ),
                            ),
                            TextFormField(
                              initialValue: profiles[0].ownerlName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                if (!alphabetsPattern.hasMatch(value)) {
                                  return 'Please enter valid last name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Your Last Name',
                              ),
                              onChanged: (value) {
                                ownerlName = value;
                              },
                            ),
                            TextFormField(
                              key: const ValueKey("email"),
                              maxLines: 1,
                              readOnly: true,
                              style: const TextStyle(color: Colors.grey),
                              initialValue: widget.email,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                            TextFormField(
                              initialValue: profiles[0].phone.toString(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                if (!RegExp(r'^\+?[0-9]{10}$')
                                    .hasMatch(value)) {
                                  return 'Please enter valid phone number';
                                }
                                return null;
                              },
                              maxLength: 10,
                              decoration: const InputDecoration(
                                labelText: 'Phone number',
                              ),
                              onChanged: (value) {
                                phone = int.tryParse(value);
                              },
                            ),
                            TextFormField(
                              initialValue: profiles[0].city,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your city';
                                }
                                if (!alphabetsPattern.hasMatch(value)) {
                                  return 'Please enter valid city';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'City',
                              ),
                              onChanged: (value) {
                                city = value;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            const Divider(
                              color: Colors.black,
                              height: 25,
                              thickness: 2,
                              indent: 5,
                              endIndent: 5,
                            ),
                            const Text("Pet Profile"),
                            TextFormField(
                              initialValue: profiles[0].fName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your pets First Name';
                                }
                                if (!alphabetsPattern.hasMatch(value)) {
                                  return 'Please enter valid first name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Pets First Name',
                              ),
                              onChanged: (value) {
                                fName = value;
                              },
                            ),
                            TextFormField(
                              initialValue: profiles[0].lName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your pets Last Name';
                                }
                                if (!alphabetsPattern.hasMatch(value)) {
                                  return 'Please enter valid last name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Pets Last Name',
                              ),
                              onChanged: (value) {
                                lName = value;
                              },
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 25,
                              thickness: 2,
                              indent: 5,
                              endIndent: 5,
                            ),
                            TextFormField(
                              initialValue: profiles[0].biography,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!alphabetsPattern.hasMatch(value)) {
                                    return 'Please enter valid bio';
                                  }
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Pets Biography',
                              ),
                              onChanged: (value) {
                                bio = value;
                              },
                            ),
                            Text(
                              'Gender:',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8.0),
                            RadioListTile(
                              title: const Text('Male'),
                              value: "Male",
                              groupValue: _gender ?? profiles[0].gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value!;
                                  profiles[0].gender = value;
                                });
                              },
                            ),
                            RadioListTile(
                              title: const Text('Female'),
                              value: "Female",
                              groupValue: _gender ?? profiles[0].gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value!;
                                  profiles[0].gender = value;
                                });
                              },
                            ),
                            TextFormField(
                              initialValue: profiles[0].breed,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your breed';
                                }
                                if (!alphabetsPattern.hasMatch(value)) {
                                  return 'Please enter valid breed name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Pets Breed',
                              ),
                              onChanged: (value) {
                                breed = value;
                              },
                            ),
                            TextFormField(
                              initialValue: profiles[0].color,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your pets color';
                                }
                                if (!alphabetsPattern.hasMatch(value)) {
                                  return 'Please enter valid color';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Pets Color',
                              ),
                              onChanged: (value) {
                                color = value;
                              },
                            ),
                            CheckboxListTile(
                              title: const Text('Is Vaccinated?'),
                              value: _isChecked ?? profiles[0].isVaccinated,
                              onChanged: (checked) {
                                setState(() {
                                  _isChecked = checked!;
                                });
                              },
                            ),
                            Text(
                              'Registeration Date:',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              onTap: () => _selectDate(context),
                              controller: TextEditingController(
                                text: _selectedDate == null
                                    ? ''
                                    : DateFormat('yyyy-MM-dd')
                                        .format(_selectedDate),
                              ),
                              readOnly: true,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                            ),
                            Text('Sterilization:',
                                style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 8.0),
                            CheckboxListTile(
                              title: const Text('Is Sterilized?'),
                              value: isSterilized ??
                                  profiles[0].isSterilized ??
                                  false,
                              onChanged: (checked) {
                                setState(() {
                                  isSterilized = checked!;
                                });
                              },
                            ),
                            // TextFormField(
                            //   initialValue: profiles[0].size,
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Please enter your pets size';
                            //     }
                            //     if (!alphabetsPattern.hasMatch(value)) {
                            //       return 'Please enter valid size';
                            //     }
                            //     return null;
                            //   },
                            //   decoration: const InputDecoration(
                            //     labelText: 'Pets Size',
                            //   ),
                            //   onChanged: (value) {
                            //     size = value;
                            //   },
                            // ),
                            DropdownButtonFormField(
                              value: profiles[0].size,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a value';
                                }
                                return null;
                              },
                              items: sizes
                                  .map(((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      )))
                                  .toList(),
                              onChanged: (value) {
                                _sizeController.text = value as String;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Size',
                                hintText: 'Enter Size',
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 25,
                              thickness: 2,
                              indent: 5,
                              endIndent: 5,
                            ),
                            const Text("Behavior"),
                            TextFormField(
                              key: const ValueKey("socialHumans"),
                              maxLines: 1,
                              maxLength: 2,
                              initialValue:
                                  profiles[0].socialIndexHumans != null
                                      ? profiles[0].socialIndexHumans.toString()
                                      : "",
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Rate for Socializing with humans',
                              ),
                              onChanged: (value) {
                                socialHumans = int.tryParse(value);
                              },
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!digitsPattern.hasMatch(value)) {
                                    return 'Please enter only digits between 1 to 10';
                                  }
                                }
                              },
                            ),
                            TextFormField(
                              key: const ValueKey("socialDogs"),
                              maxLines: 1,
                              maxLength: 2,
                              initialValue: profiles[0].socialIndexDogs != null
                                  ? profiles[0].socialIndexDogs.toString()
                                  : "",
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Rate for Socializing with dogs',
                              ),
                              onChanged: (value) {
                                socialDogs = int.tryParse(value);
                              },
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!digitsPattern.hasMatch(value)) {
                                    return 'Please enter only digits between 1 to 10';
                                  }
                                }
                              },
                            ),
                            CheckboxListTile(
                              title: const Text('Is Food Aggressive?'),
                              value: _isFoodAggressive ??
                                  profiles[0].isFoodAggressive ??
                                  false,
                              onChanged: (checked) {
                                setState(() {
                                  _isFoodAggressive = checked!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text('Is Human Aggressive?'),
                              value: _isHumanAggressive ??
                                  profiles[0].isNewHumanAggressive ??
                                  false,
                              onChanged: (checked) {
                                setState(() {
                                  _isHumanAggressive = checked!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text('Is Dog Aggressive?'),
                              value: _isDogAggressive ??
                                  profiles[0].isNewDogAggressive ??
                                  false,
                              onChanged: (checked) {
                                setState(() {
                                  _isDogAggressive = checked!;
                                });
                              },
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 25,
                              thickness: 2,
                              indent: 5,
                              endIndent: 5,
                            ),
                            const Text("Food Preference"),
                            TextFormField(
                              key: const ValueKey("Favorite Food"),
                              maxLines: 1,
                              maxLength: 20,
                              initialValue: profiles[0].foodName,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Favorite Food',
                              ),
                              onChanged: (value) {
                                foodName = value;
                              },
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!alphabetsPattern.hasMatch(value)) {
                                    return 'Please enter valid food';
                                  }
                                }
                              },
                            ),
                            TextFormField(
                              key: const ValueKey(
                                  "Rate the food liking on scale of 10"),
                              maxLines: 1,
                              maxLength: 2,
                              initialValue: profiles[0].foodLikingIndex != null
                                  ? profiles[0].foodLikingIndex.toString()
                                  : "",
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Favorite Food Rate',
                              ),
                              onChanged: (value) {
                                favfoodIndex = int.tryParse(value);
                              },
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!digitsPattern.hasMatch(value)) {
                                    return 'Please enter only digits between 1 to 10';
                                  }
                                }
                              },
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 25,
                              thickness: 2,
                              indent: 5,
                              endIndent: 5,
                            ),
                            const Text("Favorite Activites"),
                            TextFormField(
                              key: const ValueKey("Favorite Activity"),
                              maxLines: 1,
                              maxLength: 20,
                              initialValue: profiles[0].activityName,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Favorite Activity',
                              ),
                              onChanged: (value) {
                                activityName = value;
                              },
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!alphabetsPattern.hasMatch(value)) {
                                    return 'Please enter valid activity';
                                  }
                                }
                              },
                            ),
                            TextFormField(
                              key: const ValueKey(
                                  "Rate the activity liking on scale of 10"),
                              maxLines: 1,
                              maxLength: 2,
                              initialValue: profiles[0].activityLikingIndex !=
                                      null
                                  ? profiles[0].activityLikingIndex.toString()
                                  : "",
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Favorite Activity Rate',
                              ),
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!digitsPattern.hasMatch(value)) {
                                    return 'Please enter only digits between 1 to 10';
                                  }
                                }
                              },
                              onChanged: (value) {
                                activityIndex = int.tryParse(value);
                              },
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 25,
                              thickness: 2,
                              indent: 5,
                              endIndent: 5,
                            ),
                            const Text("Skills"),
                            TextFormField(
                              key: const ValueKey("skillName"),
                              maxLines: 1,
                              maxLength: 20,
                              initialValue: profiles[0].skillName,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Skill Name',
                              ),
                              onChanged: (value) {
                                skillName = value;
                              },
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!alphabetsPattern.hasMatch(value)) {
                                    return 'Please enter valid skill';
                                  }
                                }
                              },
                            ),
                            TextFormField(
                              key: const ValueKey("skillProficiency"),
                              maxLines: 1,
                              maxLength: 20,
                              initialValue: profiles[0].skillProficiency,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Skill Proficiency',
                              ),
                              onChanged: (value) {
                                skillProficiency = value;
                              },
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!alphabetsPattern.hasMatch(value)) {
                                    return 'Please enter valid proficiency';
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final docId = profiles[0].id;
                                    final docProfile = FirebaseFirestore
                                        .instance
                                        .collection("profile")
                                        .doc(docId.toString());
                                    docProfile.update({
                                      'activityLikingIndex': activityIndex ??
                                          profiles[0].activityLikingIndex,
                                      'activityName': activityName ??
                                          profiles[0].activityName,
                                      'biography': bio ?? profiles[0].biography,
                                      'breed': breed ?? profiles[0].breed,
                                      'city': city ?? profiles[0].city,
                                      'color': color ?? profiles[0].color,
                                      'email': widget.email,
                                      'fName': fName ?? profiles[0].fName,
                                      'foodLikingIndex': favfoodIndex ??
                                          profiles[0].foodLikingIndex,
                                      'foodName':
                                          foodName ?? profiles[0].foodName,
                                      'gender': _gender ?? profiles[0].gender,
                                      'isFoodAggressive': _isFoodAggressive ??
                                          profiles[0].isFoodAggressive,
                                      'isSterilized': isSterilized ??
                                          profiles[0].isSterilized,
                                      'isNewDogAggressive': _isDogAggressive ??
                                          profiles[0].isNewDogAggressive,
                                      'isNewHumanAggressive':
                                          _isHumanAggressive ??
                                              profiles[0].isNewHumanAggressive,
                                      'isVaccinated': _isChecked ??
                                          profiles[0].isVaccinated,
                                      'joiningDate': profiles[0].joiningDate,
                                      'lName': lName ?? profiles[0].lName,
                                      'ownerfName':
                                          ownerfName ?? profiles[0].ownerfName,
                                      'ownerlName':
                                          ownerlName ?? profiles[0].ownerlName,
                                      'phone': phone ?? profiles[0].phone,
                                      'registrationDate':
                                          profiles[0].registrationDate,
                                      'size': size ?? profiles[0].size,
                                      'skillName':
                                          skillName ?? profiles[0].skillName,
                                      'skillProficiency': skillProficiency ??
                                          profiles[0].skillProficiency,
                                      'socialIndexDogs': socialDogs ??
                                          profiles[0].socialIndexDogs,
                                      'socialIndexHumans': socialHumans ??
                                          profiles[0].socialIndexHumans
                                    });
                                    context.pop();
                                  }
                                },
                                child: const Text('Submit'),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      const CircularProgressIndicator();

      return const LoginScreen();
    }
  }
}
