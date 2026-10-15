import 'package:flutter/material.dart';
import '../core/localization/locale_provider.dart';
import '../services/api_service.dart';
import '../repositories/book_repository.dart';
import '../repositories/member_repository.dart';
import '../repositories/borrowing_repository.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_bottom_navigation.dart';
import 'dashboard/dashboard_screen.dart';
import 'books/books_list_screen.dart';
import 'members/members_list_screen.dart';
import 'issue_return/transactions_hub_screen.dart';
import 'settings/settings_screen.dart';

class MainLayout extends StatefulWidget {
  final LocaleProvider localeProvider;
  final ApiService apiService;
  final BookRepository bookRepository;
  final MemberRepository memberRepository;
  final BorrowingRepository borrowingRepository;

  const MainLayout({
    super.key,
    required this.localeProvider,
    required this.apiService,
    required this.bookRepository,
    required this.memberRepository,
    required this.borrowingRepository,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        borrowingRepository: widget.borrowingRepository,
        bookRepository: widget.bookRepository,
        onOpenDrawer: _openDrawer,
      ),
      BooksListScreen(
        bookRepository: widget.bookRepository,
        onOpenDrawer: _openDrawer,
      ),
      MembersListScreen(
        memberRepository: widget.memberRepository,
        onOpenDrawer: _openDrawer,
      ),
      TransactionsHubScreen(
        borrowingRepository: widget.borrowingRepository,
        onOpenDrawer: _openDrawer,
      ),
      SettingsScreen(
        localeProvider: widget.localeProvider,
        apiService: widget.apiService,
        onOpenDrawer: _openDrawer,
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        localeProvider: widget.localeProvider,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
