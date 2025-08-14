import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypeOfWorkWidget extends ConsumerStatefulWidget {
  const TypeOfWorkWidget({super.key});

  @override
  ConsumerState<TypeOfWorkWidget> createState() => _TypeOfWorkWidgetState();
}

class _TypeOfWorkWidgetState extends ConsumerState<TypeOfWorkWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 400, // Add some space between rows
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
      child: Center(child: Text('Types of work', style: Theme.of(context).textTheme.titleLarge)),
    );
  }
}
