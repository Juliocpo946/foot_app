import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/components/molecules/loading_widget.dart';
import '../../../../shared/components/molecules/meal_card.dart';
import '../../../meals/presentation/providers/meal_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      Provider.of<MealProvider>(context, listen: false).searchMeals(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width > 1200
        ? 4
        : size.width > 800
        ? 3
        : size.width > 600
        ? 2
        : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.pushNamed(AppRoutes.favorites),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.pushNamed(AppRoutes.profile),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onSubmitted: _performSearch,
              decoration: InputDecoration(
                hintText: 'Buscar comida...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    Provider.of<MealProvider>(context, listen: false)
                        .reset();
                  },
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: Consumer<MealProvider>(
              builder: (context, mealProvider, child) {
                if (mealProvider.state == MealState.initial) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Busca tu comida favorita',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  );
                }

                if (mealProvider.state == MealState.loading) {
                  return const LoadingWidget(message: 'Buscando...');
                }

                if (mealProvider.state == MealState.error) {
                  return Center(
                    child: Text(mealProvider.errorMessage ?? 'Error'),
                  );
                }

                if (mealProvider.meals.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron resultados'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: mealProvider.meals.length,
                  itemBuilder: (context, index) {
                    final meal = mealProvider.meals[index];
                    return MealCard(
                      mealId: meal.id,
                      title: meal.name,
                      imageUrl: meal.thumbnail,
                      category: meal.category,
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
          ),
        ],
      ),
    );
  }
}