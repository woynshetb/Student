// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      required this.title,
      required this.onPressed,
      this.showBorder = false,
      this.borderColor = Colors.transparent,
      this.elevation = 1,
      this.width = 0,
      this.height = 0,
      this.textColor = Colors.white,
      this.child,
      this.fontSize,
      this.backgroundColor = Colors.transparent})
      : super(key: key);

  final String title;
  final Function? onPressed;
  final double? fontSize;
  bool showBorder;
  Color borderColor;
  double elevation;
  Color backgroundColor;
  Color textColor;
  double width;
  double height;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return ButtonTheme(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          surfaceTintColor: backgroundColor,
          // shadowColor: backgroundColor,
          elevation: elevation,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          primary: backgroundColor,
          onSurface: null,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor, width: 0.3),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () => {onPressed!()},
        child: SizedBox(
           width: width == 0 ? deviceSize.width * 0.6 : width,
              height: height == 0 ? deviceSize.height * 0.07 : height,
          child: child ??
              Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600
                    
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
