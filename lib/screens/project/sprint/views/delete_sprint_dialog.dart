// lib/screens/project/sprint/views/delete_sprint_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/sprint/providers/controllers/delete_sprint_controller.dart';

class DeleteSprintDialog extends ConsumerWidget {
  final String sprintId;
  final String sprintName;

  const DeleteSprintDialog({
    super.key,
    required this.sprintId,
    required this.sprintName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteState = ref.watch(deleteSprintControllerProvider);
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red[700],
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'คุณแน่ใจหรือไม่?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'คุณต้องการลบ Sprint\n"$sprintName"',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              if (deleteState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'เกิดข้อผิดพลาด: ${deleteState.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 32),
              if (deleteState.isLoading)
                const CircularProgressIndicator()
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('ยกเลิก'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          side: BorderSide(
                            color: theme.colorScheme.primary,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await ref
                              .read(deleteSprintControllerProvider.notifier)
                              .deleteSprint(sprintId: sprintId);

                          if (context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('ยืนยันลบ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
