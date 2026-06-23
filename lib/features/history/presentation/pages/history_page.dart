import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/mystical_card.dart';
import '../../../tarot/providers/reading_history_provider.dart';
import '../../../tarot/domain/entities/reading.dart';

/// Reading history page
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReadingHistoryProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('historyTitle')),
        centerTitle: true,
        actions: [
          if (provider.count > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _confirmClearAll(context, provider),
            ),
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: provider.count == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64,
                          color: AppColors.softPurple.withValues(alpha: 0.4)),
                      const SizedBox(height: 16),
                      Text(l10n.translate('noHistory'),
                          style: AppTextStyles.bodyLarge),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.count,
                  itemBuilder: (context, index) {
                    final record = provider.getRecord(index);
                    if (record == null) return const SizedBox();
                    return _HistoryCard(
                      record: record,
                      onTap: () => _showDetail(context, record),
                      onDelete: () => provider.deleteRecord(record.id),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _confirmClearAll(BuildContext context, ReadingHistoryProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text('Are you sure you want to delete all reading records?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.clearAll();
              Navigator.pop(context);
            },
            child: const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, ReadingRecord record) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ReadingDetailPage(record: record),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final ReadingRecord record;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HistoryCard({
    required this.record,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = '${record.timestamp.year}/${record.timestamp.month.toString().padLeft(2, '0')}/${record.timestamp.day.toString().padLeft(2, '0')}';
    final timeStr = '${record.timestamp.hour.toString().padLeft(2, '0')}:${record.timestamp.minute.toString().padLeft(2, '0')}';

    IconData typeIcon;
    switch (record.type) {
      case DivinationType.tarot:
        typeIcon = Icons.auto_stories;
      case DivinationType.astrology:
        typeIcon = Icons.star;
      case DivinationType.numerology:
        typeIcon = Icons.tag;
      case DivinationType.fortuneSlip:
        typeIcon = Icons.auto_awesome;
      case DivinationType.oracle:
        typeIcon = Icons.psychology;
      case DivinationType.dailyCard:
        typeIcon = Icons.calendar_today;
    }

    return MysticalCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      child: Row(
        children: [
          // Type icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.rosePink.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(typeIcon, color: AppColors.rosePink, size: 24),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.type.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.rosePink),
                ),
                const SizedBox(height: 4),
                Text(
                  '${record.cards.length} cards',
                  style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary),
                ),
                Text(
                  '$dateStr $timeStr',
                  style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _ReadingDetailPage extends StatelessWidget {
  final ReadingRecord record;

  const _ReadingDetailPage({required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Detail'),
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${record.timestamp.year}/${record.timestamp.month}/${record.timestamp.day}',
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                '${record.type.name.toUpperCase()} Reading',
                style: AppTextStyles.headingMedium,
              ),
              if (record.spreadId != null) ...[
                const SizedBox(height: 4),
                Text('Spread: ${record.spreadId}', style: AppTextStyles.bodySmall),
              ],
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: record.cards.length,
                  itemBuilder: (context, index) {
                    final card = record.cards[index];
                    return MysticalCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 60,
                            decoration: BoxDecoration(
                              color: card.isReversed
                                  ? AppColors.rosePink.withValues(alpha: 0.2)
                                  : AppColors.softPurple.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                '${card.position + 1}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: card.isReversed
                                      ? AppColors.rosePink
                                      : AppColors.softPurple,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Card #${card.cardIndex}',
                                    style: AppTextStyles.cardTitle),
                                Text(
                                  card.isReversed ? 'Reversed' : 'Upright',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: card.isReversed
                                        ? AppColors.error
                                        : AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
