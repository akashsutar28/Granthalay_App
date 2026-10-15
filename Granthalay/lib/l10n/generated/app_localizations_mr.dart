// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'ग्रंथालय';

  @override
  String get appSubtitle => 'वाचनालय व्यवस्थापन प्रणाली';

  @override
  String get libraryName => 'वसंत दादाश्री जिनवाणी महाग्रंथालय';

  @override
  String get demoModeNotice => 'डेमो मोड सक्रिय (स्थानिक डेटा)';

  @override
  String get apiReadyNotice => 'स्प्रिंग बूट API जोडणीसाठी तयार';

  @override
  String get navHome => 'मुख्यपृष्ठ';

  @override
  String get navBooks => 'पुस्तके';

  @override
  String get navMembers => 'सभासद';

  @override
  String get navTransactions => 'व्यवहार';

  @override
  String get navSettings => 'सेटिंग्ज';

  @override
  String get loginTitle => 'ग्रंथपाल लॉगिन';

  @override
  String get loginSubtitle => 'आपल्या खात्यामध्ये प्रवेश करा';

  @override
  String get username => 'वापरकर्ता नाव';

  @override
  String get password => 'पासवर्ड';

  @override
  String get loginButton => 'लॉगिन करा';

  @override
  String get usernameRequired => 'कृपया वापरकर्ता नाव प्रविष्ट करा';

  @override
  String get passwordRequired => 'कृपया पासवर्ड प्रविष्ट करा';

  @override
  String get demoLoginHint =>
      'डेमो आवृत्ती: कोणतेही वापरकर्ता नाव आणि पासवर्ड वापरू शकता (उदा. admin / 123456)';

  @override
  String get logout => 'लॉगआउट करा';

  @override
  String get logoutConfirm =>
      'तुम्हाला खात्री आहे की तुम्ही बाहेर पडू इच्छिता?';

  @override
  String get dashboardTitle => 'डॅशबोर्ड';

  @override
  String get totalBooks => 'एकूण पुस्तके';

  @override
  String get availableCopies => 'उपलब्ध प्रती';

  @override
  String get issuedBooks => 'दिलेली पुस्तके';

  @override
  String get totalMembers => 'एकूण सभासद';

  @override
  String get overdueBooks => 'मुदत संपलेली पुस्तके';

  @override
  String get quickActions => 'त्वरित कृती';

  @override
  String get quickAddBook => 'पुस्तक जोडा';

  @override
  String get quickIssueBook => 'पुस्तक द्या';

  @override
  String get quickReturnBook => 'पुस्तक परत घ्या';

  @override
  String get quickSearchPerson => 'व्यक्ती शोधा';

  @override
  String get quickReports => 'अहवाल';

  @override
  String get recentTransactions => 'अलीकडील व्यवहार';

  @override
  String get viewAll => 'सर्व पहा';

  @override
  String get noRecentTransactions => 'कोणतेही अलीकडील व्यवहार आढळले नाहीत.';

  @override
  String get booksTitle => 'पुस्तकांची यादी';

  @override
  String get searchBooksPlaceholder =>
      'नाव, लेखक, संकेतांक किंवा वर्गवारी शोधा...';

  @override
  String get filterAll => 'सर्व';

  @override
  String get filterAvailable => 'उपलब्ध';

  @override
  String get filterUnavailable => 'अनुपलब्ध';

  @override
  String get filterCategory => 'वर्गवारी';

  @override
  String get sortBy => 'क्रमवारी';

  @override
  String get sortByTitle => 'पुस्तकाचे नाव';

  @override
  String get sortByAuthor => 'लेखक';

  @override
  String get sortByCode => 'पुस्तक कोड';

  @override
  String get sortByAvailable => 'उपलब्ध प्रती';

  @override
  String get addBook => 'नवीन पुस्तक जोडा';

  @override
  String get editBook => 'पुस्तक संपादित करा';

  @override
  String get deleteBook => 'पुस्तक हटवा';

  @override
  String get deleteBookConfirm =>
      'तुम्हाला हे पुस्तक खरोखर हटवायचे आहे का? ही क्रिया स्थानिक डेमो डेटातून पुस्तक हटवेल.';

  @override
  String get bookDetails => 'पुस्तकाचा तपशील';

  @override
  String get bookCode => 'पुस्तक संकेतांक';

  @override
  String get bookTitle => 'पुस्तकाचे नाव';

  @override
  String get bookTitleHint => 'उदा. मृत्युंजय / Mrityunjay';

  @override
  String get bookTitleRequired => 'कृपया पुस्तकाचे नाव प्रविष्ट करा';

  @override
  String get author => 'लेखक';

  @override
  String get authorHint => 'उदा. शिवाजी सावंत / Shivaji Sawant';

  @override
  String get bookAuthorRequired => 'कृपया लेखकाचे नाव प्रविष्ट करा';

  @override
  String get titleMarathi => 'मराठी नाव';

  @override
  String get titleEnglish => 'इंग्रजी नाव';

  @override
  String get authorMarathi => 'मराठी लेखक';

  @override
  String get authorEnglish => 'इंग्रजी लेखक';

  @override
  String get category => 'वर्गवारी';

  @override
  String get isbn => 'ISBN क्रमांक';

  @override
  String get publisher => 'प्रकाशक';

  @override
  String get publicationYear => 'प्रकाशन वर्ष';

  @override
  String get totalCopiesLabel => 'एकूण प्रती';

  @override
  String get availableCopiesLabel => 'उपलब्ध प्रती';

  @override
  String bookCopiesCount(int available, int total) {
    return '$available / $total प्रती उपलब्ध';
  }

  @override
  String get membersTitle => 'सभासदांची यादी';

  @override
  String get searchMembersPlaceholder =>
      'नाव, फोन नंबर किंवा सभासद कोड शोधा...';

  @override
  String get addMember => 'नवीन सभासद जोडा';

  @override
  String get editMember => 'सभासद संपादित करा';

  @override
  String get deleteMember => 'सभासद हटवा';

  @override
  String get deleteMemberConfirm => 'तुम्हाला हा सभासद खरोखर हटवायचा आहे का?';

  @override
  String get memberDetails => 'सभासदाचा तपशील';

  @override
  String get memberCode => 'सभासद संकेतांक';

  @override
  String get fullName => 'पूर्ण नाव';

  @override
  String get fullNameHint => 'उदा. राहुल पाटील / Rahul Patil';

  @override
  String get fullNameRequired => 'कृपया पूर्ण नाव प्रविष्ट करा';

  @override
  String get memberNameMarathi => 'मराठीत पूर्ण नाव';

  @override
  String get memberNameEnglish => 'इंग्रजीत पूर्ण नाव';

  @override
  String get phoneNumber => 'मोबाईल नंबर';

  @override
  String get emailAddress => 'ईमेल पत्ता';

  @override
  String get address => 'पत्ता';

  @override
  String get departmentClass => 'विभाग / वर्ग';

  @override
  String get currentlyBorrowed => 'सध्या घेतलेली पुस्तके';

  @override
  String get returnedBooks => 'परत केलेली पुस्तके';

  @override
  String get totalBorrowRecords => 'एकूण व्यवहार';

  @override
  String get currentOverdueCount => 'मुदत संपलेली पुस्तके';

  @override
  String get viewBorrowHistory => 'पूर्ण इतिहास पहा';

  @override
  String get issueBookTitle => 'पुस्तक वाटप करा';

  @override
  String get stepSelectMember => '१. सभासद निवडा';

  @override
  String get stepSelectBook => '२. पुस्तक निवडा';

  @override
  String get stepDates => '३. दिनांक निवडा';

  @override
  String get stepConfirm => '४. पुष्टीकरण';

  @override
  String get selectMemberPrompt => 'सभासद शोधा किंवा निवडा';

  @override
  String get selectBookPrompt => 'पुस्तक शोधा किंवा निवडा';

  @override
  String get issueDate => 'वाटप दिनांक';

  @override
  String get dueDate => 'परत करण्याची तारीख';

  @override
  String get returnDate => 'परत आलेली तारीख';

  @override
  String get issueSuccess =>
      'पुस्तक यशस्वीरित्या वाटप करण्यात आले (डेमो व्यवहार).';

  @override
  String get noCopiesAvailableError => 'या पुस्तकाची कोणतीही प्रत उपलब्ध नाही!';

  @override
  String get selectMemberAndBookError =>
      'कृपया आधी सभासद आणि पुस्तक दोन्ही निवडा.';

  @override
  String get dueDateBeforeIssueDateError =>
      'परत करण्याची तारीख वाटप तारखेपेक्षा आधीची असू शकत नाही.';

  @override
  String get confirmIssueButton => 'पुस्तक वाटप निश्चित करा';

  @override
  String get returnBookTitle => 'पुस्तक परत जमा';

  @override
  String get searchIssuedRecordPlaceholder =>
      'सभासदाचे नाव किंवा पुस्तक शोधा...';

  @override
  String get returnConfirmPrompt =>
      'तुम्हाला खात्री आहे की हे पुस्तक परत जमा करायचे आहे?';

  @override
  String get returnSuccess =>
      'पुस्तक यशस्वीरित्या परत जमा झाले (डेमो व्यवहार).';

  @override
  String get recordAlreadyReturned => 'हे पुस्तक आधीच परत जमा करण्यात आले आहे.';

  @override
  String get activeIssuedRecords => 'सध्या दिलेली पुस्तके';

  @override
  String get markAsReturned => 'परत जमा करा';

  @override
  String get searchPersonTitle => 'व्यक्ती शोधा';

  @override
  String get searchPersonSubtitle =>
      'मराठी किंवा इंग्रजीत नाव, अथवा सभासद कोड टाईप करा';

  @override
  String get searchPersonPlaceholder =>
      'उदा. राहुल पाटील, Rahul Patil, M001...';

  @override
  String get searchPersonNoResults =>
      'कोणताही सभासद सापडला नाही. कृपया वेगळा शब्द शोधा.';

  @override
  String get searchPersonHelperText =>
      'स्थानिक डेमो नोंदी शोधत आहे (स्प्रिंग बूट API जोडल्यानंतर संपूर्ण सर्व्हर डेटा शोधला जाईल).';

  @override
  String get historyTitle => 'देवाणघेवाण इतिहास';

  @override
  String get historyFilterAll => 'सर्व व्यवहार';

  @override
  String get historyFilterIssued => 'सध्या दिलेली';

  @override
  String get historyFilterReturned => 'परत आलेली';

  @override
  String get historyFilterOverdue => 'मुदत संपलेली';

  @override
  String get noHistoryFound =>
      'या सभासदाचा कोणताही व्यवहार इतिहास उपलब्ध नाही.';

  @override
  String daysOverdue(int days) {
    return '$days दिवस विलंब';
  }

  @override
  String daysRemaining(int days) {
    return '$days दिवस शिल्लक';
  }

  @override
  String get currentlyIssuedTitle => 'सध्या वाटप झालेली पुस्तके';

  @override
  String get overdueBooksTitle => 'मुदत संपलेली पुस्तके';

  @override
  String get overdueWarning =>
      'कृपया संबंधित सभासदाशी संपर्क साधून पुस्तक परत जमा करून घ्या.';

  @override
  String get reportsTitle => 'ग्रंथालय अहवाल';

  @override
  String get reportTotalTitles => 'एकूण पुस्तकांची शीर्षके';

  @override
  String get reportTotalCopies => 'एकूण उपलब्ध प्रती';

  @override
  String get reportIssuedCopies => 'सध्या वाटप केलेल्या प्रती';

  @override
  String get reportTotalMembers => 'नोंदणीकृत सभासद';

  @override
  String get reportTotalReturns => 'यशस्वी परत व्यवहार';

  @override
  String get reportOverdueCount => 'सध्याची मुदत संपलेली पुस्तके';

  @override
  String get categoryDistribution => 'वर्गवारीनुसार पुस्तके';

  @override
  String get statisticsCalculated =>
      'सर्व आकडेवारी स्थानिक नोंदींवरून मोजलेली आहे.';

  @override
  String get settingsTitle => 'सेटिंग्ज';

  @override
  String get languagePreference => 'भाषा निवडा';

  @override
  String get marathiLanguage => 'मराठी (Marathi)';

  @override
  String get englishLanguage => 'English (इंग्रजी)';

  @override
  String get languageChangedMsg => 'भाषा यशस्वीरित्या बदलली.';

  @override
  String get libraryInfo => 'ग्रंथालय माहिती';

  @override
  String get libraryAddress => 'कोथळी, ता. शिरोळ जि. कोल्हापूर (महाराष्ट्र)';

  @override
  String get libraryContact => 'निलेश: 9011441477, सचिन: 9075086108';

  @override
  String get granthalayDetails => 'ग्रंथालय माहिती';

  @override
  String get establishment => 'स्थापना: 18-06-2018';

  @override
  String get locationVillage => 'कोथळी';

  @override
  String get locationTalukaDist => 'ता. शिरोळ जि. कोल्हापूर (महाराष्ट्र)';

  @override
  String get contact => 'संपर्क';

  @override
  String get contactNilesh => 'निलेश 9011441477';

  @override
  String get contactSachin => 'सचिन 9075086108';

  @override
  String get appVersion => 'अॅप आवृत्ती';

  @override
  String get apiConfiguration => 'स्प्रिंग बूट REST API सेटिंग्ज';

  @override
  String get apiBaseUrl => 'API बेस URL';

  @override
  String get apiStatusConnected => 'API तयार (भविष्यातील जोडणी)';

  @override
  String get apiStatusDemo => 'स्थानिक डेमो मोड चालू आहे';

  @override
  String get saveApiSettings => 'API URL जतन करा';

  @override
  String get statusAvailable => 'उपलब्ध';

  @override
  String get statusUnavailable => 'संपले';

  @override
  String get statusIssued => 'वाटप केलेले';

  @override
  String get statusReturned => 'परत आलेले';

  @override
  String get statusOverdue => 'मुदत संपलेली';

  @override
  String get save => 'जतन करा';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get confirm => 'पुष्टी करा';

  @override
  String get close => 'बंद करा';

  @override
  String get search => 'शोधा';

  @override
  String get clear => 'साफ करा';

  @override
  String get filter => 'फिल्टर';

  @override
  String get nameRequired => 'किमान एक नाव (मराठी किंवा इंग्रजी) आवश्यक आहे';

  @override
  String get authorRequired => 'किमान एक लेखक (मराठी किंवा इंग्रजी) आवश्यक आहे';

  @override
  String get codeRequired => 'संकेतांक आवश्यक आहे';

  @override
  String get positiveNumberRequired => 'कृपया वैध संख्या प्रविष्ट करा';

  @override
  String get successSaved => 'यशस्वीरित्या जतन झाले!';

  @override
  String get successUpdated => 'यशस्वीरित्या अद्यतनित झाले!';

  @override
  String get successDeleted => 'यशस्वीरित्या हटवले गेले!';
}
