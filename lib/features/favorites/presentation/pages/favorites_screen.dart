import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/components/molecules/loading_widget.dart';
import '../../../../shared/components/molecules/restaurant_meal_card.dart';
import '../providers/favorites_provider.dart';
import '../../../../shared/components/molecules/error_widget.dart' as app_error;

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, provider, child) {
          if (provider.state == FavoritesState.loading ||
              provider.state == FavoritesState.initial) {
            return const LoadingWidget(message: 'Cargando favoritos...');
          }

          if (provider.state == FavoritesState.error) {
            return app_error.ErrorWidget(
              message: provider.errorMessage ?? 'Error al cargar favoritos',
              onRetry: () {
                provider.loadFavorites();
              },
            );
          }

          if (provider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes favoritos aún',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final meal = provider.favorites[index];
              return RestaurantMealCard(
                imageUrl: meal.thumbnail,
                title: meal.name,
                deliveryTime: 30 + (index * 5),
                category: meal.category,
                area: meal.area,
                rating: 0.88 + (index * 0.02),
                votes: 24 + (index * 5),
                onTap: () {
                  context.pushNamed(
                    AppRoutes.mealDetail,
                    pathParameters: {'id': meal.id},
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}