import 'package:flutter/material.dart';

class MButton extends StatelessWidget {
  const MButton({
    Key key,
    this.leadingIcon,
    this.trailingIcon,
    this.label,
    this.onPressed,
    this.loading,
    this.disabled,
    this.backgroundColor,
  }) : super(key: key);

  final String label;
  final Widget leadingIcon;
  final Widget trailingIcon;
  final Function onPressed;
  final bool disabled;
  final bool loading;
  final Color backgroundColor;
  final double disabledOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    if (leadingIcon != null) {
      widgetList.add(
        leadingIcon,
      );
    }

    widgetList.add(
      Expanded(
        flex: 2,
        child: (loading ?? false)
            ? Container(
                height: 40,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Text(
                label != null ? label : 'Button',
                textAlign: TextAlign.center,
              ),
      ),
    );

    if (trailingIcon != null) {
      widgetList.add(
        trailingIcon,
      );
    }

    final buttonBackgroundColor = backgroundColor != null
        ? backgroundColor
        : Theme.of(context).primaryColor;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Opacity(
          opacity: disabled == true ? disabledOpacity : 1,
          child: Container(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) =>
                      disabled == true
                          ? Theme.of(context)
                              .primaryColor
                              .withOpacity(disabledOpacity)
                          : buttonBackgroundColor),
                  foregroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.white)),
              onPressed:
                  onPressed != null && disabled != true && loading != true
                      ? onPressed
                      : null,
              child: Row(
                children: widgetList,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
