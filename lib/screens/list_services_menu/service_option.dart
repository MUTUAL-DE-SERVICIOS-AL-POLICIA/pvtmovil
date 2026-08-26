import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Colores del tema (style.dart)
const _kPrimaryGreen = Color(0xff419388);

class ServiceOption extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onPressed;

  const ServiceOption({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xff1e3d37) : _kPrimaryGreen,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withAlpha((0.4 * 255).toInt())
                    : Colors.black.withAlpha((0.25 * 255).toInt()),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // -- Panel izquierdo verde con imagen circular --
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha((0.35 * 255).toInt()),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // -- Panel derecho blanco con texto --
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xff2a4f49) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21.sp,
                          color: isDarkMode ? Colors.white : _kPrimaryGreen,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: isDarkMode
                              ? Colors.white70
                              : Colors.black87,
                          height: 1.4,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
