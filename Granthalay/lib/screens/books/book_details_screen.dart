import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routing/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/custom_card.dart';

class BookDetailsScreen extends StatefulWidget {
  final BookRepository bookRepository;
  final Book initialBook;

  const BookDetailsScreen({
    super.key,
    required this.bookRepository,
    required this.initialBook,
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late Book _book;

  @override
  void initState() {
    super.initState();
    _book = widget.initialBook;
  }

  void _confirmDelete() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteBook),
        content: Text(l10n.deleteBookConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.bookRepository.deleteBook(_book.id);
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
            child: Text(l10n.deleteBook),
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
        title: Text(l10n.bookDetails),
        actions: [
          IconButton(
            tooltip: l10n.editBook,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final updated = await Navigator.pushNamed(
                context,
                AppRoutes.addEditBook,
                arguments: _book,
              );
              if (updated is Book && mounted) {
                setState(() {
                  _book = updated;
                });
              }
            },
          ),
          IconButton(
            tooltip: l10n.deleteBook,
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
        child: ElevatedButton.icon(
          onPressed: _book.isAvailable
              ? () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.issueBook,
                    arguments: {'book': _book},
                  );
                }
              : null,
          icon: const Icon(Icons.outbox_rounded),
          label: Text(
            _book.isAvailable ? l10n.quickIssueBook : l10n.statusUnavailable,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final refreshed = await widget.bookRepository.getBookById(_book.id);
          if (refreshed != null && mounted) {
            setState(() {
              _book = refreshed;
            });
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Header Card
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: const Center(
                      child: Icon(Icons.auto_stories_rounded, size: 44, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _book.displayTitle(locale),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _book.displayAuthor(locale),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  StatusBadge.availability(isAvailable: _book.isAvailable),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Copies Status Card
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatColumn(
                    label: l10n.totalCopiesLabel,
                    value: _book.totalCopies.toString(),
                    color: AppColors.primary,
                  ),
                  Container(width: 1, height: 40, color: AppColors.border),
                  _StatColumn(
                    label: l10n.availableCopiesLabel,
                    value: _book.availableCopies.toString(),
                    color: _book.isAvailable ? AppColors.accentGreen : AppColors.error,
                  ),
                  Container(width: 1, height: 40, color: AppColors.border),
                  _StatColumn(
                    label: l10n.issuedBooks,
                    value: _book.issuedCopies.toString(),
                    color: AppColors.info,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Metadata Detail Card
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.bookDetails,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Divider(height: 24),
                  _DetailRow(label: l10n.bookCode, value: _book.bookCode),
                  if (_book.titleMr.isNotEmpty && _book.titleEn.isNotEmpty && _book.titleMr != _book.titleEn) ...[
                    _DetailRow(label: l10n.titleMarathi, value: _book.titleMr),
                    _DetailRow(label: l10n.titleEnglish, value: _book.titleEn),
                  ] else ...[
                    _DetailRow(
                      label: l10n.bookTitle,
                      value: _book.displayTitle(locale).isNotEmpty ? _book.displayTitle(locale) : '-',
                    ),
                  ],
                  if (_book.authorMr.isNotEmpty && _book.authorEn.isNotEmpty && _book.authorMr != _book.authorEn) ...[
                    _DetailRow(label: l10n.authorMarathi, value: _book.authorMr),
                    _DetailRow(label: l10n.authorEnglish, value: _book.authorEn),
                  ] else ...[
                    _DetailRow(
                      label: l10n.author,
                      value: _book.displayAuthor(locale).isNotEmpty ? _book.displayAuthor(locale) : '-',
                    ),
                  ],
                  _DetailRow(label: l10n.category, value: _book.category),
                  _DetailRow(label: l10n.isbn, value: _book.isbn.isNotEmpty ? _book.isbn : '-'),
                  _DetailRow(label: l10n.publisher, value: _book.publisher.isNotEmpty ? _book.publisher : '-'),
                  _DetailRow(
                    label: l10n.publicationYear,
                    value: _book.publicationYear > 0 ? _book.publicationYear.toString() : '-',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatColumn({
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
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
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
