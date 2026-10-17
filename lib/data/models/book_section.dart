class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverAsset,
    this.description = '',
    this.rating = 0,
    this.pages = 0,
    this.category = '',
  });

  final String id;
  final String title;
  final String author;
  final String coverAsset; // مسار الغلاف في assets
  final String description;
  final double rating;
  final int pages;
  final String category;

  // هنحتاجها لما نربط API
  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'].toString(),
        title: json['title'] as String? ?? '',
        author: json['author'] as String? ?? '',
        coverAsset: json['cover'] as String? ?? '',
        description: json['description'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        pages: json['pages'] as int? ?? 0,
        category: json['category'] as String? ?? '',
      );
}