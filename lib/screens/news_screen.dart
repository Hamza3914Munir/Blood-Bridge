import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../common/colors.dart';
import '../utils/tools.dart';
import '../widgets/news_tile.dart';

class NewsScreen extends StatelessWidget {
  static const route = 'news';
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final news = FirebaseFirestore.instance.collection('news');

    return Scaffold(
      appBar: AppBar(title: const Text('News and Tips')),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: news.orderBy('date', descending: true).limit(20).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(MainColors.primary),
                ),
              );
            }
            final List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs =
                snapshot.data?.docs;

            if (docs == null || docs.isEmpty) {
              return const Center(child: Text('No news available'));
            }
            return ListView(
              children: docs.map((doc) {
                final Map<String, dynamic> data = doc.data();
                return NewsTile(
                  title: data['title'] as String? ?? 'No Title',
                  body: data['body'] as String? ?? 'No Body',
                  date: Tools.formatDate(
                    (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
