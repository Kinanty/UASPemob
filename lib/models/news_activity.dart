class NewsActivity {
  final int id;
  final String title;
  final String date;
  final String time;
  final String type;
  final String description;
  final String imageUrl;
  final String location;
  final String newsTitle;
  final String subtitle;

  NewsActivity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.newsTitle,
    required this.date,
    required this.time,
    required this.type,
    required this.description,
    required this.imageUrl,
    required this.location,
  });
}
