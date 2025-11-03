import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final String imageUrl;

  CategoryItem({
    required this.name,
    required this.imageUrl,
  });
}

class CategoryFilter extends StatelessWidget {
  final List<CategoryItem> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      final Widget listView = SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategory == category.name;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => onCategorySelected(
                  isSelected ? null : category.name,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: category.imageUrl.isNotEmpty
                            ? Image.network(
                          category.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: theme.colorScheme.surfaceVariant,
                              child: Icon(
                                Icons.restaurant,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        )
                            : Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.restaurant,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 90,
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.linear(1.05),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? theme.colorScheme.primary : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      bool isTablet = constraints.maxWidth > 600;
      return isTablet ? Center(child: listView) : listView;
    });
  }
}