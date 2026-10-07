import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdmobBanner extends StatelessWidget {
  final bool isPro;
  
  const AdmobBanner({super.key, this.isPro = false});

  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode || isPro) return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      height: 50,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(
        child: Text('AdMob Banner Placeholder', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
