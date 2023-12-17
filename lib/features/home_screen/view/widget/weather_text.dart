import 'package:flutter/widgets.dart';

class WeatherText extends StatelessWidget {
  final String text;
  const WeatherText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
