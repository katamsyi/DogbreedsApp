import 'package:flutter/material.dart';

class SaranKesan extends StatelessWidget {
  const SaranKesan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saran dan Kesan',
        ),
        backgroundColor: Color(0xffCEAB93),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                "Kesan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xffF5EBEB),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Pembelajaran selama mata kuliah teknologi pemrograman memberikan materi yang cukup update dengan teknik penyampaian materi yang cukup menyenangkan dan mudah untuk diikuti.",
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                "Saran",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xffF5EBEB),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Semoga pembelajaran teknologi dan pemrograman mobile semakin baik dan mengikuti perkembangan mobile ke depannya.",
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
