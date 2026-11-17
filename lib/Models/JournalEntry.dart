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

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    final title = json['title'];
    final note = json['note'];
    final createdAt = json['createdAt'];
    final imagePath = json['imagePath'];

    if (title is! String ||
        note is! String ||
        createdAt is! String ||
        (imagePath != null && imagePath is! String)) {
      throw const FormatException('Invalid journal entry data.');
    }

    return JournalEntry(
      title: title,
      note: note,
      createdAt: DateTime.parse(createdAt),
      imagePath: imagePath as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'imagePath': imagePath,
  };
}
