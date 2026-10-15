import 'package:flutter/material.dart';
import 'app.dart';
import 'core/localization/locale_provider.dart';
import 'services/api_service.dart';
import 'repositories/book_repository.dart';
import 'repositories/member_repository.dart';
import 'repositories/borrowing_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core Services and State Providers
  final localeProvider = LocaleProvider();
  final apiService = ApiService();

  // Initialize Repositories with In-Memory Demo Data & REST API connectivity
  final bookRepository = BookRepositoryImpl(apiService);
  final memberRepository = MemberRepositoryImpl(apiService);
  final borrowingRepository = BorrowingRepositoryImpl(
    apiService,
    bookRepository,
    memberRepository,
  );

  runApp(
    GranthalayApp(
      localeProvider: localeProvider,
      apiService: apiService,
      bookRepository: bookRepository,
      memberRepository: memberRepository,
      borrowingRepository: borrowingRepository,
    ),
  );
}
