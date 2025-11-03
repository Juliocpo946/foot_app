import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/components/molecules/category_filter.dart';
import '../../../../shared/components/molecules/loading_widget.dart';
import '../../../../shared/components/molecules/restaurant_meal_card.dart';
import '../providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

@override
State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).loadCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      Provider.of<HomeProvider>(context, listen: false).searchMeals(query);
    }
  }

  List<CategoryItem> _buildCategoryItems(List<String> categories) {
    final categoryImages = {
      'Beef': 'https://www.themealdb.com/images/category/beef.png',
      'Chicken': 'https://www.themealdb.com/images/category/chicken.png',
      'Dessert': 'https://www.themealdb.com/images/category/dessert.png',
      'Lamb': 'https://www.themealdb.com/images/category/lamb.png',
      'Pasta': 'https://www.themealdb.com/images/category/pasta.png',
      'Pork': 'https://www.themealdb.com/images/category/pork.png',
      'Seafood': 'https://www.themealdb.com/images/category/seafood.png',
      'Vegetarian':
      'https://www.themealdb.com/images/category/vegetarian.png',
    };

    return categories
        .map((category) => CategoryItem(
      name: category,
      imageUrl: categoryImages[category] ?? '',
    ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: _showSearch
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Buscar comida...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          onSubmitted: _performSearch,
        )
            : Text(
          'Tijuana, B.C.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  Provider.of<HomeProvider>(context, listen: false).reset();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return Column(
            children: [
              if (homeProvider.categories.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CategoryFilter(
                    categories: _buildCategoryItems(homeProvider.categories),
                    selectedCategory: homeProvider.selectedCategory,
                    onCategorySelected: (category) {
                      homeProvider.filterByCategory(category);
                    },
                  ),
                ),
              Expanded(
                child: _buildContent(homeProvider, isTablet),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(HomeProvider homeProvider, bool isTablet) {
    if (homeProvider.state == HomeState.initial) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Busca tu comida favorita',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'o filtra por categorías',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    if (homeProvider.state == HomeState.loading) {
      return const LoadingWidget(message: 'Cargando...');
    }

    if (homeProvider.state == HomeState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              homeProvider.errorMessage ?? 'Error',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (homeProvider.meals.isEmpty) {
      return const Center(
        child: Text('No se encontraron resultados'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      itemCount: homeProvider.meals.length,
      itemBuilder: (context, index) {
        final meal = homeProvider.meals[index];
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
  }
}