import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  final List<String> areas;
  final String? selectedArea;
  final Function(String?) onAreaSelected;

  const FilterBottomSheet({
    super.key,
    required this.areas,
    this.selectedArea,
    required this.onAreaSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtrar por Área',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  ChoiceChip(
                    label: const Text('Todos'),
                    selected: selectedArea == null,
                    onSelected: (selected) {
                      onAreaSelected(null);
                      Navigator.pop(context);
                    },
                  ),
                  ...areas.map((area) {
                    final isSelected = selectedArea == area;
                    return ChoiceChip(
                      label: Text(area),
                      selected: isSelected,
                      onSelected: (selected) {
                        onAreaSelected(isSelected ? null : area);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}