import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/components/molecules/loading_widget.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../meals_shared/domain/entities/meal.dart';
import '../providers/meal_detail_provider.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealDetailProvider>(context, listen: false)
          .fetchMealDetail(widget.mealId);
      Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final theme = Theme.of(context);

    return Scaffold(
      body: Consumer<MealDetailProvider>(
        builder: (context, provider, child) {
          if (provider.state == MealDetailState.loading ||
              provider.state == MealDetailState.initial) {
            return const LoadingWidget(message: 'Cargando detalle...');
          }

          if (provider.state == MealDetailState.error || provider.meal == null) {
            return Center(
              child: Text(provider.errorMessage ?? 'Error al cargar la comida'),
            );
          }

          final meal = provider.meal!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: isTablet ? 400 : 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    meal.name,
                    style: const TextStyle(shadows: [
                      Shadow(color: Colors.black54, blurRadius: 8)
                    ]),
                  ),
                  background: meal.thumbnail.isNotEmpty
                      ? Image.network(
                    meal.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color:
                        Theme.of(context).colorScheme.surfaceVariant,
                        child: Icon(
                          Icons.restaurant,
                          size: 100,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      );
                    },
                  )
                      : Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.restaurant,
                      size: 100,
                      color:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 32 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (meal.category.isNotEmpty)
                            Chip(
                              label: Text(meal.category),
                              avatar: const Icon(Icons.category, size: 16),
                            ),
                          const SizedBox(width: 8),
                          if (meal.area.isNotEmpty)
                            Chip(
                              label: Text(meal.area),
                              avatar: const Icon(Icons.flag, size: 16),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Ingredientes',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildIngredientsList(context, meal),
                      const SizedBox(height: 24),
                      Text(
                        'Instrucciones',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        meal.instructions.trim(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer2<MealDetailProvider, FavoritesProvider>(
        builder: (context, detailProvider, favoritesProvider, child) {
          if (detailProvider.meal == null) {
            return const SizedBox.shrink();
          }

          final meal = detailProvider.meal!;
          final isFavorite = favoritesProvider.isFavorite(meal.id);

          return FloatingActionButton(
            onPressed: () {
              favoritesProvider.toggleFavorite(meal);
            },
            backgroundColor: isFavorite
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceVariant,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          );
        },
      ),
    );
  }

  Widget _buildIngredientsList(BuildContext context, Meal meal) {
    List<Widget> ingredientWidgets = [];
    for (int i = 0; i < meal.ingredients.length; i++) {
      final ingredient = meal.ingredients[i];
      final measure = (i < meal.measures.length) ? meal.measures[i] : '';

      if (ingredient.trim().isEmpty) continue;

      ingredientWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '• $measure $ingredient',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredientWidgets,
    );
  }
}