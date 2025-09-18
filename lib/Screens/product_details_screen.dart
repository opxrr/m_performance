import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_performance/cubit/car_cubit/performance_state.dart';
import 'package:m_performance/m_database/part_manager.dart';

import '../cubit/car_cubit/car_logic.dart';
import '../cubit/car_cubit/car_state.dart';
import '../cubit/car_cubit/performance_stats_row.dart';
import '../m_database/models/car.dart';
import '../m_database/models/part.dart';
import '../m_database/models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = 'productDetailsScreen';
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _imagesPrecached = false;
  late PartManager _partManager;
  late Future<List<Part>> _partsFuture;

  @override
  void initState() {
    super.initState();
    _partManager = PartManager();
    _partsFuture = _partManager.getAllParts();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    if (widget.product is Car) {
      context.read<CarLogic>().showCar(widget.product as Car);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      precacheImage(AssetImage(widget.product.imagePath), context);
      precacheImage(
        const AssetImage('assets/images/placeholder.jpeg'),
        context,
      );
      precacheImage(const AssetImage('assets/images/mWallPaper.jpeg'), context);
      _partManager.getAllParts().then((parts) {
        for (var part in parts) {
          precacheImage(AssetImage(part.imagePath), context);
        }
      });
      _imagesPrecached = true;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _partManager.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      if (_isFavorite) {
        _animationController.forward().then(
          (_) => _animationController.reverse(),
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCustomize() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomContext) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (bottomContext, scrollController) =>
            BlocBuilder<CarLogic, CarState>(
              builder: (bottomContext, state) {
                Car car = widget.product is Car
                    ? widget.product as Car
                    : Car(
                        id: 0,
                        modelName: 'Unknown',
                        price: 0,
                        imagePath: 'assets/images/placeholder.jpeg',
                        description: 'No description available',
                        horsepower: 0,
                        topSpeed: 0,
                        weight: 0,
                        zeroToHundred: 0,
                      );
                Car originalCar = car;
                List<Part> appliedParts = [];
                if (state is ShowCar) {
                  car = state.car;
                  originalCar = state.originalCar;
                  appliedParts = state.appliedParts;
                } else if (state is UpdateCar) {
                  car = state.car;
                  originalCar = state.originalCar;
                  appliedParts = state.appliedParts;
                }
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Customize Your Car',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PerformanceStats(
                        horsepower: car.horsepower.toDouble(),
                        speed: car.topSpeed.toDouble(),
                        weight: car.weight.toDouble(),
                        acceleration: car.zeroToHundred,
                        originalCar: originalCar,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Suggested Parts',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      SizedBox(
                        height: 130,
                        child: FutureBuilder<List<Part>>(
                          future: _partsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error loading parts'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('No parts available'),
                              );
                            }

                            final parts = snapshot.data!;
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              children: parts.map((part) {
                                final isSelected = appliedParts.any(
                                  (p) => p.id == part.id,
                                );
                                return GestureDetector(
                                  onTap: () {
                                    context.read<CarLogic>().applyPartUpgrade(
                                      originalCar,
                                      part,
                                    );
                                  },
                                  child: Card(
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).primaryColor.withOpacity(0.7)
                                        : Theme.of(
                                            context,
                                          ).cardColor.withOpacity(0.9),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    child: Container(
                                      width: 110,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: isSelected
                                                    ? Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        width: 1.5,
                                                      )
                                                    : null,
                                              ),
                                              child: Image.asset(
                                                part.imagePath,
                                                height: 48,
                                                width: 48,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Image.asset(
                                                      'assets/images/placeholder.jpeg',
                                                      height: 48,
                                                      width: 48,
                                                      fit: BoxFit.cover,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Flexible(
                                            child: Text(
                                              part.partName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.color,
                                                    fontSize: 12,
                                                  ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CarLogic, CarState>(
      builder: (context, state) {
        Car car = widget.product is Car
            ? widget.product as Car
            : Car(
                id: 0,
                modelName: 'Unknown',
                price: 0,
                imagePath: 'assets/images/placeholder.jpeg',
                description: 'No description available',
                horsepower: 0,
                topSpeed: 0,
                weight: 0,
                zeroToHundred: 0,
              );
        Car originalCar = car;
        List<Part> appliedParts = [];
        if (state is ShowCar) {
          car = state.car;
          originalCar = state.originalCar;
          appliedParts = state.appliedParts;
        } else if (state is UpdateCar) {
          car = state.car;
          originalCar = state.originalCar;
          appliedParts = state.appliedParts;
        }

        final totalPrice =
            widget.product.price +
            appliedParts.fold<double>(0, (sum, part) => sum + part.price);

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              widget.product.name,
              style: theme.textTheme.headlineLarge,
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.secondaryHeaderColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: theme.iconTheme.color,
                size: 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share, color: theme.iconTheme.color, size: 24),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share feature coming soon!')),
                  );
                },
                tooltip: 'Share Product',
              ),
              IconButton(
                icon: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite
                        ? Colors.redAccent
                        : theme.iconTheme.color,
                    size: 24,
                  ),
                ),
                onPressed: _toggleFavorite,
                tooltip: 'Toggle Favorite',
              ),
            ],
          ),
          floatingActionButton: widget.product is! Car
              ? FloatingActionButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to Cart')),
                    );
                  },
                  backgroundColor:
                      theme.floatingActionButtonTheme.backgroundColor,
                  tooltip: 'Add to Cart',
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: theme.floatingActionButtonTheme.foregroundColor,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: 'customize',
                      onPressed: _showCustomize,
                      backgroundColor:
                          theme.floatingActionButtonTheme.backgroundColor,
                      tooltip: 'Customize',
                      child: Icon(
                        Icons.build,
                        color: theme.floatingActionButtonTheme.foregroundColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FloatingActionButton(
                      heroTag: 'cart',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to Cart')),
                        );
                      },
                      backgroundColor:
                          theme.floatingActionButtonTheme.backgroundColor,
                      tooltip: 'Add to Cart',
                      child: Icon(
                        Icons.add_shopping_cart,
                        color: theme.floatingActionButtonTheme.foregroundColor,
                      ),
                    ),
                  ],
                ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/mWallPaper.jpeg',
                  color: Colors.black54,
                  colorBlendMode: BlendMode.darken,
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 100),
                    // Hero Image
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      // No bottom padding
                      child: Hero(
                        tag:
                            'product-image-${widget.product.id ?? widget.product.name}',
                        child: GestureDetector(
                          onDoubleTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: InteractiveViewer(
                                  panEnabled: true,
                                  minScale: 0.5,
                                  maxScale: 4.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.asset(
                                      widget.product.imagePath,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => Image.asset(
                                            'assets/images/placeholder.jpeg',
                                            fit: BoxFit.contain,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              widget.product.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    'assets/images/placeholder.jpeg',
                                    fit: BoxFit.contain,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Performance Stats Row
                    if (widget.product is Car)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: PerformanceStatsRow(
                          horsepower: car.horsepower.toStringAsFixed(1),
                          topSpeed: '${car.topSpeed.toStringAsFixed(1)} km/h',
                          weight: '${car.weight.toStringAsFixed(1)} kg',
                          acceleration:
                              '${car.zeroToHundred.toStringAsFixed(1)} s',
                        ),
                      ),
                    const SizedBox(height: 20),
                    // Product Details
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: theme.dividerColor.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Price (including applied parts)
                                Text(
                                  '\$${totalPrice.toStringAsFixed(2)}',
                                  style: theme.textTheme.headlineLarge,
                                ),
                                const SizedBox(height: 16),
                                // Description
                                Text(
                                  'Description',
                                  style: theme.textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.product.description,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
