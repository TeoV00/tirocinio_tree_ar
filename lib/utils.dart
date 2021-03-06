import 'package:flutter/material.dart';

class Statistics {
  int papers;
  int co2;
  double progress;

  Statistics(this.papers, this.co2, this.progress);
}

void showSnackBar(BuildContext context, Widget content, Duration? duration) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: content, duration: duration ?? const Duration(seconds: 4)),
  );
}
