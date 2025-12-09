import 'package:flutter/material.dart';

class LoadingOverlayItem extends StatelessWidget {
  const LoadingOverlayItem ({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}