import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İletişim'),
        backgroundColor: Colors.teal[700],
      ),
      body: Container(
        color: Colors.teal[50], // Açık bir arka plan rengi seçin
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Icon(
                Icons.person_pin_circle,
                color: Colors.teal[300],
                size: 100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Traveler Ahmet Eren',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            SizedBox(height: 20),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.instagram,
                color: Colors.teal[700], // Instagram simgesi için rengi değiştirin
              ),
              title: Text(
                'Instagram',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              subtitle: Text(
                'ahmet.eren.ozcan',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.email,
                color: Colors.teal[700], // Mail simgesi için rengi değiştirin
              ),
              title: Text(
                'Email',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              subtitle: Text(
                'traveleraeo33@gmail.com',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                'Herhangi bir sorunuz veya işbirliği öneriniz varsa, benimle iletişime geçmekten çekinmeyin. Keyifli yolculuklar!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
