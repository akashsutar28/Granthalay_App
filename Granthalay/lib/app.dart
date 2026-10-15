import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_routes.dart';
import 'core/localization/locale_provider.dart';
import 'l10n/generated/app_localizations.dart';
import 'services/api_service.dart';
import 'repositories/book_repository.dart';
import 'repositories/member_repository.dart';
import 'repositories/borrowing_repository.dart';
import 'models/book.dart';
import 'models/member.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_layout.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/books/books_list_screen.dart';
import 'screens/books/book_details_screen.dart';
import 'screens/books/add_edit_book_screen.dart';
import 'screens/members/members_list_screen.dart';
import 'screens/members/member_details_screen.dart';
import 'screens/members/add_edit_member_screen.dart';
import 'screens/issue_return/issue_book_screen.dart';
import 'screens/issue_return/return_book_screen.dart';
import 'screens/issue_return/currently_issued_screen.dart';
import 'screens/issue_return/overdue_books_screen.dart';
import 'screens/search/search_person_screen.dart';
import 'screens/history/borrowing_history_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/settings/settings_screen.dart';

class GranthalayApp extends StatelessWidget {
  final LocaleProvider localeProvider;
  final ApiService apiService;
  final BookRepository bookRepository;
  final MemberRepository memberRepository;
  final BorrowingRepository borrowingRepository;

  const GranthalayApp({
    super.key,
    required this.localeProvider,
    required this.apiService,
    required this.bookRepository,
    required this.memberRepository,
    required this.borrowingRepository,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'ग्रंथालय - Granthalay',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: localeProvider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: AppRoutes.splash,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.splash:
                return MaterialPageRoute(builder: (_) => const SplashScreen());

              case AppRoutes.login:
                return MaterialPageRoute(
                  builder: (_) => LoginScreen(localeProvider: localeProvider),
                );

              case AppRoutes.main:
                return MaterialPageRoute(
                  builder: (_) => MainLayout(
                    localeProvider: localeProvider,
                    apiService: apiService,
                    bookRepository: bookRepository,
                    memberRepository: memberRepository,
                    borrowingRepository: borrowingRepository,
                  ),
                );

              case AppRoutes.dashboard:
                return MaterialPageRoute(
                  builder: (_) => DashboardScreen(
                    borrowingRepository: borrowingRepository,
                    bookRepository: bookRepository,
                  ),
                );

              case AppRoutes.booksList:
                return MaterialPageRoute(
                  builder: (_) => BooksListScreen(bookRepository: bookRepository),
                );

              case AppRoutes.bookDetails:
                final book = settings.arguments as Book;
                return MaterialPageRoute(
                  builder: (_) => BookDetailsScreen(
                    bookRepository: bookRepository,
                    initialBook: book,
                  ),
                );

              case AppRoutes.addEditBook:
                final book = settings.arguments as Book?;
                return MaterialPageRoute(
                  builder: (_) => AddEditBookScreen(
                    bookRepository: bookRepository,
                    bookToEdit: book,
                  ),
                );

              case AppRoutes.membersList:
                return MaterialPageRoute(
                  builder: (_) => MembersListScreen(memberRepository: memberRepository),
                );

              case AppRoutes.memberDetails:
                final member = settings.arguments as Member;
                return MaterialPageRoute(
                  builder: (_) => MemberDetailsScreen(
                    memberRepository: memberRepository,
                    borrowingRepository: borrowingRepository,
                    initialMember: member,
                  ),
                );

              case AppRoutes.addEditMember:
                final member = settings.arguments as Member?;
                return MaterialPageRoute(
                  builder: (_) => AddEditMemberScreen(
                    memberRepository: memberRepository,
                    memberToEdit: member,
                  ),
                );

              case AppRoutes.issueBook:
                final args = settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                  builder: (_) => IssueBookScreen(
                    bookRepository: bookRepository,
                    memberRepository: memberRepository,
                    borrowingRepository: borrowingRepository,
                    preselectedMember: args?['member'] as Member?,
                    preselectedBook: args?['book'] as Book?,
                  ),
                );

              case AppRoutes.returnBook:
                return MaterialPageRoute(
                  builder: (_) => ReturnBookScreen(borrowingRepository: borrowingRepository),
                );

              case AppRoutes.searchPerson:
                return MaterialPageRoute(
                  builder: (_) => SearchPersonScreen(
                    memberRepository: memberRepository,
                    borrowingRepository: borrowingRepository,
                  ),
                );

              case AppRoutes.borrowingHistory:
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => BorrowingHistoryScreen(
                    borrowingRepository: borrowingRepository,
                    memberId: args['memberId'] as String,
                    memberName: args['memberName'] as String,
                    memberCode: args['memberCode'] as String,
                  ),
                );

              case AppRoutes.currentlyIssued:
                return MaterialPageRoute(
                  builder: (_) => CurrentlyIssuedScreen(borrowingRepository: borrowingRepository),
                );

              case AppRoutes.overdueBooks:
                return MaterialPageRoute(
                  builder: (_) => OverdueBooksScreen(borrowingRepository: borrowingRepository),
                );

              case AppRoutes.reports:
                return MaterialPageRoute(
                  builder: (_) => ReportsScreen(borrowingRepository: borrowingRepository),
                );

              case AppRoutes.settings:
                return MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    localeProvider: localeProvider,
                    apiService: apiService,
                  ),
                );

              default:
                return MaterialPageRoute(
                  builder: (_) => MainLayout(
                    localeProvider: localeProvider,
                    apiService: apiService,
                    bookRepository: bookRepository,
                    memberRepository: memberRepository,
                    borrowingRepository: borrowingRepository,
                  ),
                );
            }
          },
        );
      },
    );
  }
}
