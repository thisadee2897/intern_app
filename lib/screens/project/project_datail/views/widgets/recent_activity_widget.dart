import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/comment_model.dart';
import 'package:project/utils/extension/date_string_to_format_th.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../providers/controllers/recent_activity_controller.dart';

class RecentActivityWidget extends ConsumerStatefulWidget {
  const RecentActivityWidget({super.key});

  @override
  ConsumerState<RecentActivityWidget> createState() => _RecentActivityWidgetState();
}

class _RecentActivityWidgetState extends ConsumerState<RecentActivityWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentActivityProvider.notifier).getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recentActivityProvider);
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 400, // Add some space between rows
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
          Text('Stay up to date with what\'s happening across the project', style: Theme.of(context).textTheme.bodyMedium),
          Expanded(
            child: state.when(
              data: (data) {
                return listData(data);
              },
              error: (error, stack) {
                print('RecentActivityWidget Error: $stack');
                return Center(child: Text('Error: $error', style: const TextStyle(color: Colors.red)));
              },
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  ListView listData(List<CommentModel> data) {
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = data[index];
        final controller = QuillController(
          document: Document.fromJson(item.commentJson!),
          selection: const TextSelection.collapsed(offset: 0),
          keepStyleOnNewLine: true,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(child: Image.network('https://cdn-icons-png.flaticon.com/512/8792/8792047.png', width: 40, height: 40, fit: BoxFit.cover)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(item.createBy?.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Tooltip(
                              message: item.createdAt!.dateTimeTHFormApi,
                              child: Text(style: TextStyle(color: Colors.grey.shade600, fontSize: 12), timeago.format(DateTime.parse(item.createdAt!))),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8), color: Colors.white),
                        child: QuillEditor(
                          controller: controller,
                          focusNode: FocusNode(),
                          scrollController: ScrollController(),
                          config: QuillEditorConfig(padding: const EdgeInsets.all(12), scrollable: false, expands: false, embedBuilders: []),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
