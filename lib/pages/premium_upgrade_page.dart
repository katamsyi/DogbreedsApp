import 'package:flutter/material.dart';
import 'convert.dart'; // Import halaman convert Anda - sesuaikan path jika berbeda

class PremiumUpgradePage extends StatelessWidget {
  const PremiumUpgradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Upgrade Premium',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xffAD8B73),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            
            // Premium Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xffCEAB93),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.diamond,
                size: 60,
                color: Colors.white,
              ),
            ),
            
            SizedBox(height: 30),
            
            // Title
            Text(
              'Upgrade ke Premium!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xffAD8B73),
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 15),
            
            // Subtitle
            Text(
              'Nikmati fitur convert mata uang tanpa batas dengan akurasi real-time',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 40),
            
            // Features List
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildFeatureItem(
                    icon: Icons.currency_exchange,
                    title: 'Konversi Real-time',
                    description: 'Nilai tukar mata uang yang selalu update',
                  ),
                  SizedBox(height: 20),
                  _buildFeatureItem(
                    icon: Icons.trending_up,
                    title: 'Lebih Banyak Mata Uang',
                    description: 'Akses ke 100+ mata uang dunia',
                  ),
                  SizedBox(height: 20),
                  _buildFeatureItem(
                    icon: Icons.history,
                    title: 'Riwayat Konversi',
                    description: 'Simpan dan lihat riwayat konversi Anda',
                  ),
                  SizedBox(height: 20),
                  _buildFeatureItem(
                    icon: Icons.notifications_off,
                    title: 'Tanpa Iklan',
                    description: 'Pengalaman bebas gangguan iklan',
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40),
            
            // Price
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xffAD8B73),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    'Hanya',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Rp 29.000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'per bulan',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      // Navigate langsung ke ConvertPage ketika user mau upgrade
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConvertPage(),
                        ),
                      );
                    },
                    height: 50,
                    color: Color(0xffAD8B73),
                    child: Text(
                      "Ya, Saya Mau!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    height: 50,
                    color: Colors.grey[300],
                    child: Text(
                      "Nanti Saja",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Skip option
            TextButton(
              onPressed: () {
                // Navigate ke ConvertPage dengan fitur terbatas
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConvertPage(),
                  ),
                );
              },
              child: Text(
                'Lewati dan gunakan versi gratis',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xffCEAB73).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Color(0xffAD8B73),
            size: 24,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffAD8B73),
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}