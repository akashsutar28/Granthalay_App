import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../data/demo_data.dart';

abstract class BookRepository {
  List<Book> get books;
  Future<List<Book>> getBooks();
  Future<Book?> getBookById(String id);
  Future<Book> addBook(Book book);
  Future<Book> updateBook(Book book);
  Future<void> deleteBook(String id);
  Future<void> updateCopies(String bookId, int availableDelta);
}

class BookRepositoryImpl extends ChangeNotifier implements BookRepository {
  final ApiService _apiService;
  List<Book> _books = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  List<Book> get books => List.unmodifiable(_books);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  BookRepositoryImpl(this._apiService) {
    _initDemoData();
  }

  void _initDemoData() {
    _books = DemoData.getInitialBooks();
  }

  @override
  Future<List<Book>> getBooks() async {
    if (_apiService.isDemoMode) {
      return _books;
    }

    _isLoading = true;
    _errorMessage = null;

    try {
      final response = await _apiService.get('/books');
      if (response is List) {
        _books = response.map((item) => Book.fromJson(item as Map<String, dynamic>)).toList();
        notifyListeners();
      }
      return _books;
    } catch (e) {
      _errorMessage = e.toString();
      return _books;
    } finally {
      _isLoading = false;
    }
  }

  @override
  Future<Book?> getBookById(String id) async {
    if (_apiService.isDemoMode) {
      try {
        return _books.firstWhere((b) => b.id == id);
      } catch (_) {
        return null;
      }
    } else {
      try {
        final response = await _apiService.get('/books/$id');
        if (response != null) {
          return Book.fromJson(response as Map<String, dynamic>);
        }
      } catch (_) {}
      return null;
    }
  }

  @override
  Future<Book> addBook(Book book) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_apiService.isDemoMode) {
        // Generate demo ID if empty
        final newId = (DateTime.now().millisecondsSinceEpoch % 100000).toString();
        final createdBook = book.copyWith(
          id: book.id.isEmpty ? newId : book.id,
          availableCopies: book.availableCopies > 0 ? book.availableCopies : book.totalCopies,
        );
        _books.insert(0, createdBook);
        _isLoading = false;
        notifyListeners();
        return createdBook;
      } else {
        final response = await _apiService.post('/books', book.toJson());
        final created = Book.fromJson(response as Map<String, dynamic>);
        _books.insert(0, created);
        _isLoading = false;
        notifyListeners();
        return created;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  @override
  Future<Book> updateBook(Book book) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_apiService.isDemoMode) {
        final index = _books.indexWhere((b) => b.id == book.id);
        if (index != -1) {
          _books[index] = book;
        } else {
          _books.add(book);
        }
        _isLoading = false;
        notifyListeners();
        return book;
      } else {
        final response = await _apiService.put('/books/${book.id}', book.toJson());
        final updated = Book.fromJson(response as Map<String, dynamic>);
        final index = _books.indexWhere((b) => b.id == updated.id);
        if (index != -1) {
          _books[index] = updated;
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
  Future<void> deleteBook(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_apiService.isDemoMode) {
        _books.removeWhere((b) => b.id == id);
        _isLoading = false;
        notifyListeners();
      } else {
        await _apiService.delete('/books/$id');
        _books.removeWhere((b) => b.id == id);
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  @override
  Future<void> updateCopies(String bookId, int availableDelta) async {
    final index = _books.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      final current = _books[index];
      final newAvail = (current.availableCopies + availableDelta).clamp(0, current.totalCopies);
      _books[index] = current.copyWith(availableCopies: newAvail);
      notifyListeners();
    }
  }
}
