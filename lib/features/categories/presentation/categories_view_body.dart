import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sign_lang_app/core/routing/routes.dart';
import 'package:sign_lang_app/core/theming/styles.dart';
import 'package:sign_lang_app/core/utils/extentions.dart';
import 'package:sign_lang_app/features/categories/data/models/category_res.dart';
import 'package:sign_lang_app/features/categories/presentation/manager/cubit/categories_cubit.dart';

class CategoriesViewBody extends StatelessWidget {
  const CategoriesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'assets/images/intoduce_your_self.svg',
      'assets/images/bodyParts.svg',
      'assets/images/Group 36873.svg',
    // 'assets/images/body_parts.svg'
      'assets/images/favourites.svg',
      'assets/images/nature.svg',
      'assets/images/Group 36873.svg',

    ];

    return ListViewBlocConsumer(imagePaths: imagePaths);
  }
}

class ListViewBlocConsumer extends StatefulWidget {
  const ListViewBlocConsumer({super.key, required this.imagePaths});
  final List<String> imagePaths;

  @override
  State<ListViewBlocConsumer> createState() => _ListViewBlocConsumerState();
}

class _ListViewBlocConsumerState extends State<ListViewBlocConsumer> {
  @override
  Widget build(BuildContext context) {
    context.read<CategoriesCubit>().fetchDictionaryList();

    return BlocConsumer<CategoriesCubit, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoriesSuccess) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: state.categories.length,
            itemBuilder: (BuildContext context, int index) {
              final category = state.categories[index];
              final imagePath = widget.imagePaths[index % widget.imagePaths.length];
              final isLeft = index % 2 == 0;
              final isLast = index == state.categories.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment:
                          isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
                      children: [
                        CategoriesItem(
                          category: category,
                          imagePath: imagePath,
                          textAlign: isLeft ? TextAlign.start : TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    CustomPaint(
                      size: const Size(double.infinity, 80),
                      painter: DashedLinePainter(
                        isLeft: isLeft,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                ],
              );
            },
          );
        } else {
          return Center(
            child: Text(
              'No categories available.',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          );
        }
      },
    );
  }
}

class CategoriesItem extends StatelessWidget {
  final String imagePath;
  final CategoryModel category;
  final TextAlign textAlign;

  const CategoriesItem({
    super.key,
    required this.imagePath,
    required this.category,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLeft = textAlign == TextAlign.start;

    return Row(
      mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (!isLeft)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              category.name,
              style: TextStyles.font16GraySemibold.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              height: 160,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.primaryFixed,
              ),
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(Routes.LevelsView, arguments: {
                    'categoryId': category.id,
                    'categoryName': category.name,
                    'categoryImage': imagePath,
                  });
                },
                child: SvgPicture.asset(
                  imagePath,
                  height: 75,
                  width: 75,
                ),
              ),
            ),
            // علامة الصح
            Positioned(
              top: -10,
              right: isLeft ? -10 : null,
              left: isLeft ? null : -10,
              child: SvgPicture.asset(
                'assets/icons/Checkbox.svg',
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        if (isLeft)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Wrap(
              children: [
                Text(
                  category.name,
                  style: TextStyles.font16GraySemibold.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final bool isLeft;
  final Color color;
  
  DashedLinePainter({required this.isLeft, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    const double startX = 160; // العرض الكامل للكارت تقريبا
    const double midX = 40;

    if (isLeft) {
      path.moveTo(startX, 0); // بداية من يمين العنصر
      path.cubicTo(startX, 30, size.width - midX, 30, size.width - midX, size.height);
    } else {
      path.moveTo(size.width - startX, 0); // بداية من يسار العنصر
      path.cubicTo(size.width - startX, 30, midX, 30, midX, size.height);
    }

    drawDashedPath(canvas, path, paint);
  }

  void drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 15.0;
    const dashSpace = 10.0;

    final PathMetrics pathMetrics = path.computeMetrics();
    for (final PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final double next = distance + dashWidth;
        final Path extractPath = pathMetric.extractPath(distance, next);
        canvas.drawPath(extractPath, paint);
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
