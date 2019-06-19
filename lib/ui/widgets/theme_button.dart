import 'package:flutter/material.dart';
import 'package:flutter_bloc/utils/constants.dart';

class ThemeButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final double fontSize;
  final Color backgroundColor;
  final Color titleColor;
  final BorderRadius borderRadius;
  final bool isEnabled;
  final dynamic onPressed;

  ThemeButton(
      {@required this.title,
      @required this.onPressed,
      this.width = double.infinity,
      this.height = 41.0,
      this.fontSize = 16.0,
      this.backgroundColor,
      this.titleColor,
      this.isEnabled,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: titleColor != null ? titleColor : Colors.white,
              ),
            ),
          ),
        ),
        onPressed: onPressed,
      ),
      decoration: BoxDecoration(
        color: isEnabled ?? true
            ? backgroundColor ?? Theme.of(context).primaryColorDark
            : ColorConstant.grey[100],
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
    );
  }
}
