import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> imageUrls = [];
  PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchImages() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('Blogs').get();
      final List<String> fetchedImageUrls = snapshot.docs.map((doc) {
        return doc['BlogImage'] as String;
      }).toList();

      setState(() {
        imageUrls = fetchedImageUrls;
      });
    } catch (e) {
      print('Firebase verileri çekilemedi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kolayca Seyahat Et'),
        centerTitle: true,
      ),
      body: imageUrls.isNotEmpty
          ? Column(
        children: [
          // Slider Bölümü
          Expanded(
            flex: 4,
            child: PageView.builder(
              controller: _pageController,
              itemCount: imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (index < imageUrls.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _pageController.jumpToPage(0);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image,
                                size: 50, color: Colors.red);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Slider Altındaki Noktalar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageUrls.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  _pageController.jumpToPage(entry.key);
                },
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == entry.key
                        ? Colors.blueAccent
                        : Colors.grey,
                  ),
                ),
              );
            }).toList(),
          ),
          // Yazı Bölümü
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Tatil Seyahat Bloguma Hoşgeldiniz',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Hoş geldiniz! Seyahat bloguma adım attığınız için çok mutluyum. '
                        'Bu alanda, dünyayı keşfederken yaşadığım deneyimleri, gözlemlerimi '
                        've tavsiyelerimi sizlerle paylaşacağım.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
