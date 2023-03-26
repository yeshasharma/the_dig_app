import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:the_dig_app/models/profile.dart';
import 'package:the_dig_app/providers/dig_firebase_provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  DateTime _selectedDate = DateTime.now();
  final gender = ['Male', 'Female'];
  bool _isVaccinated = false;
  final size = ['Small', 'Medium', 'Large'];

  Future<void> _dateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2000),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    if (picked != null)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        _selectedDate = picked;
        _registrationDateController.text =
            DateFormat.yMd().format(_selectedDate);
      });
  }

  String? _errorMessage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _ownerFNameController = TextEditingController();
  final TextEditingController _ownerLNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _registrationDateController =
      TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  _register() async {
    try {
      final provider = Provider.of<DigFirebaseProvider>(context, listen: false);
      final int userId = UniqueKey().hashCode;
      final int ownerId = UniqueKey().hashCode;
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (credentials.user != null && !credentials.user!.emailVerified) {
        credentials.user!.sendEmailVerification();
        await provider
            .createProfile(
                Profile(
                    id: userId,
                    token: "",
                    ownerId: ownerId,
                    ownerfName: _ownerFNameController.text,
                    ownerlName: _ownerLNameController.text,
                    email: _emailController.text,
                    phone: int.parse(_phoneController.text),
                    city: _cityController.text,
                    ownerprofilePicture: "",
                    fName: _fNameController.text,
                    lName: _lNameController.text,
                    profilePicture: "",
                    gender: _genderController.text,
                    breed: _breedController.text,
                    color: _colorController.text,
                    isVaccinated: _isVaccinated,
                    registrationDate:
                        _registrationDateController.text.isNotEmpty
                            ? _registrationDateController.text
                            : DateTime.now().toString(),
                    joiningDate: DateTime.now().toString(),
                    size: _sizeController.text),
                userId.toString())
            .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'User with email ${_emailController.text} is created successfully')));
            })
            .then((value) => provider.checkFirebaseAuth())
            .then((value) =>
                context.push('/profiles?email=${_emailController.text}'))
            .catchError((error) {
              debugPrint('Update failed: $error');
            });
      }
    } on FirebaseAuthException catch (e) {
      setState(() => {_errorMessage = _registrationErrorMessage(e.code)});
    }
  }

  _registrationErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered with us';
      case 'weak-password':
        return 'The password must be at least eight characters long';
      case 'invalid-email':
        return 'Invalid email address format';
      default:
        return 'Facing issues right now, please try again later';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Icon(
          Icons.pets_outlined,
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 25),
                      child: Text(
                        'Your Credentials',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextFormField(
                      maxLines: 1,
                      maxLength: 40,
                      controller: _emailController,
                      inputFormatters: [LengthLimitingTextInputFormatter(40)],
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email address';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        labelText: 'Email address',
                        hintText: 'Enter Email address',
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      maxLines: 1,
                      maxLength: 15,
                      controller: _passwordController,
                      inputFormatters: [LengthLimitingTextInputFormatter(15)],
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose a password';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        labelText: 'Choose a Password',
                        hintText: 'Enter Password',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 25),
                      child: Text(
                        'About our furry friend',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            maxLines: 1,
                            maxLength: 40,
                            controller: _fNameController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(40)
                            ],
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter First Name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: 'First Name',
                              hintText: 'Enter First Name',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                        Flexible(
                          child: TextFormField(
                            maxLines: 1,
                            maxLength: 40,
                            controller: _lNameController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(40)
                            ],
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Last Name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: 'Last Name',
                              hintText: 'Enter Last Name',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            maxLines: 1,
                            maxLength: 40,
                            controller: _colorController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(40)
                            ],
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter color';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: 'Color',
                              hintText: 'Enter Color',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                        Flexible(
                          child: TextFormField(
                            maxLines: 1,
                            maxLength: 40,
                            controller: _breedController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(40)
                            ],
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Last Name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: 'Breed',
                              hintText: 'Enter Breed',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a value';
                              }
                              return null;
                            },
                            items: gender
                                .map(((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    )))
                                .toList(),
                            onChanged: (value) {
                              _genderController.text = value as String;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: 'Gender',
                              hintText: 'Enter Gender',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                        Flexible(
                          child: TextFormField(
                            onTap: () => _dateSelector(context),
                            controller: TextEditingController(
                              text: _selectedDate.isBefore(
                                      DateTime(2000, 1, 1, 0, 0, 0, 0, 0))
                                  ? ''
                                  : DateFormat('yyyy-MM-dd')
                                      .format(_selectedDate),
                            ),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: 'Registration Date',
                              hintText: 'Enter Registration Date',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          child: CheckboxListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 2.5, bottom: 2.5),
                            title: const Text('Is Vaccinated?'),
                            value: _isVaccinated,
                            onChanged: (isVaccinated) {
                              setState(() {
                                _isVaccinated = isVaccinated!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                        Flexible(
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a value';
                              }
                              return null;
                            },
                            items: size
                                .map(((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    )))
                                .toList(),
                            onChanged: (value) {
                              _sizeController.text = value as String;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: 'Size',
                              hintText: 'Enter Size',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 25),
                      child: Text(
                        'About the owner',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            maxLines: 1,
                            maxLength: 40,
                            controller: _ownerFNameController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(40)
                            ],
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter First Name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: ' First Name',
                              hintText: 'Enter First Name',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                        Flexible(
                          child: TextFormField(
                            maxLines: 1,
                            maxLength: 40,
                            controller: _ownerLNameController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(40)
                            ],
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Last Name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: 'Last Name',
                              hintText: 'Enter Last Name',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            maxLines: 1,
                            maxLength: 20,
                            controller: _cityController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                            ],
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter City Name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: 'City',
                              hintText: 'Enter City',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                        Flexible(
                          child: TextFormField(
                            maxLines: 1,
                            maxLength: 10,
                            controller: _phoneController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Phone Number';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: 'Phone Number',
                              hintText: 'Enter Phone Number',
                            ),
                          ),
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width) * 0.02),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                          (MediaQuery.of(context).size.width).toDouble() *
                              0.07),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _register();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blue, // set the button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // set the button shape
                                ),
                              ),
                              child: Text(
                                'Register',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ]),
                    ),
                    Text(
                      _errorMessage ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
