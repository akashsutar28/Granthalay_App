import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routing/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/member.dart';
import '../../models/borrow_record.dart';
import '../../repositories/member_repository.dart';
import '../../repositories/borrowing_repository.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/custom_card.dart';

class MemberDetailsScreen extends StatefulWidget {
  final MemberRepository memberRepository;
  final BorrowingRepository borrowingRepository;
  final Member initialMember;

  const MemberDetailsScreen({
    super.key,
    required this.memberRepository,
    required this.borrowingRepository,
    required this.initialMember,
  });

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  late Member _member;
  List<BorrowRecord> _memberHistory = [];

  @override
  void initState() {
    super.initState();
    _member = widget.initialMember;
    _loadMemberHistory();
    (widget.borrowingRepository as Listenable).addListener(_loadMemberHistory);
  }

  @override
  void dispose() {
    (widget.borrowingRepository as Listenable).removeListener(_loadMemberHistory);
    super.dispose();
  }

  Future<void> _loadMemberHistory() async {
    final history = await widget.borrowingRepository.getMemberBorrowHistory(_member.id);
    if (mounted) {
      setState(() {
        _memberHistory = history;
      });
    }
  }

  void _confirmDelete() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteMember),
        content: Text(l10n.deleteMemberConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.memberRepository.deleteMember(_member.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.successDeleted),
                    backgroundColor: AppColors.accentGreen,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: Text(l10n.deleteMember),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    final currentlyBorrowed = _memberHistory.where((r) => !r.isReturned).toList();
    final returnedBooks = _memberHistory.where((r) => r.isReturned).toList();
    final overdueCount = _memberHistory.where((r) => r.isCurrentlyOverdue).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.memberDetails),
        actions: [
          IconButton(
            tooltip: l10n.editMember,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final updated = await Navigator.pushNamed(
                context,
                AppRoutes.addEditMember,
                arguments: _member,
              );
              if (updated is Member && mounted) {
                setState(() {
                  _member = updated;
                });
              }
            },
          ),
          IconButton(
            tooltip: l10n.deleteMember,
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.borrowingHistory,
                    arguments: {
                      'memberId': _member.id,
                      'memberName': _member.displayName(locale),
                      'memberCode': _member.memberCode,
                    },
                  );
                },
                icon: const Icon(Icons.history_rounded, size: 18),
                label: Text(l10n.viewBorrowHistory),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.issueBook,
                    arguments: {'member': _member},
                  );
                },
                icon: const Icon(Icons.outbox_rounded, size: 18),
                label: Text(l10n.quickIssueBook),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final refreshed = await widget.memberRepository.getMemberById(_member.id);
          if (refreshed != null && mounted) {
            setState(() {
              _member = refreshed;
            });
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Member Header Card
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _member.displayName(locale).isNotEmpty
                            ? _member.displayName(locale).characters.first
                            : 'M',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _member.displayName(locale),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _member.memberCode,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (_member.departmentClass.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      _member.departmentClass,
                      style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Statistics Bar Card
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    label: l10n.currentlyBorrowed,
                    value: currentlyBorrowed.length.toString(),
                    color: AppColors.info,
                  ),
                  Container(width: 1, height: 36, color: AppColors.border),
                  _StatItem(
                    label: l10n.returnedBooks,
                    value: returnedBooks.length.toString(),
                    color: AppColors.accentGreen,
                  ),
                  Container(width: 1, height: 36, color: AppColors.border),
                  _StatItem(
                    label: l10n.currentOverdueCount,
                    value: overdueCount.toString(),
                    color: AppColors.error,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Currently Borrowed Books Section
            CustomCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.currentlyBorrowed,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${currentlyBorrowed.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  if (currentlyBorrowed.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        l10n.noHistoryFound,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentlyBorrowed.length,
                      separatorBuilder: (_, _) => const Divider(height: 16),
                      itemBuilder: (context, i) {
                        final rec = currentlyBorrowed[i];
                        return Row(
                          children: [
                            const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rec.displayBookTitle(locale),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${l10n.dueDate}: ${rec.dueDate.day}/${rec.dueDate.month}/${rec.dueDate.year}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge.borrowStatus(
                              borrowStatus: rec.actualStatus,
                              compact: true,
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Member Detailed Information
            CustomCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.memberDetails,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Divider(height: 20),
                  _DetailRow(label: l10n.memberCode, value: _member.memberCode),
                  if (_member.nameMr.isNotEmpty && _member.nameEn.isNotEmpty && _member.nameMr != _member.nameEn) ...[
                    _DetailRow(label: l10n.memberNameMarathi, value: _member.nameMr),
                    _DetailRow(label: l10n.memberNameEnglish, value: _member.nameEn),
                  ] else ...[
                    _DetailRow(
                      label: l10n.fullName,
                      value: _member.displayName(locale).isNotEmpty ? _member.displayName(locale) : '-',
                    ),
                  ],
                  _DetailRow(label: l10n.phoneNumber, value: _member.phone),
                  _DetailRow(label: l10n.emailAddress, value: _member.email.isNotEmpty ? _member.email : '-'),
                  _DetailRow(label: l10n.address, value: _member.address.isNotEmpty ? _member.address : '-'),
                  _DetailRow(label: l10n.departmentClass, value: _member.departmentClass.isNotEmpty ? _member.departmentClass : '-'),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
