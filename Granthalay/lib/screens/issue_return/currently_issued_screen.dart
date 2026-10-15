import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routing/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/borrow_record.dart';
import '../../repositories/borrowing_repository.dart';
import '../../widgets/search_field.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/custom_card.dart';

class CurrentlyIssuedScreen extends StatefulWidget {
  final BorrowingRepository borrowingRepository;

  const CurrentlyIssuedScreen({
    super.key,
    required this.borrowingRepository,
  });

  @override
  State<CurrentlyIssuedScreen> createState() => _CurrentlyIssuedScreenState();
}

class _CurrentlyIssuedScreenState extends State<CurrentlyIssuedScreen> {
  String _searchQuery = '';

  void _confirmReturn(BorrowRecord record) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.returnBookTitle),
        content: Text('${l10n.returnConfirmPrompt}\n\n${record.displayBookTitle(locale)}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.borrowingRepository.returnBook(record.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.returnSuccess), backgroundColor: AppColors.accentGreen),
                );
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
        title: Text(l10n.currentlyIssuedTitle),
        actions: [
          IconButton(
            tooltip: l10n.quickIssueBook,
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.issueBook),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.borrowingRepository as Listenable,
        builder: (context, _) {
          final issuedRecords = widget.borrowingRepository.records.where((r) => !r.isReturned).toList();
          final q = _searchQuery.trim().toLowerCase();

          final filtered = issuedRecords.where((r) {
            if (q.isEmpty) return true;
            return r.bookTitleMr.toLowerCase().contains(q) ||
                r.bookTitleEn.toLowerCase().contains(q) ||
                r.memberNameMr.toLowerCase().contains(q) ||
                r.memberNameEn.toLowerCase().contains(q) ||
                r.memberCode.toLowerCase().contains(q);
          }).toList();

          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SearchField(
                  hintText: l10n.searchIssuedRecordPlaceholder,
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.outbox_rounded,
                        title: l10n.noRecentTransactions,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final rec = filtered[i];
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
                                        rec.bookCode,
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Spacer(),
                                    StatusBadge.borrowStatus(
                                      borrowStatus: rec.actualStatus,
                                      compact: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  rec.displayBookTitle(locale),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${rec.displayMemberName(locale)} (${rec.memberCode}) • ${rec.memberPhone}',
                                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                ),
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${l10n.issueDate}: ${rec.issueDate.day}/${rec.issueDate.month}/${rec.issueDate.year}',
                                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                        ),
                                        Text(
                                          '${l10n.dueDate}: ${rec.dueDate.day}/${rec.dueDate.month}/${rec.dueDate.year}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: rec.isCurrentlyOverdue ? AppColors.error : AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _confirmReturn(rec),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentGreen,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                      child: Text(l10n.quickReturnBook),
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
