import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/update_controller.dart';
import 'package:project/screens/project/sprint/providers/controllers/project_controller.dart';

Future<void> showSprintFormDialog(
  BuildContext context,
  WidgetRef ref,
  ProjectHDModel project, [
  SprintModel? sprint,
]) async {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: sprint?.name ?? '');
  final _goalController = TextEditingController(text: sprint?.goal ?? '');
  final _durationController = TextEditingController(
    text: sprint?.duration?.toString() ?? '',
  );

  await showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: Text(sprint == null ? 'Create Sprint' : 'Edit Sprint'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: const TextStyle(fontSize: 16),
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Sprint Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter sprint name'
                              : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _goalController,
                  decoration: const InputDecoration(
                    labelText: 'Goal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (days)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Confirm Cancel'),
                        content: const Text('Are you sure you want to cancel?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final body = {
                    if (sprint != null &&
                        sprint.id != null &&
                        sprint.id!.isNotEmpty)
                      'id': sprint.id,
                    'name': _nameController.text.trim(),
                    'goal': _goalController.text.trim(),
                    'duration':
                        int.tryParse(_durationController.text.trim()) ?? 14,
                    'start_date': null,
                    'end_date': null,

                    'completed': sprint?.completed ?? false,
                    'active': sprint?.active ?? true,
                    'startting': sprint?.startting ?? false,
                    'project_hd_id': project.id ?? '',
                    'hd_id': "1",
                  };

                  // DEBUG LOG
                  print('======== DEBUG LOG ========');
                  print('Body to send: $body');
                  print('===========================');

                  await ref
                      .read(updateSprintControllerProvider.notifier)
                      .updateSprint(body: body);

                  final state = ref.read(updateSprintControllerProvider);
                  state.whenOrNull(
                    data: (sprintResponse) async {
                      print('API Response Success: $sprintResponse');

                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Success'),
                              content: const Text(
                                'Sprint saved successfully. Close the form?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        ref
                            .read(sprintByProjectControllerProvider.notifier)
                            .getSprints(project.id ?? '');
                        Navigator.of(context).pop();
                      }
                    },
                    error: (e, _) {
                      print('API Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save sprint: $e')),
                      );
                    },
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
  );

  _nameController.dispose();
  _goalController.dispose();
  _durationController.dispose();
}
