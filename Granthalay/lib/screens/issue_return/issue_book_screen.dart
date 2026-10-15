import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/book.dart';
import '../../models/member.dart';
import '../../models/borrow_record.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/member_repository.dart';
import '../../repositories/borrowing_repository.dart';
import '../../widgets/custom_card.dart';

class IssueBookScreen extends StatefulWidget {
  final BookRepository bookRepository;
  final MemberRepository memberRepository;
  final BorrowingRepository borrowingRepository;
  final Member? preselectedMember;
  final Book? preselectedBook;

  const IssueBookScreen({
    super.key,
    required this.bookRepository,
    required this.memberRepository,
    required this.borrowingRepository,
    this.preselectedMember,
    this.preselectedBook,
  });

  @override
  State<IssueBookScreen> createState() => _IssueBookScreenState();
}

class _IssueBookScreenState extends State<IssueBookScreen> {
  Member? _selectedMember;
  Book? _selectedBook;
  DateTime _issueDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 14));
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedMember = widget.preselectedMember;
    _selectedBook = widget.preselectedBook;
  }

  void _chooseMember() {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final members = widget.memberRepository.members;
    String filter = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = members.where((m) {
              final q = filter.trim().toLowerCase();
              if (q.isEmpty) return true;
              return m.nameMr.toLowerCase().contains(q) ||
                  m.nameEn.toLowerCase().contains(q) ||
                  m.memberCode.toLowerCase().contains(q) ||
                  m.phone.contains(q);
            }).toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              maxChildSize: 0.9,
              minChildSize: 0.4,
              expand: false,
              builder: (_, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        l10n.stepSelectMember,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: l10n.searchMembersPlaceholder,
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (val) {
                          setModalState(() {
                            filter = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final m = filtered[i];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.secondaryContainer,
                                child: Text(
                                  m.displayName(locale).isNotEmpty
                                      ? m.displayName(locale).characters.first
                                      : 'M',
                                  style: const TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(m.displayName(locale), style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${m.memberCode} • ${m.phone}'),
                              onTap: () {
                                setState(() {
                                  _selectedMember = m;
                                });
                                Navigator.pop(ctx);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _chooseBook() {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final books = widget.bookRepository.books;
    String filter = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = books.where((b) {
              final q = filter.trim().toLowerCase();
              if (q.isEmpty) return true;
              return b.titleMr.toLowerCase().contains(q) ||
                  b.titleEn.toLowerCase().contains(q) ||
                  b.bookCode.toLowerCase().contains(q) ||
                  b.authorMr.toLowerCase().contains(q) ||
                  b.authorEn.toLowerCase().contains(q);
            }).toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              maxChildSize: 0.9,
              minChildSize: 0.4,
              expand: false,
              builder: (_, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        l10n.stepSelectBook,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: l10n.searchBooksPlaceholder,
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (val) {
                          setModalState(() {
                            filter = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final b = filtered[i];
                            final hasCopies = b.isAvailable;

                            return ListTile(
                              enabled: hasCopies,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: hasCopies ? AppColors.primaryContainer : AppColors.errorBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.menu_book_rounded,
                                  color: hasCopies ? AppColors.primary : AppColors.error,
                                ),
                              ),
                              title: Text(
                                b.displayTitle(locale),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: hasCopies ? AppColors.textPrimary : AppColors.textMuted,
                                ),
                              ),
                              subtitle: Text('${b.bookCode} • ${b.displayAuthor(locale)}'),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: hasCopies ? AppColors.successBg : AppColors.errorBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${b.availableCopies} ${l10n.filterAvailable}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: hasCopies ? AppColors.accentGreen : AppColors.error,
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (hasCopies) {
                                  setState(() {
                                    _selectedBook = b;
                                  });
                                  Navigator.pop(ctx);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _pickDate(bool isIssue) async {
    final initialDate = isIssue ? _issueDate : _dueDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now().add(const Duration(days: 120)),
    );

    if (picked != null) {
      setState(() {
        if (isIssue) {
          _issueDate = picked;
          if (_dueDate.isBefore(_issueDate)) {
            _dueDate = _issueDate.add(const Duration(days: 14));
          }
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  Future<void> _handleConfirmIssue() async {
    final l10n = AppLocalizations.of(context)!;

    if (_selectedMember == null || _selectedBook == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectMemberAndBookError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedBook!.availableCopies <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.noCopiesAvailableError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_dueDate.isBefore(_issueDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.dueDateBeforeIssueDateError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final record = BorrowRecord(
      id: '',
      bookId: _selectedBook!.id,
      bookCode: _selectedBook!.bookCode,
      bookTitleMr: _selectedBook!.titleMr,
      bookTitleEn: _selectedBook!.titleEn,
      bookAuthorMr: _selectedBook!.authorMr,
      bookAuthorEn: _selectedBook!.authorEn,
      memberId: _selectedMember!.id,
      memberCode: _selectedMember!.memberCode,
      memberNameMr: _selectedMember!.nameMr,
      memberNameEn: _selectedMember!.nameEn,
      memberPhone: _selectedMember!.phone,
      issueDate: _issueDate,
      dueDate: _dueDate,
      returnDate: null,
      status: BorrowStatus.issued,
    );

    try {
      await widget.borrowingRepository.issueBook(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.issueSuccess),
            backgroundColor: AppColors.accentGreen,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.issueBookTitle),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: ElevatedButton.icon(
          onPressed: _isSubmitting ? null : _handleConfirmIssue,
          icon: const Icon(Icons.check_circle_outline),
          label: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  l10n.confirmIssueButton,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Step 1: Member Selection
            _StepHeader(stepNumber: '१', title: l10n.stepSelectMember),
            const SizedBox(height: 8),
            CustomCard(
              onTap: _chooseMember,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _selectedMember != null ? AppColors.secondaryContainer : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: _selectedMember != null ? AppColors.secondary : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _selectedMember != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedMember!.displayName(locale),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                '${_selectedMember!.memberCode} • ${_selectedMember!.phone}',
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          )
                        : Text(
                            l10n.selectMemberPrompt,
                            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                          ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Step 2: Book Selection & Available copies check
            _StepHeader(stepNumber: '२', title: l10n.stepSelectBook),
            const SizedBox(height: 8),
            CustomCard(
              onTap: _chooseBook,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _selectedBook != null ? AppColors.primaryContainer : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: _selectedBook != null ? AppColors.primary : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _selectedBook != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedBook!.displayTitle(locale),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                '${_selectedBook!.bookCode} • ${_selectedBook!.displayAuthor(locale)}',
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.bookCopiesCount(_selectedBook!.availableCopies, _selectedBook!.totalCopies),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedBook!.isAvailable ? AppColors.accentGreen : AppColors.error,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            l10n.selectBookPrompt,
                            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                          ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Step 3: Dates Selection
            _StepHeader(stepNumber: '३', title: l10n.stepDates),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    onTap: () => _pickDate(true),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.issueDate,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              '${_issueDate.day}/${_issueDate.month}/${_issueDate.year}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomCard(
                    onTap: () => _pickDate(false),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.dueDate,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.event_available_outlined, size: 16, color: AppColors.error),
                            const SizedBox(width: 8),
                            Text(
                              '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Step 4: Review Summary Card
            _StepHeader(stepNumber: '४', title: l10n.stepConfirm),
            const SizedBox(height: 8),
            CustomCard(
              padding: const EdgeInsets.all(16),
              backgroundColor: AppColors.surfaceSubtle,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.navMembers, style: const TextStyle(color: AppColors.textSecondary)),
                      Text(
                        _selectedMember != null ? _selectedMember!.displayName(locale) : '-',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.navBooks, style: const TextStyle(color: AppColors.textSecondary)),
                      Flexible(
                        child: Text(
                          _selectedBook != null ? _selectedBook!.displayTitle(locale) : '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.dueDate, style: const TextStyle(color: AppColors.textSecondary)),
                      Text(
                        '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final String stepNumber;
  final String title;

  const _StepHeader({required this.stepNumber, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
