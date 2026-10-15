import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routing/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/dashboard_stats.dart';
import '../../repositories/borrowing_repository.dart';
import '../../repositories/book_repository.dart';
import '../../widgets/statistic_card.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/custom_card.dart';

class DashboardScreen extends StatefulWidget {
  final BorrowingRepository borrowingRepository;
  final BookRepository bookRepository;
  final VoidCallback? onOpenDrawer;

  const DashboardScreen({
    super.key,
    required this.borrowingRepository,
    required this.bookRepository,
    this.onOpenDrawer,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardStats _stats = DashboardStats.empty();
  bool _isStatsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
    // Listen to changes in borrowing and books repositories
    (widget.borrowingRepository as Listenable).addListener(_loadStats);
    (widget.bookRepository as Listenable).addListener(_loadStats);
  }

  @override
  void dispose() {
    (widget.borrowingRepository as Listenable).removeListener(_loadStats);
    (widget.bookRepository as Listenable).removeListener(_loadStats);
    super.dispose();
  }

  Future<void> _loadStats() async {
    if (!mounted || _isStatsLoading) return;
    _isStatsLoading = true;
    try {
      final stats = await widget.borrowingRepository.getDashboardStats();
      if (mounted) {
        setState(() {
          _stats = stats;
        });
      }
    } finally {
      _isStatsLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final recentRecords = widget.borrowingRepository.records.take(5).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.dashboardTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: widget.onOpenDrawer ?? () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            tooltip: l10n.quickSearchPerson,
            icon: const Icon(Icons.person_search_rounded, color: AppColors.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.searchPerson),
          ),
          IconButton(
            tooltip: l10n.quickReports,
            icon: const Icon(Icons.insights_rounded, color: AppColors.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.reports),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Granthalay Name Banner
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/granthalay_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'वसंत दादाश्री जिनवाणी महाग्रंथालय',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'कोथळी, ता. शिरोळ जि. कोल्हापूर • स्था. २०१८',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Summary Cards Grid (Total Books, Available Copies, Issued Books, Total Members, Overdue Books)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 500;
                  final crossAxisCount = isWide ? 3 : 2;
                  final childAspectRatio = isWide ? 1.35 : 1.15;

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: childAspectRatio,
                    children: [
                      StatisticCard(
                        title: l10n.totalBooks,
                        value: _stats.totalBooks.toString(),
                        icon: Icons.menu_book_rounded,
                        color: AppColors.primary,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.booksList),
                      ),
                      StatisticCard(
                        title: l10n.availableCopies,
                        value: _stats.availableCopies.toString(),
                        icon: Icons.check_circle_rounded,
                        color: AppColors.accentGreen,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.booksList),
                      ),
                      StatisticCard(
                        title: l10n.issuedBooks,
                        value: _stats.issuedBooks.toString(),
                        icon: Icons.outbox_rounded,
                        color: AppColors.info,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.currentlyIssued),
                      ),
                      StatisticCard(
                        title: l10n.totalMembers,
                        value: _stats.totalMembers.toString(),
                        icon: Icons.group_rounded,
                        color: AppColors.secondary,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.membersList),
                      ),
                      StatisticCard(
                        title: l10n.overdueBooks,
                        value: _stats.overdueBooks.toString(),
                        icon: Icons.warning_amber_rounded,
                        color: AppColors.error,
                        backgroundColor: AppColors.errorBg,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.overdueBooks),
                      ),
                      StatisticCard(
                        title: l10n.reportTotalReturns,
                        value: _stats.totalReturned.toString(),
                        icon: Icons.assignment_turned_in_rounded,
                        color: const Color(0xFF6366F1),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.reports),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Quick Actions Section
              Text(
                l10n.quickActions,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.library_add_rounded,
                      label: l10n.quickAddBook,
                      color: AppColors.primary,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.addEditBook),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.outbox_rounded,
                      label: l10n.quickIssueBook,
                      color: AppColors.info,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.issueBook),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.move_to_inbox_rounded,
                      label: l10n.quickReturnBook,
                      color: AppColors.accentGreen,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.returnBook),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.person_search_rounded,
                      label: l10n.quickSearchPerson,
                      color: AppColors.secondary,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.searchPerson),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Recent Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.recentTransactions,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.currentlyIssued),
                    child: Text(l10n.viewAll),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Recent Transactions List
              if (recentRecords.isEmpty)
                CustomCard(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        l10n.noRecentTransactions,
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentRecords.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final record = recentRecords[index];
                    return CustomCard(
                      padding: const EdgeInsets.all(14),
                      onTap: () {
                        // Open person search or borrowing history for this member
                        Navigator.pushNamed(
                          context,
                          AppRoutes.borrowingHistory,
                          arguments: {
                            'memberId': record.memberId,
                            'memberName': record.displayMemberName(locale),
                            'memberCode': record.memberCode,
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: record.isReturned
                                  ? AppColors.successBg
                                  : record.isCurrentlyOverdue
                                      ? AppColors.errorBg
                                      : AppColors.infoBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              record.isReturned
                                  ? Icons.check_circle_outline
                                  : record.isCurrentlyOverdue
                                      ? Icons.warning_amber_rounded
                                      : Icons.outbox_rounded,
                              size: 20,
                              color: record.isReturned
                                  ? AppColors.accentGreen
                                  : record.isCurrentlyOverdue
                                      ? AppColors.error
                                      : AppColors.info,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.displayBookTitle(locale),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${record.displayMemberName(locale)} (${record.memberCode})',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StatusBadge.borrowStatus(
                                borrowStatus: record.actualStatus,
                                compact: true,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${record.dueDate.day}/${record.dueDate.month}/${record.dueDate.year}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
