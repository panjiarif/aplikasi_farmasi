import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _passwordHashController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Pastikan user di-load dari SharedPreferences
    await userProvider.loadUser();
    final user = userProvider.user;

    // Inisialisasi controller
    _usernameController = TextEditingController(text: user?.username ?? '');
    _passwordHashController =
        TextEditingController(); //place holder biarkan kosong

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordHashController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final updatedUser = UserModel(
        id: userProvider.user?.id,
        username: _usernameController.text.trim(),
        passwordHash: _passwordHashController.text.trim(),
      );

      // Simpan ke SharedPreferences melalui provider
      await userProvider.updateUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profil Pengguna',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[50],
            ),
          ),
          backgroundColor: Colors.amber[600],
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.grey[50]),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Profil Pengguna',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[50],
          ),
        ),
        backgroundColor: Colors.amber[600],
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey[50]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.amber[600]!, Colors.amber[400]!],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 40, color: Colors.grey[50]),
                      SizedBox(height: 8),
                      Text(
                        "Edit profil akun Anda",
                        style: TextStyle(
                          color: Colors.grey[50],
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon:
                            Icon(Icons.person, color: Colors.amber[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Username tidak boleh kosong'
                          : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordHashController,
                      decoration: InputDecoration(
                        labelText:
                            'Password (kosongkan jika tidak diubah)',
                        prefixIcon: Icon(Icons.lock, color: Colors.amber[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: true,
                      // Tidak ada validator agar boleh kosong
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _saveProfile,
                      icon: Icon(Icons.save),
                      label: Text('Simpan Perubahan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[600],
                        foregroundColor: Colors.grey[50],
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
