class JournalEntry {
  const JournalEntry({
    required this.title,
    required this.note,
    required this.createdAt,
    this.imagePath,
  });

  final String title;
  final String note;
  final DateTime createdAt;
  final String? imagePath;
}
