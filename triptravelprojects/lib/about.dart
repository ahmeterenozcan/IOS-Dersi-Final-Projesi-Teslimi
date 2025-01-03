import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.teal[50], // Başlık ve etrafındaki alan için arka plan rengi
            width: double.infinity, // Kenarları kaplayacak genişlik
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'Hakkımızda!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://cdn.basedlabs.ai/abb6f4f0-6f61-4487-b0fc-1b539700793a.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Merhaba, ben Ahmet Eren! Seyahat etmeyi, '
                  'yeni yerler keşfetmeyi ve farklı kültürlerle tanışmayı seven bir gezginim. '
                  'Hayatımın en güzel anlarının yeni şehirlerde geçirdiğim zamanlarda olduğunu düşünüyorum. '
                  'Her yolculuk, bana sadece yeni manzaralar değil, '
                  'aynı zamanda yeni deneyimler, dostluklar ve unutulmaz anılar kazandırıyor. '
                  'Haydi, birlikte keşfe çıkalım! '
                  'Bu yolculukta bana katılın, deneyimlerimizi paylaşalım ve dünyanın güzelliklerini birlikte keşfedelim. '
                  'Seyahat etmenin sunduğu heyecanı, merak duygusunu ve keşfetmenin getirdiği mutluluğu yaşamak için buradayım. '
                  'Hoş geldiniz!',
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
