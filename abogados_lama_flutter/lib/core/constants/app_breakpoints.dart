class AppBreakpoints {
  static const double mobileMax = 768.0;
  static const double tabletMax = 1024.0;

  // Responsive state calculators
  static bool isMobile(double width) => width <= mobileMax;
  static bool isTablet(double width) => width > mobileMax && width <= tabletMax;
  static bool isDesktop(double width) => width > tabletMax;
}
