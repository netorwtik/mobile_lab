import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лента новостей КубГАУ',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,//Colors.green[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[700],
          elevation: 4,
        ),
      ),
      home: const NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<NewsItem>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = fetchNews();
  }

  Future<List<NewsItem>> fetchNews() async {
    final response = await HttpClient()
        .getUrl(Uri.parse('https://kubsau.ru/api/getNews.php?key=6df2f5d38d4e16b5a923a6d4873e2ee295d0ac90'))
        .then((request) => request.close());

    if (response.statusCode == 200) {
      final jsonData = await response.transform(utf8.decoder).join();
      final List<dynamic> newsJson = json.decode(jsonData);
      return newsJson.map((json) => NewsItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  String formatDate(String dateStr) {
    try {
      // Expected format: "08.04.2022 10:38:00"
      final parts = dateStr.split(' ');
      if (parts.length == 2) {
        return '${parts[0]} ${parts[1].substring(0, 5)}'; // Keep only HH:MM
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Лента новостей КубГАУ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка загрузки данных: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _newsFuture = fetchNews();
                      });
                    },
                    child: const Text('Попробовать снова'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Новости не найдены'),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _newsFuture = fetchNews();
                });
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final newsItem = snapshot.data![index];
                  return NewsCard(newsItem: newsItem, formatDate: formatDate);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsItem newsItem;
  final Function formatDate;

  const NewsCard({
    super.key,
    required this.newsItem,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (newsItem.imagePath.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                newsItem.imagePath.startsWith('http')
                    ? newsItem.imagePath
                    : 'https://kubsau.ru${newsItem.imagePath}',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        formatDate(newsItem.dateTime).toString(),
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (newsItem.category.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(left: 8.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          newsItem.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  Bidi.stripHtmlIfNeeded(newsItem.title),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  Bidi.stripHtmlIfNeeded(newsItem.content),
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailScreen(newsItem: newsItem),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green[700],
                    ),
                    child: const Text('Подробнее'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final NewsItem newsItem;

  const NewsDetailScreen({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подробности'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (newsItem.imagePath.isNotEmpty)
              Image.network(
                newsItem.imagePath.startsWith('http')
                    ? newsItem.imagePath
                    : 'https://kubsau.ru${newsItem.imagePath}',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          newsItem.dateTime,
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (newsItem.category.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(left: 8.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            newsItem.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    Bidi.stripHtmlIfNeeded(newsItem.title),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    Bidi.stripHtmlIfNeeded(newsItem.content),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model class for news items
class NewsItem {
  final String id;
  final String title;
  final String content;
  final String dateTime;
  final String category;
  final String imagePath;

  NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.dateTime,
    required this.category,
    required this.imagePath,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    String imagePath = json['PREVIEW_PICTURE_SRC'] ?? '';

    if (imagePath.startsWith('https://kubsau.ru')) {
    } else if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      if (!imagePath.startsWith('/')) {
        imagePath = '/$imagePath';
      }
    }

    return NewsItem(
      id: json['ID'] ?? '',
      title: json['TITLE'] ?? '',
      content: json['PREVIEW_TEXT'] ?? '',
      dateTime: json['ACTIVE_FROM'] ?? '',
      category: json['SECTION_NAME'] ?? '',
      imagePath: imagePath,
    );
  }
}