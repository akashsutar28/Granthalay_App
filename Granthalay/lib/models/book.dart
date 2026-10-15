import 'package:flutter/material.dart';

class Book {
  final String id;
  final String bookCode;
  final String titleMr;
  final String titleEn;
  final String authorMr;
  final String authorEn;
  final String category;
  final String isbn;
  final String publisher;
  final int publicationYear;
  final int totalCopies;
  final int availableCopies;

  const Book({
    required this.id,
    required this.bookCode,
    this.titleMr = '',
    this.titleEn = '',
    this.authorMr = '',
    this.authorEn = '',
    required this.category,
    this.isbn = '',
    this.publisher = '',
    this.publicationYear = 0,
    required this.totalCopies,
    required this.availableCopies,
  });

  bool get isAvailable => availableCopies > 0;

  int get issuedCopies => (totalCopies - availableCopies).clamp(0, totalCopies);

  String displayTitle(Locale locale) {
    if (locale.languageCode == 'mr') {
      return titleMr.isNotEmpty ? titleMr : titleEn;
    } else {
      return titleEn.isNotEmpty ? titleEn : titleMr;
    }
  }

  String displayAuthor(Locale locale) {
    if (locale.languageCode == 'mr') {
      return authorMr.isNotEmpty ? authorMr : authorEn;
    } else {
      return authorEn.isNotEmpty ? authorEn : authorMr;
    }
  }

  Book copyWith({
    String? id,
    String? bookCode,
    String? titleMr,
    String? titleEn,
    String? authorMr,
    String? authorEn,
    String? category,
    String? isbn,
    String? publisher,
    int? publicationYear,
    int? totalCopies,
    int? availableCopies,
  }) {
    return Book(
      id: id ?? this.id,
      bookCode: bookCode ?? this.bookCode,
      titleMr: titleMr ?? this.titleMr,
      titleEn: titleEn ?? this.titleEn,
      authorMr: authorMr ?? this.authorMr,
      authorEn: authorEn ?? this.authorEn,
      category: category ?? this.category,
      isbn: isbn ?? this.isbn,
      publisher: publisher ?? this.publisher,
      publicationYear: publicationYear ?? this.publicationYear,
      totalCopies: totalCopies ?? this.totalCopies,
      availableCopies: availableCopies ?? this.availableCopies,
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      bookCode: json['bookCode'] as String? ?? json['code'] as String? ?? '',
      titleMr: json['titleMr'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      authorMr: json['authorMr'] as String? ?? '',
      authorEn: json['authorEn'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      isbn: json['isbn'] as String? ?? '',
      publisher: json['publisher'] as String? ?? '',
      publicationYear: (json['publicationYear'] as num?)?.toInt() ?? 0,
      totalCopies: (json['totalCopies'] as num?)?.toInt() ?? 1,
      availableCopies: (json['availableCopies'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookCode': bookCode,
      'titleMr': titleMr,
      'titleEn': titleEn,
      'authorMr': authorMr,
      'authorEn': authorEn,
      'category': category,
      'isbn': isbn,
      'publisher': publisher,
      'publicationYear': publicationYear,
      'totalCopies': totalCopies,
      'availableCopies': availableCopies,
    };
  }
}
