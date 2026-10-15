import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/dashboard_stats.dart';
import '../../repositories/borrowing_repository.dart';
import '../../widgets/custom_card.dart';

class ReportsScreen extends StatefulWidget {
  final BorrowingRepository borrowingRepository;

  const ReportsScreen({
    super.key,
    required this.borrowingRepository,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DashboardStats _stats = DashboardStats.empty();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
    (widget.borrowingRepository as Listenable).addListener(_loadStats);
  }

  @override
  void dispose() {
    (widget.borrowingRepository as Listenable).removeListener(_loadStats);
    super.dispose();
  }

  Future<void> _loadStats() async {
    final stats = await widget.borrowingRepository.getDashboardStats();
    if (mounted) {
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final availabilityRate = _stats.totalCopies > 0
        ? ((_stats.availableCopies / _stats.totalCopies) * 100).toStringAsFixed(1)
        : '0';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.reportsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadStats,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Subtitle notice
                  Text(
                    l10n.statisticsCalculated,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Core Metrics Card
                  CustomCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.reportTotalCopies,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.successBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$availabilityRate% उपलब्ध',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Progress bar for availability vs issued
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Row(
                            children: [
                              Expanded(
                                flex: _stats.availableCopies > 0 ? _stats.availableCopies : 1,
                                child: Container(
                                  height: 10,
                                  color: _stats.availableCopies > 0 ? AppColors.accentGreen : Colors.transparent,
                                ),
                              ),
                              Expanded(
                                flex: _stats.issuedBooks > 0 ? _stats.issuedBooks : 1,
                                child: Container(
                                  height: 10,
                                  color: _stats.issuedBooks > 0 ? AppColors.info : Colors.transparent,
                                ),
                              ),
                              if (_stats.overdueBooks > 0)
                                Expanded(
                                  flex: _stats.overdueBooks,
                                  child: Container(height: 10, color: AppColors.error),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _MetricRow(
                          label: l10n.reportTotalTitles,
                          value: _stats.totalBooks.toString(),
                          dotColor: AppColors.primary,
                        ),
                        const Divider(height: 16),
                        _MetricRow(
                          label: l10n.availableCopies,
                          value: _stats.availableCopies.toString(),
                          dotColor: AppColors.accentGreen,
                        ),
                        const Divider(height: 16),
                        _MetricRow(
                          label: l10n.reportIssuedCopies,
                          value: _stats.issuedBooks.toString(),
                          dotColor: AppColors.info,
                        ),
                        const Divider(height: 16),
                        _MetricRow(
                          label: l10n.reportOverdueCount,
                          value: _stats.overdueBooks.toString(),
                          dotColor: AppColors.error,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Circulation & Membership Card
                  CustomCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'वाचनालय सदस्य व व्यवहार आढावा',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _MetricRow(
                          label: l10n.reportTotalMembers,
                          value: _stats.totalMembers.toString(),
                          dotColor: AppColors.secondary,
                        ),
                        const Divider(height: 16),
                        _MetricRow(
                          label: l10n.reportTotalReturns,
                          value: _stats.totalReturned.toString(),
                          dotColor: const Color(0xFF6366F1),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Category Breakdown Card
                  CustomCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.categoryDistribution,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_stats.categoryDistribution.isEmpty)
                          const Text('माहिती उपलब्ध नाही')
                        else
                          ..._stats.categoryDistribution.entries.map((entry) {
                            final count = entry.value;
                            final percent = _stats.totalBooks > 0
                                ? (count / _stats.totalBooks)
                                : 0.0;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '$count पुस्तके',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: percent,
                                      backgroundColor: AppColors.surfaceVariant,
                                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                      minHeight: 6,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
