import 'package:flutter/material.dart';

import '../utils/session_manager.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  void _logout(BuildContext context) async {
    // Dialog konfirmasi logout
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red[600]),
              SizedBox(width: 8),
              Text("Konfirmasi Logout"),
            ],
          ),
          content: Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Batal", style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await SessionManager.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Bantuan & Dukungan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[600],
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
          ),
        ],
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
                        Icons.help_outline,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Kami siap membantu Anda",
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
                    "Pusat Bantuan",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20),

                  // FAQ Section
                  _buildHelpCard(
                    title: "Pertanyaan Umum (FAQ)",
                    subtitle:
                        "Temukan jawaban untuk pertanyaan yang sering diajukan",
                    icon: Icons.quiz_outlined,
                    color: Colors.blue,
                    onTap: () {
                      _showFAQDialog(context);
                    },
                  ),

                  SizedBox(height: 16),

                  // Panduan Penggunaan
                  _buildHelpCard(
                    title: "Panduan Penggunaan",
                    subtitle: "Pelajari cara menggunakan semua fitur aplikasi",
                    icon: Icons.menu_book_outlined,
                    color: Colors.green,
                    onTap: () {
                      _showPanduanDialog(context);
                    },
                  ),

                  SizedBox(height: 16),

                  // Hubungi Support
                  _buildHelpCard(
                    title: "Hubungi Support",
                    subtitle: "Dapatkan bantuan langsung dari tim support kami",
                    icon: Icons.support_agent_outlined,
                    color: Colors.orange,
                    onTap: () {
                      _showKontakDialog(context);
                    },
                  ),

                  SizedBox(height: 16),

                  // Tentang Aplikasi
                  _buildHelpCard(
                    title: "Tentang Pharma Care",
                    subtitle: "Informasi aplikasi dan versi terkini",
                    icon: Icons.info_outline,
                    color: Colors.purple,
                    onTap: () {
                      _showTentangDialog(context);
                    },
                  ),

                  SizedBox(height: 30),

                  // Tips penggunaan
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.amber[200]!, width: 1),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          color: Colors.amber[700],
                          size: 30,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Tips Penggunaan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Gunakan fitur pencarian dengan kata kunci yang spesifik untuk hasil yang lebih akurat. Selalu periksa tanggal kadaluarsa obat sebelum digunakan.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber[700],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Logout button alternatif
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.red[200]!, width: 1),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red[600],
                          size: 30,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Keluar Aplikasi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _logout(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              "Logout",
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFAQDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Pertanyaan Umum"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFAQItem("Bagaimana cara mencari obat?",
                    "Gunakan fitur 'Cari Data Obat' di halaman utama dan masukkan nama obat yang ingin dicari."),
                _buildFAQItem("Apakah data obat selalu update?",
                    "Ya, database obat kami selalu diperbarui untuk memberikan informasi terkini."),
                _buildFAQItem("Bagaimana cara cek interaksi obat?",
                    "Pilih menu 'Cek Interaksi Obat' dan masukkan nama-nama obat yang ingin diperiksa."),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  void _showPanduanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Panduan Penggunaan"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("1. Untuk mencari obat, gunakan menu 'Cari Data Obat'"),
                SizedBox(height: 8),
                Text(
                    "2. Untuk cek interaksi, gunakan menu 'Cek Interaksi Obat'"),
                SizedBox(height: 8),
                Text(
                    "3. Selalu konsultasikan dengan dokter untuk penggunaan obat"),
                SizedBox(height: 8),
                Text(
                    "4. Gunakan fitur saran untuk memberikan masukan kepada kami"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  void _showKontakDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Hubungi Support"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text("Email"),
                subtitle: Text("support@PharmaCare.com"),
              ),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.green),
                title: Text("WhatsApp"),
                subtitle: Text("+62 123 4567 8900"),
              ),
              ListTile(
                leading: Icon(Icons.schedule, color: Colors.orange),
                title: Text("Jam Layanan"),
                subtitle: Text("Senin - Jumat, 08:00 - 17:00 WIB"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  void _showTentangDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Tentang Pharma Care"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.medical_services, size: 50, color: Colors.teal[600]),
              SizedBox(height: 16),
              Text("PharmaCare v1.0.0",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                  "Aplikasi pencarian informasi obat dan pengecekan interaksi obat yang aman dan terpercaya."),
              SizedBox(height: 16),
              Text("© 2024 PharmaCare Team",
                  style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
