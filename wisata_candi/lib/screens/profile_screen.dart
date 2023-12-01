import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:wisata_candi/widget/profile_info_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSignedIn = false;
  String fullName = '';
  String userName = '';
  int favoriteCandiCount = 0;
  late Color iconColor;

  // Fungsi untuk mendapatkan dan mendekripsi data pengguna dari SharedPreferences
  Future<void> _getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final keyString = prefs.getString('key') ?? '';
    final ivString = prefs.getString('iv') ?? '';

    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encryptedName = prefs.getString('fullname') ?? '';
    final encryptedUsername = prefs.getString('username') ?? '';

    if (encryptedName.isNotEmpty && encryptedUsername.isNotEmpty) {
      fullName = encrypter.decrypt64(encryptedName, iv: iv);
      userName = encrypter.decrypt64(encryptedUsername, iv: iv);
    }

    // Mendapatkan nilai isSignedIn dan favoriteCandiCount
    setState(() {
      isSignedIn = prefs.getBool('isSignedIn') ?? false;
      favoriteCandiCount = prefs.getInt('favoriteCandiCount') ?? 0;
    });
  }

  // Fungsi untuk sign out
  Future<void> _signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mengosongkan nilai-nila di SharedPreferences
    prefs.setBool('isSignedIn', false);
    prefs.setString('fullname', '');
    prefs.setString('username', '');
    prefs.setString('password', '');
    prefs.setInt('favoriteCandiCount', 0);

    // Memanggil fungsi untuk mendapatkan dan mendekripsi data pengguna
    await _getUserData();
  }

  // Fungsi untuk edit fullName
  Future<void> _editFullName(String newName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final keyString = prefs.getString('key') ?? '';
    final ivString = prefs.getString('iv') ?? '';
    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encryptedName = encrypter.encrypt(newName, iv: iv);

    // Menyimpan nilai fullName yang baru di SharedPreferences
    prefs.setString('fullname', encryptedName.base64);

    // Memanggil fungsi untuk mendapatkan dan mendekripsi data pengguna
    await _getUserData();
  }

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi untuk mendapatkan dan mendekripsi data pengguna saat inisialisasi widget
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.amber,
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 200 - 50),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.deepPurple, width: 2),
                            shape: BoxShape.circle),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('images/placeholder_image.png'),
                        ),
                      ),
                      if (isSignedIn)
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.deepPurple,
                            ))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.deepPurple[100],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ProfileInfoItem(
                      icon: Icons.lock,
                      label: 'User',
                      value: userName,
                      iconColor: Colors.amber,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Divider(
                      color: Colors.deepPurple[100],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ProfileInfoItem(
                        icon: Icons.person,
                        label: 'Nama',
                        value: fullName,
                        showEditIcon: isSignedIn,
                        onEditPressed: () async {
                          // Menampilkan dialog untuk memasukkan nama baru
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Edit Nama'),
                                content: TextField(
                                  onChanged: (newName) {
                                    fullName = newName;
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Nama Baru'),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Memanggil fungsi untuk edit fullName
                                      await _editFullName(fullName);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Simpan'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        iconColor: Colors.blue),
                    const SizedBox(
                      height: 5,
                    ),
                    Divider(
                      color: Colors.deepPurple[100],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ProfileInfoItem(
                        icon: Icons.favorite,
                        label: 'Favorit',
                        value:
                            favoriteCandiCount > 0 ? '$favoriteCandiCount' : '',
                        iconColor: Colors.red),
                    const SizedBox(
                      height: 5,
                    ),
                    Divider(
                      color: Colors.deepPurple[100],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (isSignedIn)
                      TextButton(
                        onPressed: () async {
                          // Memanggil fungsi untuk sign out
                          await _signOut();
                        },
                        child: const Text('Sign Out'),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.all(20),
                            elevation: 5),
                      )
                    else
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: const Text('Sign In'),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.all(20),
                            elevation: 5),
                      )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
