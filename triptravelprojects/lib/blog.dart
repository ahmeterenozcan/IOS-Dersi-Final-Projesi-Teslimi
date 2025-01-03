import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'blog_detail_page.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<Map<String, dynamic>> blogs = [];
  List<String> blogIds = []; // Blog ID'lerini tutmak için liste

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('Blogs').get();
      final List<Map<String, dynamic>> fetchedBlogs = [];
      final List<String> ids = [];

      for (var doc in snapshot.docs) {
        fetchedBlogs.add({
          'Baslik': doc['Baslik'] ?? 'Başlık Yok',
          'BlogImage': doc['BlogImage'] ?? '',
          'Aciklama': doc['Aciklama'] ?? 'Açıklama Yok',
        });
        ids.add(doc.id); // Blog ID'lerini listeye ekliyoruz
      }

      setState(() {
        blogs = fetchedBlogs;
        blogIds = ids;
      });
    } catch (e) {
      print('Firebase verileri çekilemedi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloglar', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: blogs.isNotEmpty
          ? ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          final blog = blogs[index];
          return GestureDetector(
            onTap: () {
              // Blog ID'sini BlogDetailPage'e gönderiyoruz
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetailPage(
                    baslik: blog['Baslik'],
                    blogImage: blog['BlogImage'],
                    aciklama: blog['Aciklama'],
                    blogId: blogIds[index], // Blog ID'sini gönderiyoruz
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Blog Resmi
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      child: blog['BlogImage'].isNotEmpty
                          ? Image.network(
                        blog['BlogImage'],
                        height: 200,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        height: 200,
                        color: Colors.grey,
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
                    // Blog Başlığı
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        blog['Baslik'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
