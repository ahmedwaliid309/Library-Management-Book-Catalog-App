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
    this.publishedDate = '',
  });

  final String id;
  final String title;
  final String author;

  /// ممكن يكون مسار asset (assets/images/books/x.png)
  /// أو رابط غلاف من الإنترنت (https://...)
  final String coverAsset;

  final String description;
  final double rating;
  final int pages;
  final String category;
  final String publishedDate;

  /// من JSON المحفوظ محلياً (مفضلة، مكتبة، سجل التصفح)
  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'].toString(),
        title: json['title'] as String? ?? '',
        author: json['author'] as String? ?? '',
        coverAsset: json['cover'] as String? ?? '',
        description: json['description'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        pages: json['pages'] as int? ?? 0,
        category: json['category'] as String? ?? '',
        publishedDate: json['publishedDate'] as String? ?? '',
      );

  /// من رد Google Books API
  factory Book.fromGoogle(Map<String, dynamic> item) {
    final info = (item['volumeInfo'] as Map<String, dynamic>?) ?? {};
    final images = info['imageLinks'] as Map<String, dynamic>?;

    // Google بيرجّع http، وأندرويد بيمنعه، فنحوله https
    final cover = ((images?['thumbnail'] ?? images?['smallThumbnail'] ?? '')
            as String)
        .replaceFirst('http://', 'https://');

    final authors = (info['authors'] as List?)?.cast<String>() ?? const [];
    final cats = (info['categories'] as List?)?.cast<String>() ?? const [];


    return Book(
      id: item['id'] as String? ?? '',
      title: info['title'] as String? ?? '',
      author: authors.join('، '),
      coverAsset: cover,
      description: info['description'] as String? ?? '',
      rating: (info['averageRating'] as num?)?.toDouble() ?? 0,
      pages: info['pageCount'] as int? ?? 0,
      category: cats.isNotEmpty ? cats.first : '',
      publishedDate: info['publishedDate'] as String? ?? '',
    );
  }

  /// للحفظ المحلي (shared_preferences)
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'cover': coverAsset,
        'description': description,
        'rating': rating,
        'pages': pages,
        'category': category,
        'publishedDate': publishedDate,
      };

  // الكتاب هو هو لو نفس الـ id (مهم للمفضلة والمكتبة)
  @override
  bool operator ==(Object other) => other is Book && other.id == id;

  @override
  int get hashCode => id.hashCode;
}