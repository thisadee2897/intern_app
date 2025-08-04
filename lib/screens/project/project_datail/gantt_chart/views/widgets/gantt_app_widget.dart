import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/auth/widgets/custom_text_field.dart';
import 'package:project/utils/extension/async_value_sliver_extension.dart';
import '../../providers/controllers/gantt_data_controller.dart';
import 'gantt_chart_widget.dart';

class GanttAppWidget extends ConsumerStatefulWidget {
  const GanttAppWidget({super.key});

  @override
  ConsumerState<GanttAppWidget> createState() => _GanttAppWidgetState();
}

class _GanttAppWidgetState extends ConsumerState<GanttAppWidget> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("Fetching Gantt Data");
      await ref.read(ganttDataProvider.notifier).get();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ganttDataProvider);
    return state.appWhen(
      dataBuilder:
          (data) => Row(
            children: [
              Expanded(child: GanttChartWidget(data ?? [])),
              AnimatedContainer(
                decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.shade300, width: 1))),
                duration: const Duration(milliseconds: 200),
                width: ref.watch(isShowDetailTaskProvider) ? 500 : 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Task Details",
                          // style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            ref.read(isShowDetailTaskProvider.notifier).state = false;
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: 10,
                            children: [
                              CustomTextField(
                                controller: TextEditingController(),
                                label: 'อีเมล',
                                hint: 'กรุณากรอกอีเมลของคุณ',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator:null,
                              ),
                              // Row(children: [Text("Task Name: "), SizedBox(
                              //   height: 40,
                              //   width: 300,
                              //   child: TextFormField())]),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 20, // Example count, replace with actual task count
                                itemBuilder: (context, index) {
                                  return Row(children: [Text("Task ${index + 1}: "), Expanded(child: TextFormField())]);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

final isShowDetailTaskProvider = StateProvider<bool>((ref) => false);
