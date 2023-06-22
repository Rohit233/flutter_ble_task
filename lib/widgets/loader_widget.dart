import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  final String message;
  const LoaderWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Text(message)
        ],
      );
  }
}