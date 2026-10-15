import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/borrow_record.dart';
import '../../repositories/borrowing_repository.dart';
import '../../widgets/search_field.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/custom_card.dart';

class ReturnBookScreen extends StatefulWidget {
  final BorrowingRepository borrowingRepository;

  const ReturnBookScreen({
    super.key,
    required this.borrowingRepository,
  });

  @override
  State<ReturnBookScreen> createState() => _ReturnBookScreenState();
}

class _ReturnBookScreenState extends State<ReturnBookScreen> {
  String _searchQuery = '';

  void _confirmReturn(BorrowRecord record) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.returnBookTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.returnConfirmPrompt),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.displayBookTitle(locale),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${record.displayMemberName(locale)} (${record.memberCode})',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await widget.borrowingRepository.returnBook(record.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.returnSuccess),
                      backgroundColor: AppColors.accentGreen,
                    ),
                  );
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
              }
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.returnBookTitle),
      ),
      body: ListenableBuilder(
        listenable: widget.borrowingRepository as Listenable,
        builder: (context, _) {
          final activeRecords = widget.borrowingRepository.records.where((r) => !r.isReturned).toList();
          final q = _searchQuery.trim().toLowerCase();

          final filteredRecords = activeRecords.where((r) {
            if (q.isEmpty) return true;
            return r.bookTitleMr.toLowerCase().contains(q) ||
                r.bookTitleEn.toLowerCase().contains(q) ||
                r.bookCode.toLowerCase().contains(q) ||
                r.memberNameMr.toLowerCase().contains(q) ||
                r.memberNameEn.toLowerCase().contains(q) ||
                r.memberCode.toLowerCase().contains(q) ||
                r.memberPhone.contains(q);
          }).toList();

          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SearchField(
                  hintText: l10n.searchIssuedRecordPlaceholder,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ),
              Expanded(
                child: filteredRecords.isEmpty
                    ? EmptyState(
                        icon: Icons.assignment_turned_in_outlined,
                        title: l10n.noRecentTransactions,
                        subtitle: l10n.searchPersonNoResults,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredRecords.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final record = filteredRecords[i];
                          return CustomCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceVariant,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        record.bookCode,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    StatusBadge.borrowStatus(
                                      borrowStatus: record.actualStatus,
                                      compact: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  record.displayBookTitle(locale),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline, size: 14, color: AppColors.textMuted),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${record.displayMemberName(locale)} (${record.memberCode})',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${l10n.issueDate}: ${record.issueDate.day}/${record.issueDate.month}/${record.issueDate.year}',
                                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${l10n.dueDate}: ${record.dueDate.day}/${record.dueDate.month}/${record.dueDate.year}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: record.isCurrentlyOverdue ? AppColors.error : AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => _confirmReturn(record),
                                      icon: const Icon(Icons.move_to_inbox_rounded, size: 16),
                                      label: Text(l10n.markAsReturned),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentGreen,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
