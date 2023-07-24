import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomTextForm extends StatefulWidget {
  CustomTextForm(
      {Key? key,
      required this.controller,
      this.enableBorder = true,
      this.authoFocus = true,
      this.hintText,
      this.lableText,
      this.cursorColor = Colors.green,
      this.filled = false,
      this.filledColor = Colors.transparent,
      this.hintTextStyle,
      this.obscuringCharacter = "*",
      this.readOnly = false,
      this.obscureText = false,
      this.onFieldSubmitted,
      this.lableTextStyle = const TextStyle(
        color: Colors.black,
      ),
      this.prefix,
      this.suffix,
      this.textStyle = const TextStyle(),
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.onTap,
      this.onChanged,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.inputFormatter,
      this.maxLine = 2,
      this.centerText = false,
      this.minLine = 1})
      : super(key: key);
  final TextEditingController controller;
  TextInputType keyboardType;
  TextInputAction textInputAction;

  final bool enableBorder;
  final bool filled;
  final bool readOnly;
  final bool obscureText;
  final bool authoFocus;
  final bool centerText;
  final AutovalidateMode? autovalidateMode;

  final String? hintText;
  final String? lableText;
  final String obscuringCharacter;

  final TextStyle? hintTextStyle;
  final TextStyle lableTextStyle;
  final TextStyle textStyle;

  final Color filledColor;
  final Color cursorColor;

  final Widget? suffix;
  final Widget? prefix;

  final Function? onTap;
  final String? Function(String?)? validator;
  Function(String)? onFieldSubmitted;
  Function(String)? onChanged;
  List<TextInputFormatter>? inputFormatter;
  final int maxLine;
  final int minLine;

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  bool makePasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return TextFormField(
      autofocus: widget.authoFocus,
      textAlign: widget.centerText ?  TextAlign.center : TextAlign.start,
      style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
          fontSize: deviceSize.width * 0.04),
      controller: widget.controller,
      cursorColor: widget.cursorColor,
      decoration: InputDecoration(
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: widget.filled,
        fillColor: widget.filledColor,
        labelText: widget.lableText,
        hintText: widget.hintText,
        hintStyle: widget.hintTextStyle ??
            TextStyle(
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
        labelStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyText2!.color,
            fontSize: deviceSize.width * 0.03),
        //  isDense: true,

        focusedErrorBorder: OutlineInputBorder(
          borderSide: widget.enableBorder
              ? const BorderSide(
                  width: 0.5,
                  color: Colors.red,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: widget.enableBorder
              ? const BorderSide(width: 0.5, color: Colors.red)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),

        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        suffixIcon: widget.suffix ?? _getSuffixWidget(deviceSize),
        prefixIcon: widget.prefix ?? null,
      ),
      onFieldSubmitted: (data) {
        if (widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(data);
          FocusScope.of(context).unfocus();
        } else {
          // FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      textInputAction: widget.textInputAction,
      validator: (value) => widget.validator!(value),
      obscureText: widget.obscureText ? makePasswordVisible : false,
      obscuringCharacter: widget.obscuringCharacter,
      onTap: () => widget.onTap,
      readOnly: false,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        } else {
          // FocusScope.of(context).unfocus();
        }
      },
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatter,
      autovalidateMode: widget.autovalidateMode,
    );
  }

  Widget _getSuffixWidget(Size deviceSize) {
    if (widget.obscureText) {
      return TextButton(
        onPressed: () {
          setState(() {
            makePasswordVisible = !makePasswordVisible;
          });
        },
        child: Icon(
          (!makePasswordVisible) ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).primaryColor,
          size: deviceSize.width * 0.045,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
