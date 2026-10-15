import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:granthalay/app.dart';
import 'package:granthalay/core/localization/locale_provider.dart';
import 'package:granthalay/services/api_service.dart';
import 'package:granthalay/repositories/book_repository.dart';
import 'package:granthalay/repositories/member_repository.dart';
import 'package:granthalay/repositories/borrowing_repository.dart';
import 'package:granthalay/l10n/generated/app_localizations.dart';
import 'package:granthalay/screens/books/add_edit_book_screen.dart';
import 'package:granthalay/screens/members/add_edit_member_screen.dart';

void main() {
  testWidgets('GranthalayApp initializes, displays splash, and transitions to login in Marathi', (WidgetTester tester) async {
    final localeProvider = LocaleProvider();
    final apiService = ApiService();
    final bookRepository = BookRepositoryImpl(apiService);
    final memberRepository = MemberRepositoryImpl(apiService);
    final borrowingRepository = BorrowingRepositoryImpl(
      apiService,
      bookRepository,
      memberRepository,
    );

    await tester.pumpWidget(
      GranthalayApp(
        localeProvider: localeProvider,
        apiService: apiService,
        bookRepository: bookRepository,
        memberRepository: memberRepository,
        borrowingRepository: borrowingRepository,
      ),
    );

    // Initial frame shows English subtitle or title on splash
    expect(find.text('Granthalay'), findsOneWidget);

    // Fast-forward past the splash timer (2.2s)
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify it reached Login Screen with Marathi title and login controls
    expect(find.text('ग्रंथालय'), findsWidgets);
    expect(find.text('वसंत दादाश्री जिनवाणी महाग्रंथालय'), findsWidgets);
  });

  testWidgets('DashboardScreen renders without overflow on 400px mobile width', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final localeProvider = LocaleProvider();
    final apiService = ApiService();
    final bookRepository = BookRepositoryImpl(apiService);
    final memberRepository = MemberRepositoryImpl(apiService);
    final borrowingRepository = BorrowingRepositoryImpl(
      apiService,
      bookRepository,
      memberRepository,
    );

    await tester.pumpWidget(
      GranthalayApp(
        localeProvider: localeProvider,
        apiService: apiService,
        bookRepository: bookRepository,
        memberRepository: memberRepository,
        borrowingRepository: borrowingRepository,
      ),
    );

    // Fast-forward past splash
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Tap Login button to reach Dashboard
    final loginButton = find.text('लॉगिन करा');
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify Dashboard rendered with statistics
    expect(find.text('एकूण पुस्तके'), findsOneWidget);
    expect(find.text('उपलब्ध प्रती'), findsOneWidget);
    expect(find.text('दिलेली पुस्तके'), findsOneWidget);
    expect(find.text('एकूण सभासद'), findsOneWidget);

    // Verify statistics are not 0 but populated from demo data
    expect(find.text('12'), findsWidgets); // total books in initial demo data is 12
  });

  testWidgets('AddEditBookScreen has single Book Title and Author fields and does not show separate language fields', (WidgetTester tester) async {
    final apiService = ApiService();
    final bookRepository = BookRepositoryImpl(apiService);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('mr'),
        home: AddEditBookScreen(bookRepository: bookRepository),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Book Title and Author are rendered (section title + input label = 2 each)
    expect(find.text('पुस्तकाचे नाव'), findsNWidgets(2));
    expect(find.text('लेखक'), findsNWidgets(2));

    // Verify separate language fields are no longer displayed
    expect(find.text('मराठी नाव'), findsNothing);
    expect(find.text('इंग्रजी नाव'), findsNothing);
    expect(find.text('मराठी लेखक'), findsNothing);
    expect(find.text('इंग्रजी लेखक'), findsNothing);
  });

  testWidgets('AddEditMemberScreen has single Full Name field and does not show separate language fields', (WidgetTester tester) async {
    final apiService = ApiService();
    final memberRepository = MemberRepositoryImpl(apiService);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('mr'),
        home: AddEditMemberScreen(memberRepository: memberRepository),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Full Name is rendered (section title + input label = 2)
    expect(find.text('पूर्ण नाव'), findsNWidgets(2));

    // Verify separate language fields are no longer displayed
    expect(find.text('मराठीत पूर्ण नाव'), findsNothing);
    expect(find.text('इंग्रजीत पूर्ण नाव'), findsNothing);

    // Verify department and class field is no longer displayed
    expect(find.text('शाखा / वर्ग'), findsNothing);
  });
}
