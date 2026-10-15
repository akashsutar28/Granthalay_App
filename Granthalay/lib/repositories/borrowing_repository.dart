import 'package:flutter/foundation.dart';
import '../models/borrow_record.dart';
import '../models/dashboard_stats.dart';
import '../services/api_service.dart';
import '../repositories/book_repository.dart';
import '../repositories/member_repository.dart';
import '../data/demo_data.dart';

abstract class BorrowingRepository {
  List<BorrowRecord> get records;
  Future<List<BorrowRecord>> getAllRecords();
  Future<List<BorrowRecord>> getIssuedRecords();
  Future<List<BorrowRecord>> getOverdueRecords();
  Future<List<BorrowRecord>> getMemberBorrowHistory(String memberId);
  Future<BorrowRecord> issueBook(BorrowRecord record);
  Future<BorrowRecord> returnBook(String recordId);
  Future<DashboardStats> getDashboardStats();
}

class BorrowingRepositoryImpl extends ChangeNotifier implements BorrowingRepository {
  final ApiService _apiService;
  final BookRepository _bookRepository;
  final MemberRepository _memberRepository;

  List<BorrowRecord> _records = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  List<BorrowRecord> get records => List.unmodifiable(_records);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  BorrowingRepositoryImpl(
    this._apiService,
    this._bookRepository,
    this._memberRepository,
  ) {
    _initDemoData();
  }

  void _initDemoData() {
    _records = DemoData.getInitialBorrowRecords();
  }

  @override
  Future<List<BorrowRecord>> getAllRecords() async {
    if (_apiService.isDemoMode) {
      return _records;
    }

    _isLoading = true;
    _errorMessage = null;

    try {
      final response = await _apiService.get('/borrow-records');
      if (response is List) {
        _records = response.map((item) => BorrowRecord.fromJson(item as Map<String, dynamic>)).toList();
        notifyListeners();
      }
      return _records;
    } catch (e) {
      _errorMessage = e.toString();
      return _records;
    } finally {
      _isLoading = false;
    }
  }

  @override
  Future<List<BorrowRecord>> getIssuedRecords() async {
    if (_apiService.isDemoMode) {
      return _records.where((r) => !r.isReturned).toList();
    } else {
      try {
        final response = await _apiService.get('/borrow-records/issued');
        if (response is List) {
          return response.map((item) => BorrowRecord.fromJson(item as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
      return _records.where((r) => !r.isReturned).toList();
    }
  }

  @override
  Future<List<BorrowRecord>> getOverdueRecords() async {
    if (_apiService.isDemoMode) {
      return _records.where((r) => r.isCurrentlyOverdue).toList();
    } else {
      try {
        final response = await _apiService.get('/borrow-records/overdue');
        if (response is List) {
          return response.map((item) => BorrowRecord.fromJson(item as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
      return _records.where((r) => r.isCurrentlyOverdue).toList();
    }
  }

  @override
  Future<List<BorrowRecord>> getMemberBorrowHistory(String memberId) async {
    if (_apiService.isDemoMode) {
      return _records.where((r) => r.memberId == memberId).toList();
    } else {
      try {
        final response = await _apiService.get('/members/$memberId/borrow-history');
        if (response is List) {
          return response.map((item) => BorrowRecord.fromJson(item as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
      return _records.where((r) => r.memberId == memberId).toList();
    }
  }

  @override
  Future<BorrowRecord> issueBook(BorrowRecord record) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_apiService.isDemoMode) {
        // Decrease copy count in demo state
        await _bookRepository.updateCopies(record.bookId, -1);

        final newId = (DateTime.now().millisecondsSinceEpoch % 100000).toString();
        final createdRecord = record.copyWith(
          id: record.id.isEmpty ? newId : record.id,
          status: BorrowStatus.issued,
        );
        _records.insert(0, createdRecord);
        _isLoading = false;
        notifyListeners();
        return createdRecord;
      } else {
        // Post to Spring Boot /api/borrow-records/issue
        final response = await _apiService.post('/borrow-records/issue', record.toJson());
        final createdRecord = BorrowRecord.fromJson(response as Map<String, dynamic>);
        _records.insert(0, createdRecord);
        await _bookRepository.updateCopies(record.bookId, -1);
        _isLoading = false;
        notifyListeners();
        return createdRecord;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  @override
  Future<BorrowRecord> returnBook(String recordId) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_apiService.isDemoMode) {
        final index = _records.indexWhere((r) => r.id == recordId);
        if (index == -1) {
          throw Exception('Record not found');
        }
        final existing = _records[index];
        if (existing.isReturned) {
          throw Exception('Already returned');
        }

        final updated = existing.copyWith(
          returnDate: DateTime.now(),
          status: BorrowStatus.returned,
        );
        _records[index] = updated;

        // Increase copy count in demo state
        await _bookRepository.updateCopies(existing.bookId, 1);

        _isLoading = false;
        notifyListeners();
        return updated;
      } else {
        // Post to Spring Boot /api/borrow-records/{id}/return
        final response = await _apiService.post('/borrow-records/$recordId/return', {});
        final updated = BorrowRecord.fromJson(response as Map<String, dynamic>);
        final index = _records.indexWhere((r) => r.id == recordId);
        if (index != -1) {
          _records[index] = updated;
          await _bookRepository.updateCopies(updated.bookId, 1);
        }
        _isLoading = false;
        notifyListeners();
        return updated;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  @override
  Future<DashboardStats> getDashboardStats() async {
    if (_apiService.isDemoMode) {
      final books = _bookRepository.books;
      final members = _memberRepository.members;

      int totalCopies = 0;
      int availableCopies = 0;
      final categoryMap = <String, int>{};

      for (var b in books) {
        totalCopies += b.totalCopies;
        availableCopies += b.availableCopies;
        categoryMap[b.category] = (categoryMap[b.category] ?? 0) + 1;
      }

      int activeIssued = 0;
      int overdue = 0;
      int returned = 0;

      for (var r in _records) {
        if (r.isReturned) {
          returned++;
        } else {
          activeIssued++;
          if (r.isCurrentlyOverdue) {
            overdue++;
          }
        }
      }

      return DashboardStats(
        totalBooks: books.length,
        totalCopies: totalCopies,
        availableCopies: availableCopies,
        issuedBooks: activeIssued,
        totalMembers: members.length,
        overdueBooks: overdue,
        totalReturned: returned,
        categoryDistribution: categoryMap,
      );
    } else {
      try {
        final response = await _apiService.get('/dashboard/statistics');
        if (response != null) {
          return DashboardStats.fromJson(response as Map<String, dynamic>);
        }
      } catch (_) {}
      return DashboardStats.empty();
    }
  }
}
