import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routing/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/borrow_record.dart';
import '../../repositories/borrowing_repository.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/custom_card.dart';

class TransactionsHubScreen extends StatefulWidget {
  final BorrowingRepository borrowingRepository;
  final VoidCallback? onOpenDrawer;

  const TransactionsHubScreen({
    super.key,
    required this.borrowingRepository,
    this.onOpenDrawer,
  });

  @override
  State<TransactionsHubScreen> createState() => _TransactionsHubScreenState();
}

class _TransactionsHubScreenState extends State<TransactionsHubScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        title: Text(l10n.navTransactions),
        leading: widget.onOpenDrawer != null
            ? IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: widget.onOpenDrawer,
              )
            : null,
        actions: [
          IconButton(
            tooltip: l10n.quickIssueBook,
            icon: const Icon(Icons.outbox_rounded, color: AppColors.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.issueBook),
          ),
          IconButton(
            tooltip: l10n.quickReturnBook,
            icon: const Icon(Icons.move_to_inbox_rounded, color: AppColors.accentGreen),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.returnBook),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: [
            Tab(text: l10n.historyFilterIssued),
            Tab(text: l10n.historyFilterOverdue),
            Tab(text: l10n.historyFilterReturned),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.borrowingRepository as Listenable,
        builder: (context, _) {
          final allRecords = widget.borrowingRepository.records;
          final issuedRecords = allRecords.where((r) => !r.isReturned).toList();
          final overdueRecords = allRecords.where((r) => r.isCurrentlyOverdue).toList();
          final returnedRecords = allRecords.where((r) => r.isReturned).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Currently Issued
              _buildRecordsList(
                records: issuedRecords,
                emptyTitle: l10n.noRecentTransactions,
                locale: locale,
                l10n: l10n,
                showReturnBtn: true,
              ),

              // Tab 2: Overdue
              _buildRecordsList(
                records: overdueRecords,
                emptyTitle: 'कोणतेही पुस्तक मुदत संपलेले नाही',
                locale: locale,
                l10n: l10n,
                showReturnBtn: true,
              ),

              // Tab 3: Returned
              _buildRecordsList(
                records: returnedRecords,
                emptyTitle: l10n.noRecentTransactions,
                locale: locale,
                l10n: l10n,
                showReturnBtn: false,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecordsList({
    required List<BorrowRecord> records,
    required String emptyTitle,
    required Locale locale,
    required AppLocalizations l10n,
    required bool showReturnBtn,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.borrowingRepository.getAllRecords();
      },
      child: records.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                EmptyState(
                  icon: Icons.assignment_outlined,
                  title: emptyTitle,
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
      itemCount: records.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final rec = records[i];
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
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.borrowingHistory,
                    arguments: {
                      'memberId': rec.memberId,
                      'memberName': rec.displayMemberName(locale),
                      'memberCode': rec.memberCode,
                    },
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${rec.displayMemberName(locale)} (${rec.memberCode})',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: rec.isCurrentlyOverdue ? AppColors.error : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (showReturnBtn)
                    ElevatedButton(
                      onPressed: () => _confirmReturn(rec),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      child: Text(l10n.quickReturnBook),
                    )
                  else if (rec.returnDate != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.successBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${rec.returnDate!.day}/${rec.returnDate!.month}/${rec.returnDate!.year}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentGreen,
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
    );
  }
}
