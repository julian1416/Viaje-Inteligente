// lib/common/widgets/loading_indicator.dart

import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        // Opcional: puedes darle el color primario de tu tema.
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}