import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../repositories/borrowing_repository.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/custom_card.dart';

enum HistoryFilter { all, issued, returned, overdue }

class BorrowingHistoryScreen extends StatefulWidget {
  final BorrowingRepository borrowingRepository;
  final String memberId;
  final String memberName;
  final String memberCode;

  const BorrowingHistoryScreen({
    super.key,
    required this.borrowingRepository,
    required this.memberId,
    required this.memberName,
    required this.memberCode,
  });

  @override
  State<BorrowingHistoryScreen> createState() => _BorrowingHistoryScreenState();
}

class _BorrowingHistoryScreenState extends State<BorrowingHistoryScreen> {
  HistoryFilter _filter = HistoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.historyTitle),
      ),
      body: ListenableBuilder(
        listenable: widget.borrowingRepository as Listenable,
        builder: (context, _) {
          final allRecords = widget.borrowingRepository.records
              .where((r) => r.memberId == widget.memberId)
              .toList();

          final filteredRecords = allRecords.where((r) {
            switch (_filter) {
              case HistoryFilter.all:
                return true;
              case HistoryFilter.issued:
                return !r.isReturned && !r.isCurrentlyOverdue;
              case HistoryFilter.returned:
                return r.isReturned;
              case HistoryFilter.overdue:
                return r.isCurrentlyOverdue;
            }
          }).toList();

          return Column(
            children: [
              // Member Header Summary
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.secondaryContainer,
                          child: Text(
                            widget.memberName.isNotEmpty ? widget.memberName.characters.first : 'M',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.memberName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.memberCode,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${allRecords.length} ${l10n.totalBorrowRecords}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Filter Segmented Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text(l10n.historyFilterAll),
                            selected: _filter == HistoryFilter.all,
                            onSelected: (_) => setState(() => _filter = HistoryFilter.all),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: Text(l10n.historyFilterIssued),
                            selected: _filter == HistoryFilter.issued,
                            onSelected: (_) => setState(() => _filter = HistoryFilter.issued),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: Text(l10n.historyFilterReturned),
                            selected: _filter == HistoryFilter.returned,
                            onSelected: (_) => setState(() => _filter = HistoryFilter.returned),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: Text(l10n.historyFilterOverdue),
                            selected: _filter == HistoryFilter.overdue,
                            onSelected: (_) => setState(() => _filter = HistoryFilter.overdue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Records List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await widget.borrowingRepository.getAllRecords();
                  },
                  child: filteredRecords.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            EmptyState(
                              icon: Icons.history_edu_outlined,
                              title: l10n.noHistoryFound,
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                        itemCount: filteredRecords.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final rec = filteredRecords[i];
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
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    StatusBadge.borrowStatus(borrowStatus: rec.actualStatus),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  rec.displayBookTitle(locale),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  rec.bookAuthorMr.isNotEmpty ? rec.bookAuthorMr : rec.bookAuthorEn,
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
                                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${l10n.dueDate}: ${rec.dueDate.day}/${rec.dueDate.month}/${rec.dueDate.year}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: rec.isCurrentlyOverdue ? AppColors.error : AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (rec.returnDate != null)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            l10n.returnDate,
                                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                          ),
                                          Text(
                                            '${rec.returnDate!.day}/${rec.returnDate!.month}/${rec.returnDate!.year}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.accentGreen,
                                            ),
                                          ),
                                        ],
                                      )
                                    else if (rec.isCurrentlyOverdue)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.errorBg,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          l10n.daysOverdue(rec.daysOverdue),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.error,
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.infoBg,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          l10n.daysRemaining(rec.daysRemaining),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.info,
                                          ),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
