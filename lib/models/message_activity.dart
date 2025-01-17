class MessageActivity {
  final int id;
  final String title;
  final String date;
  final String time;
  final String type;
  final String description;
  final String imageUrl;
  final String location;
  final int approval;
  final String notes;

  MessageActivity({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.type,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.approval,
    required this.notes,
  });
}
