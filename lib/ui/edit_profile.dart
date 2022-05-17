import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/user_provider.dart';
import '../models/user.dart';
import '../utils/screenSizes.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  static const routeName = '/editPage';

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _showDialog(
    String title,
    String message,
    BuildContext context,
  ) async {
    bool isAndroid = Platform.isAndroid;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if (isAndroid) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          } else {
            return CupertinoAlertDialog(
              title: Text(title, style: Theme.of(context).textTheme.labelLarge),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message,
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/welcome', (route) => false);
                  },
                ),
              ],
            );
          }
        });
  }

  String name = '';
  String bio = '';
  String email = '';
  late bool publicAccount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final User user = userProvider.user!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: ClipOval(
                          child: Image.network(
                            user.profilePictureUrl ??
                                'https://image.winudf.com/v2/image1/Y29tLmZpcmV3aGVlbC5ibGFja3NjcmVlbl9zY3JlZW5fMF8xNTgyNjgwMjgzXzA2MQ/screen-0.jpg?fakeurl=1&type=.jpg',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        radius: 40,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                          width: screenWidth(context, dividedBy: 1.2),
                          child: TextFormField(
                              initialValue: user.name,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                label: Row(
                                  children: const [
                                    Text('Name'),
                                  ],
                                ),
                                labelStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white12,
                                  ),
                                ),
                              ),
                              onSaved: (value) {
                                name = value ?? user.name;
                              }),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                          width: screenWidth(context, dividedBy: 1.2),
                          child: TextFormField(
                            initialValue: user.bio,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              label: Row(
                                children: const [
                                  Text('Bio'),
                                ],
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white12,
                                ),
                              ),
                            ),
                            onSaved: (value) {
                              bio = value ?? user.bio ?? '';
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                          width: screenWidth(context, dividedBy: 1.2),
                          child: TextFormField(
                            initialValue: user.email,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              label: Row(
                                children: const [
                                  Text('E-Mail'),
                                ],
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white12,
                                ),
                              ),
                            ),
                            onSaved: (value) {
                              email = value ?? user.email;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                          width: screenWidth(context, dividedBy: 1.2),
                          child: FormField(
                            initialValue: user.publicAccount,
                            onSaved: (value) {
                              publicAccount = value as bool;
                            },
                            builder: (FormFieldState<bool> field) {
                              return SwitchListTile(
                                title: const Text('Public Account'),
                                value: field.value!,
                                onChanged: (val) {
                                  field.didChange(val);
                                },
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                              child: OutlinedButton(
                                onPressed: () {
                                  _showDialog(
                                    'Deactivate Account',
                                    'Are you sure?',
                                    context,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                  ),
                                  child: Text(
                                    'Deactivate Account',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text(
                                    'Cancel',
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white70,
                                )),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                _formKey.currentState!.save();
                                userProvider.updateUser(
                                  user.copyWith(
                                    name: name,
                                    bio: bio,
                                    email: email,
                                    publicAccount: publicAccount,
                                  ),
                                );
                                Navigator.pop(context);
                                //Navigator.push(context, MaterialPageRoute(builder:(context)=>ProfileView( )));
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  'Save',
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
