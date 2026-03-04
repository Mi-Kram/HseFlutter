import 'package:catotinder/src/presentation/onboarding/widgets/swipe_cat_widget.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData iconData;
  final int pageIndex;
  final PageController controller;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.iconData,
    required this.pageIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                double value = 0;
                if (controller.hasClients &&
                    controller.position.haveDimensions) {
                  value =
                      (controller.page ?? controller.initialPage.toDouble()) -
                      pageIndex;
                  value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                } else {
                  value = 1.0;
                }

                return Transform.scale(
                  scale: value,
                  child: Transform.translate(
                    offset: Offset(value * 10 * (pageIndex.isEven ? 1 : -1), 0),
                    child: child,
                  ),
                );
              },
              child: pageIndex == 0
                  ? SwipeCatWidget(color: Theme.of(context).primaryColor)
                  : Icon(
                      iconData,
                      size: 160,
                      color: Theme.of(context).primaryColor,
                    ),
            ),
          ),
          const SizedBox(height: 32),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              final offsetAnimation =
                  Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  );
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: offsetAnimation, child: child),
              );
            },
            child: Column(
              key: ValueKey(title),
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
