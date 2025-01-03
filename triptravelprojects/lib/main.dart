import 'package:flutter/material.dart';
import 'about.dart';
import 'iletisim.dart';
import 'home.dart';
import 'blog.dart';
import 'blog_detail_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: Text(
        "Bir şeyler ters gitti!",
        style: TextStyle(color: Colors.red),
      ),
    );
  };
  runApp(EasyTripApp());
}

class EasyTripApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AEO Seyahat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    AboutPage(),
    BlogPage(),
    ContactPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        title: Text('AEO Seyahat'),
        backgroundColor: Colors.pink,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Hakkımızda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Bloğum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'İletişim',
          ),
        ],
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black45,
        backgroundColor: Colors.lightGreen[50],
      ),
    );
  }
}
