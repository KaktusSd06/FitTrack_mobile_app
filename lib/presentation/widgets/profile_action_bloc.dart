import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionBlock extends StatelessWidget {
  final String svgPath;
  final String text;
  final Function onTap;
  final bool isLastItem;

  const ActionBlock({
    super.key,
    required this.svgPath,
    required this.text,
    required this.onTap,
    this.isLastItem = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 0),
        decoration: BoxDecoration(
          border: !isLastItem
              ? Border(
            bottom: BorderSide(
              color: Theme.of(context).hintColor,
              width: 1,
            ),
          )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: SvgPicture.asset(
                    svgPath,
                    width: 24.0,
                    height: 24.0,
                    colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(text, style: Theme.of(context).textTheme.displaySmall),
              ],
            ),
            const Icon(CupertinoIcons.forward, color: Colors.orange, size: 24.0),
          ],
        ),
      ),
    );
  }
}