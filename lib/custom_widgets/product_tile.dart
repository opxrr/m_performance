import 'package:flutter/material.dart';
import 'package:m_performance/Screens/product_details_screen.dart';
import 'package:m_performance/m_database/models/product.dart';

class MyProductTile extends StatefulWidget {
  final Product product;
  final VoidCallback? onFavoriteChanged;

  const MyProductTile({
    super.key,
    required this.product,
    this.onFavoriteChanged,
  });

  @override
  State<MyProductTile> createState() => _MyProductTileState();
}

class _MyProductTileState extends State<MyProductTile> {
  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorited
              ? '${widget.product.name} added to favorites!'
              : '${widget.product.name} removed from favorites!',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    widget.onFavoriteChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductDetailsScreen.routeName,
          arguments: widget.product,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Image.asset(
                  widget.product.imagePath,
                  width: 290,
                  height: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/placeholder.jpeg',
                    width: 120,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: AnimatedScale(
                      scale: _isFavorited ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorited ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.2,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
