import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final int itemCount;
  final bool isGrid;

  const LoadingShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.itemCount = 6,
    this.isGrid = false,
  });

  const LoadingShimmer.card({
    super.key,
    this.width,
    this.height = 180,
    this.borderRadius = 16,
    this.itemCount = 1,
    this.isGrid = false,
  });

  const LoadingShimmer.list({
    super.key,
    this.width,
    this.height = 80,
    this.borderRadius = 12,
    this.itemCount = 5,
    this.isGrid = false,
  });

  const LoadingShimmer.grid({
    super.key,
    this.width,
    this.height = 160,
    this.borderRadius = 16,
    this.itemCount = 6,
    this.isGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return _buildGrid(context);
    }
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => _buildShimmerItem(context),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => _buildShimmerItem(context),
    );
  }

  Widget _buildShimmerItem(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(borderRadius),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.grey.shade200,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
