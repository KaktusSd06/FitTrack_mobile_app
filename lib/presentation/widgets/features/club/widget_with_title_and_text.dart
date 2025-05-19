import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WidgetWithTitleAndText extends StatelessWidget {
  final String title, text;
  final String? imgPath, icon;
  final bool isBtnIcon;
  final Function onTap;


  const WidgetWithTitleAndText(
      {required this.title, required this.text, required this.imgPath, required this.icon, required this.isBtnIcon, super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme
                .of(context)
                .cardColor,
            boxShadow: [
              BoxShadow(
                color: Theme
                    .of(context)
                    .brightness == Brightness.light
                    ? Colors.black.withAlpha((0.1 * 255).round())
                    : Colors.white.withAlpha((0.1 * 255).round()),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    imgPath != null
                        ? Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(imgPath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ) : SvgPicture.asset(
                      icon!,
                      height: 32,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).hintColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            title,
                            style: Theme
                                .of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(fontWeight: FontWeight.w500)
                        ),
                        Text(text, style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w300))
                      ],
                    ),
                  ],
                ),
                if(isBtnIcon)
                  Container(
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(26))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/change_icon.svg",
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        )
    );
  }
}