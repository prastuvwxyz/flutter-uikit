import 'package:flutter/material.dart';

/// Semantic text variants used by MinimalText.
enum TextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  labelLarge,
  labelMedium,
  labelSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,

  // aliases
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  subtitle1,
  subtitle2,
  body1,
  body2,
  caption,
  overline,
  button,
}

class MinimalText extends StatelessWidget {
  const MinimalText(
    this.data, {
    super.key,
    this.variant = TextVariant.body1,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.locale,
    this.textScaleFactor,
    this.semanticsLabel,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.height,
    this.letterSpacing,
    this.wordSpacing,
  });

  final String data;
  final TextVariant variant;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final double? textScaleFactor;
  final String? semanticsLabel;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? height;
  final double? letterSpacing;
  final double? wordSpacing;

  bool _isHeading(TextVariant variant) {
    return const [
      TextVariant.displayLarge,
      TextVariant.displayMedium,
      TextVariant.displaySmall,
      TextVariant.headlineLarge,
      TextVariant.headlineMedium,
      TextVariant.headlineSmall,
      TextVariant.h1,
      TextVariant.h2,
      TextVariant.h3,
      TextVariant.h4,
      TextVariant.h5,
      TextVariant.h6,
    ].contains(variant);
  }

  TextStyle _getVariantStyle(BuildContext context, TextVariant variant) {
    final textTheme = Theme.of(context).textTheme;
    TextStyle result = textTheme.bodyMedium ?? const TextStyle(fontSize: 14);

    switch (variant) {
      case TextVariant.displayLarge:
      case TextVariant.h1:
        result = textTheme.displayLarge ?? const TextStyle(fontSize: 57);
        break;
      case TextVariant.displayMedium:
      case TextVariant.h2:
        result = textTheme.displayMedium ?? const TextStyle(fontSize: 45);
        break;
      case TextVariant.displaySmall:
      case TextVariant.h3:
        result = textTheme.displaySmall ?? const TextStyle(fontSize: 36);
        break;
      case TextVariant.headlineLarge:
      case TextVariant.h4:
        result = textTheme.headlineLarge ?? const TextStyle(fontSize: 32);
        break;
      case TextVariant.headlineMedium:
      case TextVariant.h5:
        result = textTheme.headlineMedium ?? const TextStyle(fontSize: 28);
        break;
      case TextVariant.headlineSmall:
      case TextVariant.h6:
        result = textTheme.headlineSmall ?? const TextStyle(fontSize: 24);
        break;
      case TextVariant.titleLarge:
      case TextVariant.subtitle1:
        result = textTheme.titleLarge ?? const TextStyle(fontSize: 22);
        break;
      case TextVariant.titleMedium:
      case TextVariant.subtitle2:
        result = textTheme.titleMedium ?? const TextStyle(fontSize: 16);
        break;
      case TextVariant.titleSmall:
        result = textTheme.titleSmall ?? const TextStyle(fontSize: 14);
        break;
      case TextVariant.bodyLarge:
      case TextVariant.body1:
        result = textTheme.bodyLarge ?? const TextStyle(fontSize: 16);
        break;
      case TextVariant.bodyMedium:
      case TextVariant.body2:
        result = textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
        break;
      case TextVariant.bodySmall:
      case TextVariant.caption:
        result = textTheme.bodySmall ?? const TextStyle(fontSize: 12);
        break;
      case TextVariant.labelLarge:
      case TextVariant.button:
        result = textTheme.labelLarge ?? const TextStyle(fontSize: 14);
        break;
      case TextVariant.labelMedium:
        result = textTheme.labelMedium ?? const TextStyle(fontSize: 12);
        break;
      case TextVariant.labelSmall:
      case TextVariant.overline:
        result = textTheme.labelSmall ?? const TextStyle(fontSize: 11);
        break;
    }

    return result;
  }

  TextStyle _composeStyle(BuildContext context) {
    final base = _getVariantStyle(context, variant);

    final merged = base.copyWith(
      color: color ?? base.color,
      fontWeight: fontWeight ?? base.fontWeight,
      fontStyle: fontStyle ?? base.fontStyle,
      decoration: decoration ?? base.decoration,
      decorationColor: decorationColor ?? base.decorationColor,
      decorationStyle: decorationStyle ?? base.decorationStyle,
      height: height ?? base.height,
      letterSpacing: letterSpacing ?? base.letterSpacing,
      wordSpacing: wordSpacing ?? base.wordSpacing,
    );

    if (style != null) return merged.merge(style);
    return merged;
  }

  @override
  Widget build(BuildContext context) {
    final composed = _composeStyle(context);

    return Semantics(
      label: semanticsLabel,
      header: _isHeading(variant),
      child: Text(
        data,
        style: composed,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textDirection: textDirection,
        locale: locale,
        textScaleFactor: textScaleFactor,
      ),
    );
  }
}
