import 'package:raffi/data/models/book_section.dart';

import 'book_section.dart';
import 'models/book.dart';

class MockBooks {
  MockBooks._();

  static const List<Book> all = [
    Book(
      id: '1',
      title: 'عداء الطائرة الورقية',
      author: 'خالد حسيني',
      coverAsset: 'assets/images/books/kite_runner.png',
      description: 'وصف تجريبي للكتاب.',
      rating: 4.8,
      pages: 372,
      category: 'روايات',
    ),
    Book(
      id: '2',
      title: 'قضية ست الحسن',
      author: 'ميرنا المهدي',
      coverAsset: 'assets/images/books/sit_alhasan.png',
      description: 'وصف تجريبي للكتاب.',
      rating: 4.3,
      pages: 280,
      category: 'جريمة',
    ),
    Book(
      id: '3',
      title: 'جسمك يتذكر كل شيء',
      author: 'بيسيل فان دير كولك',
      coverAsset: 'assets/images/books/body.png',
      description: 'وصف تجريبي للكتاب.',
      rating: 4.6,
      pages: 464,
      category: 'علم نفس',
    ),
    Book(
      id: '4',
      title: 'في ممر الفئران',
      author: 'أحمد خالد توفيق',
      coverAsset: 'assets/images/books/fo2ran.png',
      description: 'وصف تجريبي للكتاب.',
      rating: 4.5,
      pages: 190,
      category: 'روايات',
    ),
    Book(
      id: '5',
      title: 'الأمير الصغير',
      author: 'أنطوان دو سانت إكزوبيري',
      coverAsset: 'assets/images/books/prince.png',
      description: 'وصف تجريبي للكتاب.',
      rating: 4.9,
      pages: 96,
      category: 'أدب',
    ),
    Book(
      id: '6',
      title: 'ممتلئ بالفراغ',
      author: 'اسم المؤلف',
      coverAsset: 'assets/images/books/empty.png',
      description: 'وصف تجريبي للكتاب.',
      rating: 4.1,
      pages: 210,
      category: 'تنمية ذاتية',
    ),
  ];

  // كل قسم بيجيب كتب مختلفة (بالـ id). غيّرهم لما تزودوا كتب.
  static List<Book> get recent => _pick(['1', '2', '3', '4', '5', '6']);
  static List<Book> get recommended => _pick(['5', '6', '4', '1']);

  static List<Book> forSection(BookSection section) {
    switch (section) {
      case BookSection.recent:
        return recent;
      case BookSection.recommended:
        return recommended;
    }
  }

  static Book? byId(String id) {
    for (final book in all) {
      if (book.id == id) return book;
    }
    return null;
  }

  static List<Book> _pick(List<String> ids) =>
      all.where((b) => ids.contains(b.id)).toList();
}