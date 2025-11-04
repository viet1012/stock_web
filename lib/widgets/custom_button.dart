import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final IconData? icon;
  final double width; // 👈 thêm width tuỳ chọn
  final double radius;
  final double fontSize;

  const CustomButton({
    Key? key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.icon,
    this.width = 150, // 👈 width tùy chọn
    this.radius = 8,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      icon: icon != null
          ? Icon(icon, color: Colors.white, size: 18)
          : const SizedBox.shrink(),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
    );

    // 👇 nếu có width thì dùng width đó, nếu không thì full width
    return SizedBox(width: width ?? double.infinity, height: 40, child: button);
  }
}
