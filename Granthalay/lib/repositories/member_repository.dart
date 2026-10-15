import 'package:flutter/foundation.dart';
import '../models/member.dart';
import '../services/api_service.dart';
import '../data/demo_data.dart';

abstract class MemberRepository {
  List<Member> get members;
  Future<List<Member>> getMembers();
  Future<Member?> getMemberById(String id);
  Future<List<Member>> searchMembers(String query);
  Future<Member> addMember(Member member);
  Future<Member> updateMember(Member member);
  Future<void> deleteMember(String id);
}

class MemberRepositoryImpl extends ChangeNotifier implements MemberRepository {
  final ApiService _apiService;
  List<Member> _members = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  List<Member> get members => List.unmodifiable(_members);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  MemberRepositoryImpl(this._apiService) {
    _initDemoData();
  }

  void _initDemoData() {
    _members = DemoData.getInitialMembers();
  }

  @override
  Future<List<Member>> getMembers() async {
    if (_apiService.isDemoMode) {
      return _members;
    }

    _isLoading = true;
    _errorMessage = null;

    try {
      final response = await _apiService.get('/members');
      if (response is List) {
        _members = response.map((item) => Member.fromJson(item as Map<String, dynamic>)).toList();
        notifyListeners();
      }
      return _members;
    } catch (e) {
      _errorMessage = e.toString();
      return _members;
    } finally {
      _isLoading = false;
    }
  }

  @override
  Future<Member?> getMemberById(String id) async {
    if (_apiService.isDemoMode) {
      try {
        return _members.firstWhere((m) => m.id == id);
      } catch (_) {
        return null;
      }
    } else {
      try {
        final response = await _apiService.get('/members/$id');
        if (response != null) {
          return Member.fromJson(response as Map<String, dynamic>);
        }
      } catch (_) {}
      return null;
    }
  }

  @override
  Future<List<Member>> searchMembers(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return _members;

    if (_apiService.isDemoMode) {
      return _members.where((m) {
        final matchCode = m.memberCode.toLowerCase().contains(cleanQuery);
        final matchNameMr = m.nameMr.toLowerCase().contains(cleanQuery);
        final matchNameEn = m.nameEn.toLowerCase().contains(cleanQuery);
        final matchPhone = m.phone.toLowerCase().contains(cleanQuery);
        final matchDept = m.departmentClass.toLowerCase().contains(cleanQuery);
        return matchCode || matchNameMr || matchNameEn || matchPhone || matchDept;
      }).toList();
    } else {
      try {
        final response = await _apiService.get('/members/search', queryParams: {'q': cleanQuery});
        if (response is List) {
          return response.map((item) => Member.fromJson(item as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
      return [];
    }
  }

  @override
  Future<Member> addMember(Member member) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_apiService.isDemoMode) {
        final newId = (DateTime.now().millisecondsSinceEpoch % 100000).toString();
        final created = member.copyWith(
          id: member.id.isEmpty ? newId : member.id,
          memberCode: member.memberCode.isEmpty ? 'M00${_members.length + 1}' : member.memberCode,
        );
        _members.insert(0, created);
        _isLoading = false;
        notifyListeners();
        return created;
      } else {
        final response = await _apiService.post('/members', member.toJson());
        final created = Member.fromJson(response as Map<String, dynamic>);
        _members.insert(0, created);
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
  Future<Member> updateMember(Member member) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_apiService.isDemoMode) {
        final index = _members.indexWhere((m) => m.id == member.id);
        if (index != -1) {
          _members[index] = member;
        } else {
          _members.add(member);
        }
        _isLoading = false;
        notifyListeners();
        return member;
      } else {
        final response = await _apiService.put('/members/${member.id}', member.toJson());
        final updated = Member.fromJson(response as Map<String, dynamic>);
        final index = _members.indexWhere((m) => m.id == updated.id);
        if (index != -1) {
          _members[index] = updated;
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
  Future<void> deleteMember(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_apiService.isDemoMode) {
        _members.removeWhere((m) => m.id == id);
        _isLoading = false;
        notifyListeners();
      } else {
        await _apiService.delete('/members/$id');
        _members.removeWhere((m) => m.id == id);
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
}
