import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopSnackBar extends StatefulWidget {
  final String title;
  final String message;
  final ContentType contentType;
  final Color color;

  const TopSnackBar({
    super.key,
    required this.title,
    required this.message,
    required this.contentType,
    required this.color,
  });

  /// لضمان عدم تكرار السناك بار
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required ContentType contentType,
    required Color color,
  }) {
    _currentEntry?.remove(); // لو فيه واحد مفتوح يتقفل
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => TopSnackBar(
        title: title,
        message: message,
        contentType: contentType,
        color: color,
      ),
    );
    _currentEntry = entry;
    overlay.insert(entry);
  }

  @override
  State<TopSnackBar> createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<TopSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      await _controller.reverse();
      TopSnackBar._currentEntry?.remove();
      TopSnackBar._currentEntry = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40.h,
      left: 16.w,
      right: 16.w,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: AwesomeSnackbarContent(
              title: widget.title,
              message: widget.message,
              contentType: ContentType.success,
              color: widget.color,
              inMaterialBanner: true,
            ),
          ),
        ),
      ),
    );
  }
}
// }
//     TopSnackBar.show(
//                   context,
//                   title: context.isAr ? 'تم' : 'Done',
//                   message:
//                       context.isAr ? 'تمت الإضافة إلى السلة' : 'Added to Cart',
//                   contentType: ContentType.success,
//                   color: AppColors.mainColor,
//                 );
