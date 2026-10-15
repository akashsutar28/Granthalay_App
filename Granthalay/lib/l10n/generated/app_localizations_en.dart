// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Granthalay';

  @override
  String get appSubtitle => 'Library Management System';

  @override
  String get libraryName => 'Vasant Dadashree Jinwani Mahagranthalay';

  @override
  String get demoModeNotice => 'Demo Mode Active (Local Data)';

  @override
  String get apiReadyNotice => 'Prepared for Spring Boot REST API';

  @override
  String get navHome => 'Home';

  @override
  String get navBooks => 'Books';

  @override
  String get navMembers => 'Members';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navSettings => 'Settings';

  @override
  String get loginTitle => 'Librarian Login';

  @override
  String get loginSubtitle => 'Access your library account';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get usernameRequired => 'Please enter username';

  @override
  String get passwordRequired => 'Please enter password';

  @override
  String get demoLoginHint =>
      'Demo Mode: You can sign in with any credentials (e.g. admin / 123456)';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get totalBooks => 'Total Books';

  @override
  String get availableCopies => 'Available Copies';

  @override
  String get issuedBooks => 'Issued Books';

  @override
  String get totalMembers => 'Total Members';

  @override
  String get overdueBooks => 'Overdue Books';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get quickAddBook => 'Add Book';

  @override
  String get quickIssueBook => 'Issue Book';

  @override
  String get quickReturnBook => 'Return Book';

  @override
  String get quickSearchPerson => 'Search Person';

  @override
  String get quickReports => 'Reports';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get viewAll => 'View All';

  @override
  String get noRecentTransactions => 'No recent transactions found.';

  @override
  String get booksTitle => 'Books Directory';

  @override
  String get searchBooksPlaceholder =>
      'Search by title, author, code, or category...';

  @override
  String get filterAll => 'All';

  @override
  String get filterAvailable => 'Available';

  @override
  String get filterUnavailable => 'Unavailable';

  @override
  String get filterCategory => 'Category';

  @override
  String get sortBy => 'Sort By';

  @override
  String get sortByTitle => 'Title';

  @override
  String get sortByAuthor => 'Author';

  @override
  String get sortByCode => 'Book Code';

  @override
  String get sortByAvailable => 'Available Copies';

  @override
  String get addBook => 'Add New Book';

  @override
  String get editBook => 'Edit Book';

  @override
  String get deleteBook => 'Delete Book';

  @override
  String get deleteBookConfirm =>
      'Are you sure you want to delete this book? This will remove it from local demo data.';

  @override
  String get bookDetails => 'Book Details';

  @override
  String get bookCode => 'Book Code';

  @override
  String get bookTitle => 'Book Title';

  @override
  String get bookTitleHint => 'e.g. Mrityunjay / Wings of Fire';

  @override
  String get bookTitleRequired => 'Please enter book title';

  @override
  String get author => 'Author';

  @override
  String get authorHint => 'e.g. Shivaji Sawant / A.P.J. Abdul Kalam';

  @override
  String get bookAuthorRequired => 'Please enter author name';

  @override
  String get titleMarathi => 'Marathi Title';

  @override
  String get titleEnglish => 'English Title';

  @override
  String get authorMarathi => 'Marathi Author';

  @override
  String get authorEnglish => 'English Author';

  @override
  String get category => 'Category';

  @override
  String get isbn => 'ISBN Number';

  @override
  String get publisher => 'Publisher';

  @override
  String get publicationYear => 'Publication Year';

  @override
  String get totalCopiesLabel => 'Total Copies';

  @override
  String get availableCopiesLabel => 'Available Copies';

  @override
  String bookCopiesCount(int available, int total) {
    return '$available / $total copies available';
  }

  @override
  String get membersTitle => 'Members Directory';

  @override
  String get searchMembersPlaceholder =>
      'Search by name, phone, or member code...';

  @override
  String get addMember => 'Add New Member';

  @override
  String get editMember => 'Edit Member';

  @override
  String get deleteMember => 'Delete Member';

  @override
  String get deleteMemberConfirm =>
      'Are you sure you want to delete this member?';

  @override
  String get memberDetails => 'Member Details';

  @override
  String get memberCode => 'Member Code';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'e.g. Rahul Patil';

  @override
  String get fullNameRequired => 'Please enter full name';

  @override
  String get memberNameMarathi => 'Full Name in Marathi';

  @override
  String get memberNameEnglish => 'Full Name in English';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get address => 'Address';

  @override
  String get departmentClass => 'Department / Class';

  @override
  String get currentlyBorrowed => 'Currently Borrowed';

  @override
  String get returnedBooks => 'Returned Books';

  @override
  String get totalBorrowRecords => 'Total Transactions';

  @override
  String get currentOverdueCount => 'Overdue Books';

  @override
  String get viewBorrowHistory => 'View Full History';

  @override
  String get issueBookTitle => 'Issue Book';

  @override
  String get stepSelectMember => '1. Select Member';

  @override
  String get stepSelectBook => '2. Select Book';

  @override
  String get stepDates => '3. Select Dates';

  @override
  String get stepConfirm => '4. Confirmation';

  @override
  String get selectMemberPrompt => 'Search or select member';

  @override
  String get selectBookPrompt => 'Search or select book';

  @override
  String get issueDate => 'Issue Date';

  @override
  String get dueDate => 'Due Date';

  @override
  String get returnDate => 'Return Date';

  @override
  String get issueSuccess => 'Book successfully issued (demo transaction).';

  @override
  String get noCopiesAvailableError => 'No copies available for this book!';

  @override
  String get selectMemberAndBookError =>
      'Please select both a member and a book.';

  @override
  String get dueDateBeforeIssueDateError =>
      'Due date cannot be earlier than issue date.';

  @override
  String get confirmIssueButton => 'Confirm Issue Book';

  @override
  String get returnBookTitle => 'Return Book';

  @override
  String get searchIssuedRecordPlaceholder =>
      'Search by member or book title...';

  @override
  String get returnConfirmPrompt =>
      'Are you sure you want to record this book return?';

  @override
  String get returnSuccess => 'Book successfully returned (demo transaction).';

  @override
  String get recordAlreadyReturned => 'This book has already been returned.';

  @override
  String get activeIssuedRecords => 'Active Issued Records';

  @override
  String get markAsReturned => 'Mark as Returned';

  @override
  String get searchPersonTitle => 'Search Person';

  @override
  String get searchPersonSubtitle =>
      'Search by Marathi name, English name, or member code';

  @override
  String get searchPersonPlaceholder =>
      'e.g. राहुल पाटील, Rahul Patil, M001...';

  @override
  String get searchPersonNoResults =>
      'No members found matching your search. Try another query.';

  @override
  String get searchPersonHelperText =>
      'Searching local demo records (will query Spring Boot REST API once connected).';

  @override
  String get historyTitle => 'Borrowing History';

  @override
  String get historyFilterAll => 'All Records';

  @override
  String get historyFilterIssued => 'Currently Issued';

  @override
  String get historyFilterReturned => 'Returned';

  @override
  String get historyFilterOverdue => 'Overdue';

  @override
  String get noHistoryFound =>
      'No borrowing history available for this member.';

  @override
  String daysOverdue(int days) {
    return '$days days overdue';
  }

  @override
  String daysRemaining(int days) {
    return '$days days left';
  }

  @override
  String get currentlyIssuedTitle => 'Currently Issued Books';

  @override
  String get overdueBooksTitle => 'Overdue Books';

  @override
  String get overdueWarning =>
      'Please contact the member to return the overdue book.';

  @override
  String get reportsTitle => 'Library Reports';

  @override
  String get reportTotalTitles => 'Total Book Titles';

  @override
  String get reportTotalCopies => 'Total Book Copies';

  @override
  String get reportIssuedCopies => 'Currently Issued Copies';

  @override
  String get reportTotalMembers => 'Registered Members';

  @override
  String get reportTotalReturns => 'Successful Return Records';

  @override
  String get reportOverdueCount => 'Currently Overdue Books';

  @override
  String get categoryDistribution => 'Books by Category';

  @override
  String get statisticsCalculated =>
      'All statistics are calculated dynamically from active records.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languagePreference => 'Select Language';

  @override
  String get marathiLanguage => 'मराठी (Marathi)';

  @override
  String get englishLanguage => 'English (इंग्रजी)';

  @override
  String get languageChangedMsg => 'Language updated successfully.';

  @override
  String get libraryInfo => 'Granthalay Details';

  @override
  String get libraryAddress =>
      'Kothali, Tal. Shirol, Dist. Kolhapur (Maharashtra)';

  @override
  String get libraryContact => 'Nilesh: 9011441477, Sachin: 9075086108';

  @override
  String get granthalayDetails => 'Granthalay Details';

  @override
  String get establishment => 'Established: 18-06-2018';

  @override
  String get locationVillage => 'Kothali';

  @override
  String get locationTalukaDist => 'Tal. Shirol, Dist. Kolhapur (Maharashtra)';

  @override
  String get contact => 'Contact';

  @override
  String get contactNilesh => 'Nilesh: 9011441477';

  @override
  String get contactSachin => 'Sachin: 9075086108';

  @override
  String get appVersion => 'App Version';

  @override
  String get apiConfiguration => 'Spring Boot REST API Settings';

  @override
  String get apiBaseUrl => 'API Base URL';

  @override
  String get apiStatusConnected => 'API Ready (Future Integration)';

  @override
  String get apiStatusDemo => 'Running in Local Demo Mode';

  @override
  String get saveApiSettings => 'Save API URL';

  @override
  String get statusAvailable => 'Available';

  @override
  String get statusUnavailable => 'Unavailable';

  @override
  String get statusIssued => 'Issued';

  @override
  String get statusReturned => 'Returned';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get search => 'Search';

  @override
  String get clear => 'Clear';

  @override
  String get filter => 'Filter';

  @override
  String get nameRequired =>
      'At least one name (Marathi or English) is required';

  @override
  String get authorRequired =>
      'At least one author (Marathi or English) is required';

  @override
  String get codeRequired => 'Code is required';

  @override
  String get positiveNumberRequired => 'Please enter a valid positive number';

  @override
  String get successSaved => 'Saved successfully!';

  @override
  String get successUpdated => 'Updated successfully!';

  @override
  String get successDeleted => 'Deleted successfully!';
}
