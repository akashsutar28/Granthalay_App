import 'package:flutter_test/flutter_test.dart';
import 'package:granthalay/models/borrow_record.dart';
import 'package:granthalay/services/api_service.dart';
import 'package:granthalay/repositories/book_repository.dart';
import 'package:granthalay/repositories/member_repository.dart';
import 'package:granthalay/repositories/borrowing_repository.dart';

void main() {
  group('Granthalay Repository & Demo State Tests', () {
    late ApiService apiService;
    late BookRepositoryImpl bookRepo;
    late MemberRepositoryImpl memberRepo;
    late BorrowingRepositoryImpl borrowingRepo;

    setUp(() {
      apiService = ApiService();
      bookRepo = BookRepositoryImpl(apiService);
      memberRepo = MemberRepositoryImpl(apiService);
      borrowingRepo = BorrowingRepositoryImpl(apiService, bookRepo, memberRepo);
    });

    test('Initial books are loaded with Marathi and English titles', () async {
      final books = await bookRepo.getBooks();
      expect(books.isNotEmpty, isTrue);
      expect(books.any((b) => b.titleMr == 'मृत्युंजय'), isTrue);
    });

    test('Searching members matches both Marathi and English names', () async {
      final marathiResults = await memberRepo.searchMembers('राहुल');
      expect(marathiResults.length, 1);
      expect(marathiResults.first.memberCode, 'M001');

      final englishResults = await memberRepo.searchMembers('Rahul');
      expect(englishResults.length, 1);
      expect(englishResults.first.memberCode, 'M001');

      final codeResults = await memberRepo.searchMembers('M001');
      expect(codeResults.length, 1);
    });

    test('Issuing a book creates a record and decreases available copies', () async {
      final books = await bookRepo.getBooks();
      final targetBook = books.firstWhere((b) => b.availableCopies > 0);
      final initialAvail = targetBook.availableCopies;

      final members = await memberRepo.getMembers();
      final member = members.first;

      final newRecord = BorrowRecord(
        id: '',
        bookId: targetBook.id,
        bookCode: targetBook.bookCode,
        bookTitleMr: targetBook.titleMr,
        bookTitleEn: targetBook.titleEn,
        memberId: member.id,
        memberCode: member.memberCode,
        memberNameMr: member.nameMr,
        memberNameEn: member.nameEn,
        issueDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 14)),
        status: BorrowStatus.issued,
      );

      final issued = await borrowingRepo.issueBook(newRecord);
      expect(issued.id.isNotEmpty, isTrue);

      final updatedBook = await bookRepo.getBookById(targetBook.id);
      expect(updatedBook?.availableCopies, initialAvail - 1);
    });

    test('Returning a book marks it as returned and restores available copies', () async {
      final activeRecords = await borrowingRepo.getIssuedRecords();
      expect(activeRecords.isNotEmpty, isTrue);

      final recordToReturn = activeRecords.first;
      final bookBefore = await bookRepo.getBookById(recordToReturn.bookId);
      final initialAvail = bookBefore?.availableCopies ?? 0;

      final returned = await borrowingRepo.returnBook(recordToReturn.id);
      expect(returned.isReturned, isTrue);
      expect(returned.returnDate, isNotNull);

      final bookAfter = await bookRepo.getBookById(recordToReturn.bookId);
      expect(bookAfter?.availableCopies, initialAvail + 1);
    });

    test('Dashboard statistics are calculated dynamically', () async {
      final stats = await borrowingRepo.getDashboardStats();
      expect(stats.totalBooks, greaterThan(0));
      expect(stats.totalMembers, greaterThan(0));
      expect(stats.totalCopies, greaterThanOrEqualTo(stats.availableCopies));
    });
  });
}
