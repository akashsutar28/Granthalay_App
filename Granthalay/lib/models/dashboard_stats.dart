class DashboardStats {
  final int totalBooks;
  final int totalCopies;
  final int availableCopies;
  final int issuedBooks;
  final int totalMembers;
  final int overdueBooks;
  final int totalReturned;
  final Map<String, int> categoryDistribution;

  const DashboardStats({
    required this.totalBooks,
    required this.totalCopies,
    required this.availableCopies,
    required this.issuedBooks,
    required this.totalMembers,
    required this.overdueBooks,
    this.totalReturned = 0,
    this.categoryDistribution = const {},
  });

  factory DashboardStats.empty() {
    return const DashboardStats(
      totalBooks: 0,
      totalCopies: 0,
      availableCopies: 0,
      issuedBooks: 0,
      totalMembers: 0,
      overdueBooks: 0,
      totalReturned: 0,
      categoryDistribution: {},
    );
  }

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalBooks: (json['totalBooks'] as num?)?.toInt() ?? 0,
      totalCopies: (json['totalCopies'] as num?)?.toInt() ?? 0,
      availableCopies: (json['availableCopies'] as num?)?.toInt() ?? 0,
      issuedBooks: (json['issuedBooks'] as num?)?.toInt() ?? 0,
      totalMembers: (json['totalMembers'] as num?)?.toInt() ?? 0,
      overdueBooks: (json['overdueBooks'] as num?)?.toInt() ?? 0,
      totalReturned: (json['totalReturned'] as num?)?.toInt() ?? 0,
      categoryDistribution: (json['categoryDistribution'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toInt()),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBooks': totalBooks,
      'totalCopies': totalCopies,
      'availableCopies': availableCopies,
      'issuedBooks': issuedBooks,
      'totalMembers': totalMembers,
      'overdueBooks': overdueBooks,
      'totalReturned': totalReturned,
      'categoryDistribution': categoryDistribution,
    };
  }
}
