import 'package:flutter/material.dart';

// Widget untuk membuat layout yang responsive
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1000;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1000) {
          return desktop;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? desktop;
        } else {
          return mobile;
        }
      },
    );
  }
}

// Responsive container dengan padding yang adaptif
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? _getResponsivePadding(context),
      child: child,
    );
  }

  EdgeInsetsGeometry _getResponsivePadding(BuildContext context) {
    if (ResponsiveLayout.isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (ResponsiveLayout.isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }
}

// Text yang responsive berdasarkan screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double mobileFontSize;
  final double tabletFontSize;
  final double desktopFontSize;
  final TextAlign textAlign;

  const ResponsiveText({
    super.key,
    required this.text,
    this.style,
    this.mobileFontSize = 14,
    this.tabletFontSize = 16,
    this.desktopFontSize = 18,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize = ResponsiveLayout.isMobile(context)
        ? mobileFontSize
        : ResponsiveLayout.isTablet(context)
            ? tabletFontSize
            : desktopFontSize;

    return Text(
      text,
      style: style?.copyWith(fontSize: fontSize) ?? TextStyle(fontSize: fontSize),
      textAlign: textAlign,
    );
  }
}