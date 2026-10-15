import 'package:flutter/material.dart';

enum BorrowStatus {
  issued,
  returned,
  overdue;

  String toApiString() {
    switch (this) {
      case BorrowStatus.issued:
        return 'ISSUED';
      case BorrowStatus.returned:
        return 'RETURNED';
      case BorrowStatus.overdue:
        return 'OVERDUE';
    }
  }

  static BorrowStatus fromString(String? value) {
    if (value == null) return BorrowStatus.issued;
    switch (value.toUpperCase()) {
      case 'RETURNED':
        return BorrowStatus.returned;
      case 'OVERDUE':
        return BorrowStatus.overdue;
      case 'ISSUED':
      default:
        return BorrowStatus.issued;
    }
  }
}

class BorrowRecord {
  final String id;
  final String bookId;
  final String bookCode;
  final String bookTitleMr;
  final String bookTitleEn;
  final String bookAuthorMr;
  final String bookAuthorEn;
  final String memberId;
  final String memberCode;
  final String memberNameMr;
  final String memberNameEn;
  final String memberPhone;
  final DateTime issueDate;
  final DateTime dueDate;
  final DateTime? returnDate;
  final BorrowStatus status;

  const BorrowRecord({
    required this.id,
    required this.bookId,
    required this.bookCode,
    this.bookTitleMr = '',
    this.bookTitleEn = '',
    this.bookAuthorMr = '',
    this.bookAuthorEn = '',
    required this.memberId,
    required this.memberCode,
    this.memberNameMr = '',
    this.memberNameEn = '',
    this.memberPhone = '',
    required this.issueDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
  });

  bool get isReturned => returnDate != null || status == BorrowStatus.returned;

  bool get isCurrentlyOverdue {
    if (isReturned) return false;
    final now = DateTime.now();
    return now.isAfter(DateTime(dueDate.year, dueDate.month, dueDate.day, 23, 59, 59));
  }

  int get daysOverdue {
    if (isReturned) return 0;
    final now = DateTime.now();
    final difference = now.difference(dueDate).inDays;
    return difference > 0 ? difference : 0;
  }

  int get daysRemaining {
    if (isReturned || isCurrentlyOverdue) return 0;
    final now = DateTime.now();
    final diff = dueDate.difference(now).inDays;
    return diff >= 0 ? diff : 0;
  }

  BorrowStatus get actualStatus {
    if (isReturned) return BorrowStatus.returned;
    if (isCurrentlyOverdue) return BorrowStatus.overdue;
    return BorrowStatus.issued;
  }

  String displayBookTitle(Locale locale) {
    if (locale.languageCode == 'mr') {
      return bookTitleMr.isNotEmpty ? bookTitleMr : bookTitleEn;
    } else {
      return bookTitleEn.isNotEmpty ? bookTitleEn : bookTitleMr;
    }
  }

  String displayMemberName(Locale locale) {
    if (locale.languageCode == 'mr') {
      return memberNameMr.isNotEmpty ? memberNameMr : memberNameEn;
    } else {
      return memberNameEn.isNotEmpty ? memberNameEn : memberNameMr;
    }
  }

  BorrowRecord copyWith({
    String? id,
    String? bookId,
    String? bookCode,
    String? bookTitleMr,
    String? bookTitleEn,
    String? bookAuthorMr,
    String? bookAuthorEn,
    String? memberId,
    String? memberCode,
    String? memberNameMr,
    String? memberNameEn,
    String? memberPhone,
    DateTime? issueDate,
    DateTime? dueDate,
    DateTime? returnDate,
    BorrowStatus? status,
  }) {
    return BorrowRecord(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      bookCode: bookCode ?? this.bookCode,
      bookTitleMr: bookTitleMr ?? this.bookTitleMr,
      bookTitleEn: bookTitleEn ?? this.bookTitleEn,
      bookAuthorMr: bookAuthorMr ?? this.bookAuthorMr,
      bookAuthorEn: bookAuthorEn ?? this.bookAuthorEn,
      memberId: memberId ?? this.memberId,
      memberCode: memberCode ?? this.memberCode,
      memberNameMr: memberNameMr ?? this.memberNameMr,
      memberNameEn: memberNameEn ?? this.memberNameEn,
      memberPhone: memberPhone ?? this.memberPhone,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      returnDate: returnDate ?? this.returnDate,
      status: status ?? this.status,
    );
  }

  factory BorrowRecord.fromJson(Map<String, dynamic> json) {
    return BorrowRecord(
      id: json['id']?.toString() ?? '',
      bookId: json['bookId']?.toString() ?? '',
      bookCode: json['bookCode'] as String? ?? '',
      bookTitleMr: json['bookTitleMr'] as String? ?? '',
      bookTitleEn: json['bookTitleEn'] as String? ?? '',
      bookAuthorMr: json['bookAuthorMr'] as String? ?? '',
      bookAuthorEn: json['bookAuthorEn'] as String? ?? '',
      memberId: json['memberId']?.toString() ?? '',
      memberCode: json['memberCode'] as String? ?? '',
      memberNameMr: json['memberNameMr'] as String? ?? '',
      memberNameEn: json['memberNameEn'] as String? ?? '',
      memberPhone: json['memberPhone'] as String? ?? '',
      issueDate: json['issueDate'] != null
          ? DateTime.tryParse(json['issueDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'].toString()) ?? DateTime.now().add(const Duration(days: 14))
          : DateTime.now().add(const Duration(days: 14)),
      returnDate: json['returnDate'] != null ? DateTime.tryParse(json['returnDate'].toString()) : null,
      status: BorrowStatus.fromString(json['status'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'bookCode': bookCode,
      'bookTitleMr': bookTitleMr,
      'bookTitleEn': bookTitleEn,
      'bookAuthorMr': bookAuthorMr,
      'bookAuthorEn': bookAuthorEn,
      'memberId': memberId,
      'memberCode': memberCode,
      'memberNameMr': memberNameMr,
      'memberNameEn': memberNameEn,
      'memberPhone': memberPhone,
      'issueDate': issueDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'status': status.toApiString(),
    };
  }
}
