import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _userEmail = TextEditingController();

  void _addUser() {
    String name = '';
    String email = '';
    final _emailFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Form(
            key: _emailFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Add New User',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _userEmail,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                      // todo : login ID should only be @utu.ac.in
                    } else if (!value.endsWith("@utu.ac.in") && false) {
                      return 'Please Enter a valid UTU Account';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final email = _userEmail.text.trim();
                        log("${email}");
                        if (email.endsWith('@utu.ac.in') || true) {
                          // Email is valid, add user
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(email)
                              .set({
                            "name": _username.text.trim(),
                            "email": email,
                          }).then((e) {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //     duration: Duration(milliseconds: 1500),
                            //     content: Text("User Added Successfully")));
                            // Navigator.pop(context);
                            Navigator.pop(context);
                            _username.clear();
                            _userEmail.clear();
                            Get.snackbar(
                              "Success",
                              "User Added successfully",
                              duration: Duration(milliseconds: 1500),
                            );
                          });
                        } else {
                          Get.snackbar(
                            "Invalid",
                            "Please enter a valid UTU Account",
                            duration: Duration(milliseconds: 1500),
                          );

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     duration: Duration(milliseconds: 1500),
                          //     content: Text('Please enter a valid UTU Account'),
                          //   ),
                          // );
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete the user with email $email?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Delete'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(email)
                    .delete()
                    .whenComplete(() => Navigator.pop(context));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _addUser,
      //   child: const Icon(Icons.add),
      // ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  height: 100.0,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "User's List",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                getCurrentDate(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 16.0,
                        child: ElevatedButton.icon(
                          onPressed: _addUser,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.blue,
                          ),
                          label: const Text(
                            'Add User',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEAF4FF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18.0),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white, // Same background color
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 18.0),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16.0), // Rounded edges like customCard
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${data[index]['name']}',
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.black45,
                                          ),
                                          onPressed: () {
                                            _confirmDelete(data[index]['email']
                                                .toString());
                                          },
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.grey[200],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      '${data[index]['email']}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            /*return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: ListTile(
                                title: Text('${data[index]['name']}'),
                                subtitle: Text(
                                  '${data[index]['email']}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.black45,
                                  onPressed: () {
                                    _confirmDelete(data[index]['email'].toString());
                                  },
                                ),
                              ),
                            );*/
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(now);
  }
}
