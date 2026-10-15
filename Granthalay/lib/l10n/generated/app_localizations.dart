import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In mr, this message translates to:
  /// **'ग्रंथालय'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In mr, this message translates to:
  /// **'वाचनालय व्यवस्थापन प्रणाली'**
  String get appSubtitle;

  /// No description provided for @libraryName.
  ///
  /// In mr, this message translates to:
  /// **'वसंत दादाश्री जिनवाणी महाग्रंथालय'**
  String get libraryName;

  /// No description provided for @demoModeNotice.
  ///
  /// In mr, this message translates to:
  /// **'डेमो मोड सक्रिय (स्थानिक डेटा)'**
  String get demoModeNotice;

  /// No description provided for @apiReadyNotice.
  ///
  /// In mr, this message translates to:
  /// **'स्प्रिंग बूट API जोडणीसाठी तयार'**
  String get apiReadyNotice;

  /// No description provided for @navHome.
  ///
  /// In mr, this message translates to:
  /// **'मुख्यपृष्ठ'**
  String get navHome;

  /// No description provided for @navBooks.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तके'**
  String get navBooks;

  /// No description provided for @navMembers.
  ///
  /// In mr, this message translates to:
  /// **'सभासद'**
  String get navMembers;

  /// No description provided for @navTransactions.
  ///
  /// In mr, this message translates to:
  /// **'व्यवहार'**
  String get navTransactions;

  /// No description provided for @navSettings.
  ///
  /// In mr, this message translates to:
  /// **'सेटिंग्ज'**
  String get navSettings;

  /// No description provided for @loginTitle.
  ///
  /// In mr, this message translates to:
  /// **'ग्रंथपाल लॉगिन'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In mr, this message translates to:
  /// **'आपल्या खात्यामध्ये प्रवेश करा'**
  String get loginSubtitle;

  /// No description provided for @username.
  ///
  /// In mr, this message translates to:
  /// **'वापरकर्ता नाव'**
  String get username;

  /// No description provided for @password.
  ///
  /// In mr, this message translates to:
  /// **'पासवर्ड'**
  String get password;

  /// No description provided for @loginButton.
  ///
  /// In mr, this message translates to:
  /// **'लॉगिन करा'**
  String get loginButton;

  /// No description provided for @usernameRequired.
  ///
  /// In mr, this message translates to:
  /// **'कृपया वापरकर्ता नाव प्रविष्ट करा'**
  String get usernameRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In mr, this message translates to:
  /// **'कृपया पासवर्ड प्रविष्ट करा'**
  String get passwordRequired;

  /// No description provided for @demoLoginHint.
  ///
  /// In mr, this message translates to:
  /// **'डेमो आवृत्ती: कोणतेही वापरकर्ता नाव आणि पासवर्ड वापरू शकता (उदा. admin / 123456)'**
  String get demoLoginHint;

  /// No description provided for @logout.
  ///
  /// In mr, this message translates to:
  /// **'लॉगआउट करा'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In mr, this message translates to:
  /// **'तुम्हाला खात्री आहे की तुम्ही बाहेर पडू इच्छिता?'**
  String get logoutConfirm;

  /// No description provided for @dashboardTitle.
  ///
  /// In mr, this message translates to:
  /// **'डॅशबोर्ड'**
  String get dashboardTitle;

  /// No description provided for @totalBooks.
  ///
  /// In mr, this message translates to:
  /// **'एकूण पुस्तके'**
  String get totalBooks;

  /// No description provided for @availableCopies.
  ///
  /// In mr, this message translates to:
  /// **'उपलब्ध प्रती'**
  String get availableCopies;

  /// No description provided for @issuedBooks.
  ///
  /// In mr, this message translates to:
  /// **'दिलेली पुस्तके'**
  String get issuedBooks;

  /// No description provided for @totalMembers.
  ///
  /// In mr, this message translates to:
  /// **'एकूण सभासद'**
  String get totalMembers;

  /// No description provided for @overdueBooks.
  ///
  /// In mr, this message translates to:
  /// **'मुदत संपलेली पुस्तके'**
  String get overdueBooks;

  /// No description provided for @quickActions.
  ///
  /// In mr, this message translates to:
  /// **'त्वरित कृती'**
  String get quickActions;

  /// No description provided for @quickAddBook.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक जोडा'**
  String get quickAddBook;

  /// No description provided for @quickIssueBook.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक द्या'**
  String get quickIssueBook;

  /// No description provided for @quickReturnBook.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक परत घ्या'**
  String get quickReturnBook;

  /// No description provided for @quickSearchPerson.
  ///
  /// In mr, this message translates to:
  /// **'व्यक्ती शोधा'**
  String get quickSearchPerson;

  /// No description provided for @quickReports.
  ///
  /// In mr, this message translates to:
  /// **'अहवाल'**
  String get quickReports;

  /// No description provided for @recentTransactions.
  ///
  /// In mr, this message translates to:
  /// **'अलीकडील व्यवहार'**
  String get recentTransactions;

  /// No description provided for @viewAll.
  ///
  /// In mr, this message translates to:
  /// **'सर्व पहा'**
  String get viewAll;

  /// No description provided for @noRecentTransactions.
  ///
  /// In mr, this message translates to:
  /// **'कोणतेही अलीकडील व्यवहार आढळले नाहीत.'**
  String get noRecentTransactions;

  /// No description provided for @booksTitle.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तकांची यादी'**
  String get booksTitle;

  /// No description provided for @searchBooksPlaceholder.
  ///
  /// In mr, this message translates to:
  /// **'नाव, लेखक, संकेतांक किंवा वर्गवारी शोधा...'**
  String get searchBooksPlaceholder;

  /// No description provided for @filterAll.
  ///
  /// In mr, this message translates to:
  /// **'सर्व'**
  String get filterAll;

  /// No description provided for @filterAvailable.
  ///
  /// In mr, this message translates to:
  /// **'उपलब्ध'**
  String get filterAvailable;

  /// No description provided for @filterUnavailable.
  ///
  /// In mr, this message translates to:
  /// **'अनुपलब्ध'**
  String get filterUnavailable;

  /// No description provided for @filterCategory.
  ///
  /// In mr, this message translates to:
  /// **'वर्गवारी'**
  String get filterCategory;

  /// No description provided for @sortBy.
  ///
  /// In mr, this message translates to:
  /// **'क्रमवारी'**
  String get sortBy;

  /// No description provided for @sortByTitle.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तकाचे नाव'**
  String get sortByTitle;

  /// No description provided for @sortByAuthor.
  ///
  /// In mr, this message translates to:
  /// **'लेखक'**
  String get sortByAuthor;

  /// No description provided for @sortByCode.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक कोड'**
  String get sortByCode;

  /// No description provided for @sortByAvailable.
  ///
  /// In mr, this message translates to:
  /// **'उपलब्ध प्रती'**
  String get sortByAvailable;

  /// No description provided for @addBook.
  ///
  /// In mr, this message translates to:
  /// **'नवीन पुस्तक जोडा'**
  String get addBook;

  /// No description provided for @editBook.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक संपादित करा'**
  String get editBook;

  /// No description provided for @deleteBook.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक हटवा'**
  String get deleteBook;

  /// No description provided for @deleteBookConfirm.
  ///
  /// In mr, this message translates to:
  /// **'तुम्हाला हे पुस्तक खरोखर हटवायचे आहे का? ही क्रिया स्थानिक डेमो डेटातून पुस्तक हटवेल.'**
  String get deleteBookConfirm;

  /// No description provided for @bookDetails.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तकाचा तपशील'**
  String get bookDetails;

  /// No description provided for @bookCode.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक संकेतांक'**
  String get bookCode;

  /// No description provided for @bookTitle.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तकाचे नाव'**
  String get bookTitle;

  /// No description provided for @bookTitleHint.
  ///
  /// In mr, this message translates to:
  /// **'उदा. मृत्युंजय / Mrityunjay'**
  String get bookTitleHint;

  /// No description provided for @bookTitleRequired.
  ///
  /// In mr, this message translates to:
  /// **'कृपया पुस्तकाचे नाव प्रविष्ट करा'**
  String get bookTitleRequired;

  /// No description provided for @author.
  ///
  /// In mr, this message translates to:
  /// **'लेखक'**
  String get author;

  /// No description provided for @authorHint.
  ///
  /// In mr, this message translates to:
  /// **'उदा. शिवाजी सावंत / Shivaji Sawant'**
  String get authorHint;

  /// No description provided for @bookAuthorRequired.
  ///
  /// In mr, this message translates to:
  /// **'कृपया लेखकाचे नाव प्रविष्ट करा'**
  String get bookAuthorRequired;

  /// No description provided for @titleMarathi.
  ///
  /// In mr, this message translates to:
  /// **'मराठी नाव'**
  String get titleMarathi;

  /// No description provided for @titleEnglish.
  ///
  /// In mr, this message translates to:
  /// **'इंग्रजी नाव'**
  String get titleEnglish;

  /// No description provided for @authorMarathi.
  ///
  /// In mr, this message translates to:
  /// **'मराठी लेखक'**
  String get authorMarathi;

  /// No description provided for @authorEnglish.
  ///
  /// In mr, this message translates to:
  /// **'इंग्रजी लेखक'**
  String get authorEnglish;

  /// No description provided for @category.
  ///
  /// In mr, this message translates to:
  /// **'वर्गवारी'**
  String get category;

  /// No description provided for @isbn.
  ///
  /// In mr, this message translates to:
  /// **'ISBN क्रमांक'**
  String get isbn;

  /// No description provided for @publisher.
  ///
  /// In mr, this message translates to:
  /// **'प्रकाशक'**
  String get publisher;

  /// No description provided for @publicationYear.
  ///
  /// In mr, this message translates to:
  /// **'प्रकाशन वर्ष'**
  String get publicationYear;

  /// No description provided for @totalCopiesLabel.
  ///
  /// In mr, this message translates to:
  /// **'एकूण प्रती'**
  String get totalCopiesLabel;

  /// No description provided for @availableCopiesLabel.
  ///
  /// In mr, this message translates to:
  /// **'उपलब्ध प्रती'**
  String get availableCopiesLabel;

  /// No description provided for @bookCopiesCount.
  ///
  /// In mr, this message translates to:
  /// **'{available} / {total} प्रती उपलब्ध'**
  String bookCopiesCount(int available, int total);

  /// No description provided for @membersTitle.
  ///
  /// In mr, this message translates to:
  /// **'सभासदांची यादी'**
  String get membersTitle;

  /// No description provided for @searchMembersPlaceholder.
  ///
  /// In mr, this message translates to:
  /// **'नाव, फोन नंबर किंवा सभासद कोड शोधा...'**
  String get searchMembersPlaceholder;

  /// No description provided for @addMember.
  ///
  /// In mr, this message translates to:
  /// **'नवीन सभासद जोडा'**
  String get addMember;

  /// No description provided for @editMember.
  ///
  /// In mr, this message translates to:
  /// **'सभासद संपादित करा'**
  String get editMember;

  /// No description provided for @deleteMember.
  ///
  /// In mr, this message translates to:
  /// **'सभासद हटवा'**
  String get deleteMember;

  /// No description provided for @deleteMemberConfirm.
  ///
  /// In mr, this message translates to:
  /// **'तुम्हाला हा सभासद खरोखर हटवायचा आहे का?'**
  String get deleteMemberConfirm;

  /// No description provided for @memberDetails.
  ///
  /// In mr, this message translates to:
  /// **'सभासदाचा तपशील'**
  String get memberDetails;

  /// No description provided for @memberCode.
  ///
  /// In mr, this message translates to:
  /// **'सभासद संकेतांक'**
  String get memberCode;

  /// No description provided for @fullName.
  ///
  /// In mr, this message translates to:
  /// **'पूर्ण नाव'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In mr, this message translates to:
  /// **'उदा. राहुल पाटील / Rahul Patil'**
  String get fullNameHint;

  /// No description provided for @fullNameRequired.
  ///
  /// In mr, this message translates to:
  /// **'कृपया पूर्ण नाव प्रविष्ट करा'**
  String get fullNameRequired;

  /// No description provided for @memberNameMarathi.
  ///
  /// In mr, this message translates to:
  /// **'मराठीत पूर्ण नाव'**
  String get memberNameMarathi;

  /// No description provided for @memberNameEnglish.
  ///
  /// In mr, this message translates to:
  /// **'इंग्रजीत पूर्ण नाव'**
  String get memberNameEnglish;

  /// No description provided for @phoneNumber.
  ///
  /// In mr, this message translates to:
  /// **'मोबाईल नंबर'**
  String get phoneNumber;

  /// No description provided for @emailAddress.
  ///
  /// In mr, this message translates to:
  /// **'ईमेल पत्ता'**
  String get emailAddress;

  /// No description provided for @address.
  ///
  /// In mr, this message translates to:
  /// **'पत्ता'**
  String get address;

  /// No description provided for @departmentClass.
  ///
  /// In mr, this message translates to:
  /// **'विभाग / वर्ग'**
  String get departmentClass;

  /// No description provided for @currentlyBorrowed.
  ///
  /// In mr, this message translates to:
  /// **'सध्या घेतलेली पुस्तके'**
  String get currentlyBorrowed;

  /// No description provided for @returnedBooks.
  ///
  /// In mr, this message translates to:
  /// **'परत केलेली पुस्तके'**
  String get returnedBooks;

  /// No description provided for @totalBorrowRecords.
  ///
  /// In mr, this message translates to:
  /// **'एकूण व्यवहार'**
  String get totalBorrowRecords;

  /// No description provided for @currentOverdueCount.
  ///
  /// In mr, this message translates to:
  /// **'मुदत संपलेली पुस्तके'**
  String get currentOverdueCount;

  /// No description provided for @viewBorrowHistory.
  ///
  /// In mr, this message translates to:
  /// **'पूर्ण इतिहास पहा'**
  String get viewBorrowHistory;

  /// No description provided for @issueBookTitle.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक वाटप करा'**
  String get issueBookTitle;

  /// No description provided for @stepSelectMember.
  ///
  /// In mr, this message translates to:
  /// **'१. सभासद निवडा'**
  String get stepSelectMember;

  /// No description provided for @stepSelectBook.
  ///
  /// In mr, this message translates to:
  /// **'२. पुस्तक निवडा'**
  String get stepSelectBook;

  /// No description provided for @stepDates.
  ///
  /// In mr, this message translates to:
  /// **'३. दिनांक निवडा'**
  String get stepDates;

  /// No description provided for @stepConfirm.
  ///
  /// In mr, this message translates to:
  /// **'४. पुष्टीकरण'**
  String get stepConfirm;

  /// No description provided for @selectMemberPrompt.
  ///
  /// In mr, this message translates to:
  /// **'सभासद शोधा किंवा निवडा'**
  String get selectMemberPrompt;

  /// No description provided for @selectBookPrompt.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक शोधा किंवा निवडा'**
  String get selectBookPrompt;

  /// No description provided for @issueDate.
  ///
  /// In mr, this message translates to:
  /// **'वाटप दिनांक'**
  String get issueDate;

  /// No description provided for @dueDate.
  ///
  /// In mr, this message translates to:
  /// **'परत करण्याची तारीख'**
  String get dueDate;

  /// No description provided for @returnDate.
  ///
  /// In mr, this message translates to:
  /// **'परत आलेली तारीख'**
  String get returnDate;

  /// No description provided for @issueSuccess.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक यशस्वीरित्या वाटप करण्यात आले (डेमो व्यवहार).'**
  String get issueSuccess;

  /// No description provided for @noCopiesAvailableError.
  ///
  /// In mr, this message translates to:
  /// **'या पुस्तकाची कोणतीही प्रत उपलब्ध नाही!'**
  String get noCopiesAvailableError;

  /// No description provided for @selectMemberAndBookError.
  ///
  /// In mr, this message translates to:
  /// **'कृपया आधी सभासद आणि पुस्तक दोन्ही निवडा.'**
  String get selectMemberAndBookError;

  /// No description provided for @dueDateBeforeIssueDateError.
  ///
  /// In mr, this message translates to:
  /// **'परत करण्याची तारीख वाटप तारखेपेक्षा आधीची असू शकत नाही.'**
  String get dueDateBeforeIssueDateError;

  /// No description provided for @confirmIssueButton.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक वाटप निश्चित करा'**
  String get confirmIssueButton;

  /// No description provided for @returnBookTitle.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक परत जमा'**
  String get returnBookTitle;

  /// No description provided for @searchIssuedRecordPlaceholder.
  ///
  /// In mr, this message translates to:
  /// **'सभासदाचे नाव किंवा पुस्तक शोधा...'**
  String get searchIssuedRecordPlaceholder;

  /// No description provided for @returnConfirmPrompt.
  ///
  /// In mr, this message translates to:
  /// **'तुम्हाला खात्री आहे की हे पुस्तक परत जमा करायचे आहे?'**
  String get returnConfirmPrompt;

  /// No description provided for @returnSuccess.
  ///
  /// In mr, this message translates to:
  /// **'पुस्तक यशस्वीरित्या परत जमा झाले (डेमो व्यवहार).'**
  String get returnSuccess;

  /// No description provided for @recordAlreadyReturned.
  ///
  /// In mr, this message translates to:
  /// **'हे पुस्तक आधीच परत जमा करण्यात आले आहे.'**
  String get recordAlreadyReturned;

  /// No description provided for @activeIssuedRecords.
  ///
  /// In mr, this message translates to:
  /// **'सध्या दिलेली पुस्तके'**
  String get activeIssuedRecords;

  /// No description provided for @markAsReturned.
  ///
  /// In mr, this message translates to:
  /// **'परत जमा करा'**
  String get markAsReturned;

  /// No description provided for @searchPersonTitle.
  ///
  /// In mr, this message translates to:
  /// **'व्यक्ती शोधा'**
  String get searchPersonTitle;

  /// No description provided for @searchPersonSubtitle.
  ///
  /// In mr, this message translates to:
  /// **'मराठी किंवा इंग्रजीत नाव, अथवा सभासद कोड टाईप करा'**
  String get searchPersonSubtitle;

  /// No description provided for @searchPersonPlaceholder.
  ///
  /// In mr, this message translates to:
  /// **'उदा. राहुल पाटील, Rahul Patil, M001...'**
  String get searchPersonPlaceholder;

  /// No description provided for @searchPersonNoResults.
  ///
  /// In mr, this message translates to:
  /// **'कोणताही सभासद सापडला नाही. कृपया वेगळा शब्द शोधा.'**
  String get searchPersonNoResults;

  /// No description provided for @searchPersonHelperText.
  ///
  /// In mr, this message translates to:
  /// **'स्थानिक डेमो नोंदी शोधत आहे (स्प्रिंग बूट API जोडल्यानंतर संपूर्ण सर्व्हर डेटा शोधला जाईल).'**
  String get searchPersonHelperText;

  /// No description provided for @historyTitle.
  ///
  /// In mr, this message translates to:
  /// **'देवाणघेवाण इतिहास'**
  String get historyTitle;

  /// No description provided for @historyFilterAll.
  ///
  /// In mr, this message translates to:
  /// **'सर्व व्यवहार'**
  String get historyFilterAll;

  /// No description provided for @historyFilterIssued.
  ///
  /// In mr, this message translates to:
  /// **'सध्या दिलेली'**
  String get historyFilterIssued;

  /// No description provided for @historyFilterReturned.
  ///
  /// In mr, this message translates to:
  /// **'परत आलेली'**
  String get historyFilterReturned;

  /// No description provided for @historyFilterOverdue.
  ///
  /// In mr, this message translates to:
  /// **'मुदत संपलेली'**
  String get historyFilterOverdue;

  /// No description provided for @noHistoryFound.
  ///
  /// In mr, this message translates to:
  /// **'या सभासदाचा कोणताही व्यवहार इतिहास उपलब्ध नाही.'**
  String get noHistoryFound;

  /// No description provided for @daysOverdue.
  ///
  /// In mr, this message translates to:
  /// **'{days} दिवस विलंब'**
  String daysOverdue(int days);

  /// No description provided for @daysRemaining.
  ///
  /// In mr, this message translates to:
  /// **'{days} दिवस शिल्लक'**
  String daysRemaining(int days);

  /// No description provided for @currentlyIssuedTitle.
  ///
  /// In mr, this message translates to:
  /// **'सध्या वाटप झालेली पुस्तके'**
  String get currentlyIssuedTitle;

  /// No description provided for @overdueBooksTitle.
  ///
  /// In mr, this message translates to:
  /// **'मुदत संपलेली पुस्तके'**
  String get overdueBooksTitle;

  /// No description provided for @overdueWarning.
  ///
  /// In mr, this message translates to:
  /// **'कृपया संबंधित सभासदाशी संपर्क साधून पुस्तक परत जमा करून घ्या.'**
  String get overdueWarning;

  /// No description provided for @reportsTitle.
  ///
  /// In mr, this message translates to:
  /// **'ग्रंथालय अहवाल'**
  String get reportsTitle;

  /// No description provided for @reportTotalTitles.
  ///
  /// In mr, this message translates to:
  /// **'एकूण पुस्तकांची शीर्षके'**
  String get reportTotalTitles;

  /// No description provided for @reportTotalCopies.
  ///
  /// In mr, this message translates to:
  /// **'एकूण उपलब्ध प्रती'**
  String get reportTotalCopies;

  /// No description provided for @reportIssuedCopies.
  ///
  /// In mr, this message translates to:
  /// **'सध्या वाटप केलेल्या प्रती'**
  String get reportIssuedCopies;

  /// No description provided for @reportTotalMembers.
  ///
  /// In mr, this message translates to:
  /// **'नोंदणीकृत सभासद'**
  String get reportTotalMembers;

  /// No description provided for @reportTotalReturns.
  ///
  /// In mr, this message translates to:
  /// **'यशस्वी परत व्यवहार'**
  String get reportTotalReturns;

  /// No description provided for @reportOverdueCount.
  ///
  /// In mr, this message translates to:
  /// **'सध्याची मुदत संपलेली पुस्तके'**
  String get reportOverdueCount;

  /// No description provided for @categoryDistribution.
  ///
  /// In mr, this message translates to:
  /// **'वर्गवारीनुसार पुस्तके'**
  String get categoryDistribution;

  /// No description provided for @statisticsCalculated.
  ///
  /// In mr, this message translates to:
  /// **'सर्व आकडेवारी स्थानिक नोंदींवरून मोजलेली आहे.'**
  String get statisticsCalculated;

  /// No description provided for @settingsTitle.
  ///
  /// In mr, this message translates to:
  /// **'सेटिंग्ज'**
  String get settingsTitle;

  /// No description provided for @languagePreference.
  ///
  /// In mr, this message translates to:
  /// **'भाषा निवडा'**
  String get languagePreference;

  /// No description provided for @marathiLanguage.
  ///
  /// In mr, this message translates to:
  /// **'मराठी (Marathi)'**
  String get marathiLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In mr, this message translates to:
  /// **'English (इंग्रजी)'**
  String get englishLanguage;

  /// No description provided for @languageChangedMsg.
  ///
  /// In mr, this message translates to:
  /// **'भाषा यशस्वीरित्या बदलली.'**
  String get languageChangedMsg;

  /// No description provided for @libraryInfo.
  ///
  /// In mr, this message translates to:
  /// **'ग्रंथालय माहिती'**
  String get libraryInfo;

  /// No description provided for @libraryAddress.
  ///
  /// In mr, this message translates to:
  /// **'कोथळी, ता. शिरोळ जि. कोल्हापूर (महाराष्ट्र)'**
  String get libraryAddress;

  /// No description provided for @libraryContact.
  ///
  /// In mr, this message translates to:
  /// **'निलेश: 9011441477, सचिन: 9075086108'**
  String get libraryContact;

  /// No description provided for @granthalayDetails.
  ///
  /// In mr, this message translates to:
  /// **'ग्रंथालय माहिती'**
  String get granthalayDetails;

  /// No description provided for @establishment.
  ///
  /// In mr, this message translates to:
  /// **'स्थापना: 18-06-2018'**
  String get establishment;

  /// No description provided for @locationVillage.
  ///
  /// In mr, this message translates to:
  /// **'कोथळी'**
  String get locationVillage;

  /// No description provided for @locationTalukaDist.
  ///
  /// In mr, this message translates to:
  /// **'ता. शिरोळ जि. कोल्हापूर (महाराष्ट्र)'**
  String get locationTalukaDist;

  /// No description provided for @contact.
  ///
  /// In mr, this message translates to:
  /// **'संपर्क'**
  String get contact;

  /// No description provided for @contactNilesh.
  ///
  /// In mr, this message translates to:
  /// **'निलेश 9011441477'**
  String get contactNilesh;

  /// No description provided for @contactSachin.
  ///
  /// In mr, this message translates to:
  /// **'सचिन 9075086108'**
  String get contactSachin;

  /// No description provided for @appVersion.
  ///
  /// In mr, this message translates to:
  /// **'अॅप आवृत्ती'**
  String get appVersion;

  /// No description provided for @apiConfiguration.
  ///
  /// In mr, this message translates to:
  /// **'स्प्रिंग बूट REST API सेटिंग्ज'**
  String get apiConfiguration;

  /// No description provided for @apiBaseUrl.
  ///
  /// In mr, this message translates to:
  /// **'API बेस URL'**
  String get apiBaseUrl;

  /// No description provided for @apiStatusConnected.
  ///
  /// In mr, this message translates to:
  /// **'API तयार (भविष्यातील जोडणी)'**
  String get apiStatusConnected;

  /// No description provided for @apiStatusDemo.
  ///
  /// In mr, this message translates to:
  /// **'स्थानिक डेमो मोड चालू आहे'**
  String get apiStatusDemo;

  /// No description provided for @saveApiSettings.
  ///
  /// In mr, this message translates to:
  /// **'API URL जतन करा'**
  String get saveApiSettings;

  /// No description provided for @statusAvailable.
  ///
  /// In mr, this message translates to:
  /// **'उपलब्ध'**
  String get statusAvailable;

  /// No description provided for @statusUnavailable.
  ///
  /// In mr, this message translates to:
  /// **'संपले'**
  String get statusUnavailable;

  /// No description provided for @statusIssued.
  ///
  /// In mr, this message translates to:
  /// **'वाटप केलेले'**
  String get statusIssued;

  /// No description provided for @statusReturned.
  ///
  /// In mr, this message translates to:
  /// **'परत आलेले'**
  String get statusReturned;

  /// No description provided for @statusOverdue.
  ///
  /// In mr, this message translates to:
  /// **'मुदत संपलेली'**
  String get statusOverdue;

  /// No description provided for @save.
  ///
  /// In mr, this message translates to:
  /// **'जतन करा'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In mr, this message translates to:
  /// **'रद्द करा'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In mr, this message translates to:
  /// **'पुष्टी करा'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In mr, this message translates to:
  /// **'बंद करा'**
  String get close;

  /// No description provided for @search.
  ///
  /// In mr, this message translates to:
  /// **'शोधा'**
  String get search;

  /// No description provided for @clear.
  ///
  /// In mr, this message translates to:
  /// **'साफ करा'**
  String get clear;

  /// No description provided for @filter.
  ///
  /// In mr, this message translates to:
  /// **'फिल्टर'**
  String get filter;

  /// No description provided for @nameRequired.
  ///
  /// In mr, this message translates to:
  /// **'किमान एक नाव (मराठी किंवा इंग्रजी) आवश्यक आहे'**
  String get nameRequired;

  /// No description provided for @authorRequired.
  ///
  /// In mr, this message translates to:
  /// **'किमान एक लेखक (मराठी किंवा इंग्रजी) आवश्यक आहे'**
  String get authorRequired;

  /// No description provided for @codeRequired.
  ///
  /// In mr, this message translates to:
  /// **'संकेतांक आवश्यक आहे'**
  String get codeRequired;

  /// No description provided for @positiveNumberRequired.
  ///
  /// In mr, this message translates to:
  /// **'कृपया वैध संख्या प्रविष्ट करा'**
  String get positiveNumberRequired;

  /// No description provided for @successSaved.
  ///
  /// In mr, this message translates to:
  /// **'यशस्वीरित्या जतन झाले!'**
  String get successSaved;

  /// No description provided for @successUpdated.
  ///
  /// In mr, this message translates to:
  /// **'यशस्वीरित्या अद्यतनित झाले!'**
  String get successUpdated;

  /// No description provided for @successDeleted.
  ///
  /// In mr, this message translates to:
  /// **'यशस्वीरित्या हटवले गेले!'**
  String get successDeleted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
