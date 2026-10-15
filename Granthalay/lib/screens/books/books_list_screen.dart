import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routing/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';
import '../../widgets/search_field.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/custom_card.dart';

class BooksListScreen extends StatefulWidget {
  final BookRepository bookRepository;
  final VoidCallback? onOpenDrawer;

  const BooksListScreen({
    super.key,
    required this.bookRepository,
    this.onOpenDrawer,
  });

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

enum AvailabilityFilter { all, available, unavailable }
enum BookSortOption { title, author, code, availableCopies }

class _BooksListScreenState extends State<BooksListScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  AvailabilityFilter _availabilityFilter = AvailabilityFilter.all;
  final BookSortOption _sortOption = BookSortOption.title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.booksTitle),
        leading: widget.onOpenDrawer != null
            ? IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: widget.onOpenDrawer,
              )
            : null,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addBookFab',
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addEditBook);
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.addBook),
      ),
      body: ListenableBuilder(
        listenable: widget.bookRepository as Listenable,
        builder: (context, _) {
          final allBooks = widget.bookRepository.books;

          // 1. Search filter
          final filteredBooks = allBooks.where((book) {
            final query = _searchQuery.trim().toLowerCase();
            final matchesQuery = query.isEmpty ||
                book.bookCode.toLowerCase().contains(query) ||
                book.titleMr.toLowerCase().contains(query) ||
                book.titleEn.toLowerCase().contains(query) ||
                book.authorMr.toLowerCase().contains(query) ||
                book.authorEn.toLowerCase().contains(query) ||
                book.category.toLowerCase().contains(query);

            final matchesCategory = _selectedCategory == null || book.category == _selectedCategory;

            final matchesAvailability = switch (_availabilityFilter) {
              AvailabilityFilter.all => true,
              AvailabilityFilter.available => book.isAvailable,
              AvailabilityFilter.unavailable => !book.isAvailable,
            };

            return matchesQuery && matchesCategory && matchesAvailability;
          }).toList();

          // 2. Sorting
          filteredBooks.sort((a, b) {
            switch (_sortOption) {
              case BookSortOption.title:
                return a.displayTitle(locale).compareTo(b.displayTitle(locale));
              case BookSortOption.author:
                return a.displayAuthor(locale).compareTo(b.displayAuthor(locale));
              case BookSortOption.code:
                return a.bookCode.compareTo(b.bookCode);
              case BookSortOption.availableCopies:
                return b.availableCopies.compareTo(a.availableCopies);
            }
          });

          return Column(
            children: [
              // Search & Filter Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  children: [
                    SearchField(
                      hintText: l10n.searchBooksPlaceholder,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    // Filter Chips Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text(l10n.filterAll),
                            selected: _availabilityFilter == AvailabilityFilter.all,
                            onSelected: (_) {
                              setState(() {
                                _availabilityFilter = AvailabilityFilter.all;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: Text(l10n.filterAvailable),
                            selected: _availabilityFilter == AvailabilityFilter.available,
                            onSelected: (_) {
                              setState(() {
                                _availabilityFilter = AvailabilityFilter.available;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: Text(l10n.filterUnavailable),
                            selected: _availabilityFilter == AvailabilityFilter.unavailable,
                            onSelected: (_) {
                              setState(() {
                                _availabilityFilter = AvailabilityFilter.unavailable;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          // Category Filter Dropdown Chip
                          FilterChip(
                            label: Text(
                              _selectedCategory != null
                                  ? _selectedCategory!.split(' ')[0]
                                  : l10n.filterCategory,
                            ),
                            selected: _selectedCategory != null,
                            onSelected: (_) => _showCategoryPicker(context),
                          ),
                          if (_selectedCategory != null) ...[
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = null;
                                });
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Books List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await widget.bookRepository.getBooks();
                  },
                  child: filteredBooks.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            EmptyState(
                              icon: Icons.menu_book_outlined,
                              title: l10n.noRecentTransactions,
                              subtitle: l10n.searchPersonNoResults,
                              actionLabel: l10n.addBook,
                              onAction: () => Navigator.pushNamed(context, AppRoutes.addEditBook),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredBooks.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final book = filteredBooks[index];
                            return _BookCard(
                              book: book,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.bookDetails,
                                  arguments: book,
                                );
                              },
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

  void _showCategoryPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    l10n.filterCategory,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: AppConstants.bookCategories.length,
                    itemBuilder: (context, i) {
                      final cat = AppConstants.bookCategories[i];
                      final isSelected = _selectedCategory == cat;
                      return ListTile(
                        title: Text(cat),
                        trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const _BookCard({
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Thumbnail Container
          Container(
            width: 48,
            height: 64,
            decoration: BoxDecoration(
              color: book.isAvailable
                  ? AppColors.primary.withOpacity(0.08)
                  : AppColors.errorBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: book.isAvailable
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.error.withOpacity(0.3),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.book_rounded,
                color: book.isAvailable ? AppColors.primary : AppColors.error,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Book Details
          Expanded(
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
                        book.bookCode,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    StatusBadge.availability(
                      isAvailable: book.isAvailable,
                      compact: true,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  book.displayTitle(locale),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  book.displayAuthor(locale),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        book.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      l10n.bookCopiesCount(book.availableCopies, book.totalCopies),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: book.isAvailable ? AppColors.accentGreen : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
