import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'blog_gallery_page.dart';

class BlogDetailPage extends StatefulWidget {
  final String baslik;
  final String blogImage;
  final String aciklama;
  final String blogId;

  const BlogDetailPage({
    required this.baslik,
    required this.blogImage,
    required this.aciklama,
    required this.blogId,
  });

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  String? videoUrl;

  // Hava durumu değişkenleri
  String? cityName; // Firestore'daki sehir alanından gelecek
  double? temperature;
  String? weatherDescription;
  String? weatherIconUrl;

  @override
  void initState() {
    super.initState();
    _fetchBlogDataFromFirestore();
  }

  /// Firestore'dan şehir ve videoUrl gibi blog verilerini çekiyoruz.
  Future<void> _fetchBlogDataFromFirestore() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Blogs')
          .doc(widget.blogId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          // 'sehir' alanını alıyoruz
          cityName = data['sehir'] ?? 'Istanbul';
          // 'VideoUrl' alanını alıyoruz
          videoUrl = data['VideoUrl'];

          // Ekranı yenile (state'i güncelle)
          setState(() {});

          // Blog verisi geldikten sonra hava durumu çekme fonksiyonunu çağırıyoruz
          if (cityName != null) {
            _fetchWeatherData(cityName!);
          }
        }
      } else {
        print("Firestore belgesi bulunamadı.");
      }
    } catch (e) {
      print("Firestore'dan veri çekilirken hata oluştu: $e");
    }
  }

  /// OpenWeatherMap API'sinden hava durumu verisini çek
  Future<void> _fetchWeatherData(String city) async {
    try {
      // Burada kendi API keyim
      const String apiKey = "cf090882e2b70c1a104f326ed7252cd4";

      // Şehir ismi ile API isteği
      final String url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&lang=tr&appid=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // JSON parse
        final data = json.decode(response.body);
        final double temp = data["main"]["temp"]?.toDouble() ?? 0.0;
        final String desc = data["weather"][0]["description"];
        final String icon = data["weather"][0]["icon"];

        // OpenWeatherMap ikon adresleri
        final String iconUrl = "http://openweathermap.org/img/wn/$icon@2x.png";

        setState(() {
          temperature = temp;
          weatherDescription = desc;
          weatherIconUrl = iconUrl;
        });
      } else {
        print("Hava durumu API hatası: ${response.statusCode}");
      }
    } catch (e) {
      print("Hava durumu çekilirken hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.baslik),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Blog Görseli
            Image.network(
              widget.blogImage,
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
            ),
            const SizedBox(height: 20),

            // Galeri Butonu
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogGalleryPage(blogId: widget.blogId),
                    ),
                  );
                },
                icon: const Icon(Icons.photo_library),
                label: const Text("Galeriye Git"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              ),
            ),

            // Açıklama
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.aciklama.replaceAll('\\n', '\n'),
                style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
            ),

            // Video Gösterimi
            if (videoUrl != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: Colors.pink, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: HtmlWidget(
                      '''
                      <iframe width="100%" height="250"
                          src="$videoUrl"
                          frameborder="0"
                          allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                          allowfullscreen>
                      </iframe>
                      ''',
                    ),
                  ),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "Video mevcut değil.",
                    style: TextStyle(fontSize: 16, color: Colors.redAccent),
                  ),
                ),
              ),

            // Hava Durumu Bilgisi
            if (temperature != null && weatherDescription != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.pink.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.pink.shade300, width: 1),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // İkon
                        if (weatherIconUrl != null)
                          Image.network(
                            weatherIconUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(width: 16),
                        // Sıcaklık + açıklama
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$cityName Hava Durumu",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${temperature?.toStringAsFixed(1)} °C",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              weatherDescription!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text("Hava durumu bilgisi yükleniyor..."),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
