import 'package:app/config.dart';
import 'package:flutter/material.dart';

class AppGlobalStyles {
  static final headingFontSize = 24.0;
  static final titleFontSize = 20.0;
  static final subtitleFontSize = 16.0;
  static final paragraphFontSize = 14.0;
  static final captionFontSize = 12.0;
  static final AppGlobalStyles _singleton = AppGlobalStyles._internal();
  static final darkColor = Colors.black54;
  // Noramal Dark color Text Styles
  static TextStyle heading =
      TextStyle(fontSize: headingFontSize, color: darkColor);
  static TextStyle title = TextStyle(fontSize: titleFontSize, color: darkColor);
  static TextStyle subtitle =
      TextStyle(fontSize: subtitleFontSize, color: darkColor);
  static TextStyle paragraph =
      TextStyle(fontSize: paragraphFontSize, color: darkColor);
  static TextStyle caption = TextStyle(
    fontSize: captionFontSize,
    fontWeight: FontWeight.w200,
    color: darkColor,
  );

  // Bold and Dark colored text styles
  static final TextStyle boldHeading = TextStyle(
    fontSize: headingFontSize,
    fontWeight: FontWeight.bold,
    color: darkColor,
  );
  static final TextStyle boldTitle = TextStyle(
    fontSize: titleFontSize,
    fontWeight: FontWeight.bold,
    color: darkColor,
  );
  static final TextStyle boldSubtitle = TextStyle(
    fontSize: subtitleFontSize,
    fontWeight: FontWeight.bold,
    color: darkColor,
  );
  static final TextStyle boldParagraph = TextStyle(
    fontSize: paragraphFontSize,
    fontWeight: FontWeight.bold,
    color: darkColor,
  );
  static final TextStyle boldCaption = TextStyle(
    fontSize: captionFontSize,
    fontWeight: FontWeight.bold,
    color: darkColor,
  );

  // Bold and Dark colored text styles
  static final TextStyle primaryBoldHeading = TextStyle(
    fontSize: headingFontSize,
    fontWeight: FontWeight.bold,
    color: AppGlobalConfig.primaryColor,
  );
  static final TextStyle primaryBoldTitle = TextStyle(
    fontSize: titleFontSize,
    fontWeight: FontWeight.bold,
    color: AppGlobalConfig.primaryColor,
  );
  static final TextStyle primaryBoldSubtitle = TextStyle(
    fontSize: subtitleFontSize,
    fontWeight: FontWeight.bold,
    color: AppGlobalConfig.primaryColor,
  );
  static final TextStyle primaryBoldParagraph = TextStyle(
    fontSize: paragraphFontSize,
    fontWeight: FontWeight.bold,
    color: AppGlobalConfig.primaryColor,
  );
  static final TextStyle primaryBoldCaption = TextStyle(
    fontSize: captionFontSize,
    fontWeight: FontWeight.bold,
    color: AppGlobalConfig.primaryColor,
  );

  static TextStyle orangeBoldHeading = TextStyle(
    fontSize: headingFontSize,
    fontWeight: FontWeight.bold,
    color: AppGlobalConfig.warningColor,
  );

  static TextStyle orangeBoldSubtitle = TextStyle(
    fontSize: headingFontSize,
    fontWeight: FontWeight.bold,
    color: AppGlobalConfig.warningColor,
  );

  static TextStyle orangeBoldCaption = TextStyle(
    fontSize: captionFontSize,
    fontWeight: FontWeight.bold,
    color: AppGlobalConfig.warningColor,
  );

  static TextStyle primaryHeading = TextStyle(
    fontSize: headingFontSize,
    color: AppGlobalConfig.primaryColor,
  );
  static TextStyle primaryTitle = TextStyle(
    fontSize: titleFontSize,
    color: AppGlobalConfig.primaryColor,
  );
  static TextStyle primarySubtitle = TextStyle(
    fontSize: subtitleFontSize,
    color: AppGlobalConfig.primaryColor,
  );
  static TextStyle primaryParagraph = TextStyle(
    fontSize: paragraphFontSize,
    color: AppGlobalConfig.primaryColor,
  );
  static TextStyle primaryCaption = TextStyle(
    fontSize: captionFontSize,
    color: AppGlobalConfig.primaryColor,
  );

  factory AppGlobalStyles() {
    return _singleton;
  }

  AppGlobalStyles._internal();
}

AppGlobalStyles globalStyles = AppGlobalStyles();
