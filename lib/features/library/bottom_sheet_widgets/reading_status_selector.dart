import 'package:flutter/material.dart';
import 'package:raffi/providers/library_provider.dart';

class ReadingStatusSelector extends StatelessWidget {
  const ReadingStatusSelector({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  final ReadingStatus selectedStatus;
  final ValueChanged<ReadingStatus> onStatusChanged;

  String _statusLabel(ReadingStatus status) {
    switch (status) {
      case ReadingStatus.wantToRead:
        return 'أريد قراءته';

      case ReadingStatus.currentlyReading:
        return 'أقرأ حاليًا';

      case ReadingStatus.completed:
        return 'مكتمل';
    }
  }

  Widget _buildStatusButton(
      BuildContext context,
      ReadingStatus status,
      ) {
    final isSelected = selectedStatus == status;
    final colors = Theme.of(context).colorScheme;

    return ChoiceChip(
      label: Text(
        _statusLabel(status),
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? colors.onPrimary : colors.onSurface,
        ),
      ),
      selected: isSelected,
      selectedColor: colors.primary,
      backgroundColor: colors.surfaceContainerHighest,
      showCheckmark: false,
      onSelected: (selected) {
        if (!selected) return;

        onStatusChanged(status);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أضفه إلى رف',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            _buildStatusButton(context, ReadingStatus.wantToRead),
            _buildStatusButton(context, ReadingStatus.currentlyReading),
            _buildStatusButton(context, ReadingStatus.completed),
          ],
        ),
      ],
    );
  }
}