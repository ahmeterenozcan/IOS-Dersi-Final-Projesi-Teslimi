import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogGalleryPage extends StatefulWidget {
  final String blogId;

  const BlogGalleryPage({required this.blogId, Key? key}) : super(key: key);

  @override
  _BlogGalleryPageState createState() => _BlogGalleryPageState();
}

class _BlogGalleryPageState extends State<BlogGalleryPage> {
  List<Map<String, String>> gallery = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchGalleryImages();
  }

  Future<void> fetchGalleryImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Blogs')
          .doc(widget.blogId)
          .collection('gallery')
          .get();

      setState(() {
        gallery = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'GalleryImage': data['GalleryImage']?.toString() ?? '',
            'Location': data['Location']?.toString() ?? '',
          };
        }).toList();
      });
    } catch (e) {
      print("Galeri verileri çekilemedi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Arka plan gradyan renk
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink.shade100,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Scaffold arka planı şeffaf olsun
        appBar: AppBar(
          title: const Text(
            "Resim Galerisi",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.pink,
        ),
        body: gallery.isNotEmpty
            ? Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: gallery.length,
                itemBuilder: (context, index) {
                  final image = gallery[index];
                  return GestureDetector(
                    onTap: () {
                      // Tıklanınca bir sonraki sayfaya geçiş yap
                      if (index < gallery.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubic,
                        );
                      } else {
                        // Son resimse başa dön
                        _pageController.jumpToPage(0);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 20.0),
                      child: Material(
                        // Görsel efektler
                        color: Colors.white,
                        elevation: 8.0,
                        shadowColor: Colors.pinkAccent.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Stack(
                            children: [
                              // Resim
                              Positioned.fill(
                                child: Image.network(
                                  image['GalleryImage']!,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.broken_image,
                                        size: 80,
                                        color: Colors.redAccent,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Alttaki koyu şerit ve konum metni
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black87,
                                        Colors.black54,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    image['Location']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Sayfa Göstergesi
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  gallery.length,
                      (index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double selected = 0.5; // default
                        if (_pageController.hasClients) {
                          final page = _pageController.page ?? 0;
                          selected = (page.round() == index) ? 1.0 : 0.4;
                        }
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 4.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: selected == 1.0 ? 12 : 8,
                            height: selected == 1.0 ? 12 : 8,
                            decoration: BoxDecoration(
                              color: Colors.pink.withOpacity(selected),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
