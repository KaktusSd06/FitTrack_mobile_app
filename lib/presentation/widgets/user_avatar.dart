import 'package:flutter/material.dart';
import 'dart:math';

class UserAvatar extends StatelessWidget {
  final String fullName;
  final double size;

  const UserAvatar({super.key, required this.fullName, this.size = 70.0});

  @override
  Widget build(BuildContext context) {
    String initials = getInitials(fullName);
    Color bgColor = getRandomColor(fullName);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String getInitials(String name) {
    List<String> words = name.split(' ');
    String initials = words.map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').join();
    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }

  Color getRandomColor(String name) {
    final random = Random(name.hashCode);
    return Color.fromRGBO(
      100 + random.nextInt(156),
      100 + random.nextInt(156),
      100 + random.nextInt(156),
      1,
    );
  }
}
