import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Data profil
  final List<Map<String, String>> profiles = const [
    {
      'nama': 'Panji Arif JR',
      'nim': '123220091',
      'email': 'panji@gmail.com',
      'nomorHP': '0838-xxxx-xxxx',
      'alamat': 'Surokarsa MGII/538, Yogyakarta',
      'status': 'Mahasiswa Informatika',
      'jurusan': 'Teknik Informatika',
      'foto': 'assets/images/profile.jpg',
    },
    // {
    //   'nama': 'Josua Waruwu',
    //   'nim': '123220083',
    //   'email': 'josua@gmail.com',
    //   'nomorHP': '0812-xxxx-xxxx',
    //   'alamat': 'Medan Kota, Sumatera Utara',
    //   'status': 'Mahasiswa Informatika',
    //   'jurusan': 'Teknik Informatika',
    //   'foto': 'assets/images/Me.jpg',
    // },
    // tambahkan data baru untuk membuat card profile baru
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Profil Developer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[600],
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan gradient
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.teal[600]!, Colors.teal[400]!],
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
                      Icon(
                        Icons.people_outline,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Tim Pengembang Pharma Care",
                        style: TextStyle(
                          color: Colors.white,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profil Developer",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20),

                  // List Profil Cards
                  ...profiles.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, String> profile = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _buildProfileCard(context, profile, index),
                    );
                  }).toList(),

                  SizedBox(height: 20),

                  // Info tambahan
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue[200]!, width: 1),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          color: Colors.blue[600],
                          size: 30,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'UPN "Veteran" Yogyakarta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Fakultas Teknik Industri\nProgram Studi Informatika",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[600],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      BuildContext context, Map<String, String> profile, int index) {
    // Warna untuk setiap card
    List<Color> cardColors = [
      Colors.indigo,
      const Color.fromARGB(255, 176, 89, 39),
      Colors.orange,
    ];
    Color cardColor = cardColors[index % cardColors.length];

    return Card(
      elevation: 8,
      shadowColor: cardColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _showProfileDetail(context, profile, cardColor),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardColor.withOpacity(0.1),
                cardColor.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border:
                      Border.all(color: cardColor.withOpacity(0.3), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: profile['foto'] != null && profile['foto']!.isNotEmpty
                      ? Image.asset(
                          profile['foto']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback ke inisial jika gambar error
                            return Container(
                              color: cardColor.withOpacity(0.2),
                              child: Center(
                                child: Text(
                                  profile['nama']!
                                      .split(' ')
                                      .map((word) => word[0])
                                      .take(2)
                                      .join(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: cardColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: cardColor.withOpacity(0.2),
                          child: Center(
                            child: Text(
                              profile['nama']!
                                  .split(' ')
                                  .map((word) => word[0])
                                  .take(2)
                                  .join(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: cardColor,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 16),

              // Info dasar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile['nama']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "NIM: ${profile['nim']!}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        profile['status']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: cardColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Icon panah
              Icon(
                Icons.arrow_forward_ios,
                color: cardColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileDetail(
      BuildContext context, Map<String, String> profile, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withOpacity(0.1),
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header dialog
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: color.withOpacity(0.3), width: 3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child:
                        profile['foto'] != null && profile['foto']!.isNotEmpty
                            ? Image.asset(
                                profile['foto']!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: color.withOpacity(0.2),
                                    child: Center(
                                      child: Text(
                                        profile['nama']!
                                            .split(' ')
                                            .map((word) => word[0])
                                            .take(2)
                                            .join(),
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: color,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: color.withOpacity(0.2),
                                child: Center(
                                  child: Text(
                                    profile['nama']!
                                        .split(' ')
                                        .map((word) => word[0])
                                        .take(2)
                                        .join(),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ),
                  ),
                ),
                SizedBox(height: 16),

                Text(
                  profile['nama']!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Detail informasi
                Column(
                  children: [
                    _buildDetailItem(
                        Icons.badge_outlined, 'NIM', profile['nim']!, color),
                    _buildDetailItem(Icons.email_outlined, 'Email',
                        profile['email']!, color),
                    _buildDetailItem(Icons.phone_outlined, 'No. HP',
                        profile['nomorHP']!, color),
                    _buildDetailItem(Icons.location_on_outlined, 'Alamat',
                        profile['alamat']!, color),
                    _buildDetailItem(Icons.school_outlined, 'Jurusan',
                        profile['jurusan']!, color),
                  ],
                ),

                SizedBox(height: 24),

                // Tombol tutup
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Tutup",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(
      IconData icon, String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
