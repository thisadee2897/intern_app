import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/controllers/dashboard_type_of_work_controller.dart';
import 'package:project/models/type_of_work_model.dart';

class DashboardTypeOfWorkWidget extends ConsumerStatefulWidget {
  const DashboardTypeOfWorkWidget({super.key});

  @override
  ConsumerState<DashboardTypeOfWorkWidget> createState() => _DashboardTypeOfWorkWidgetState();
}

class _DashboardTypeOfWorkWidgetState extends ConsumerState<DashboardTypeOfWorkWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardTypeOfWorkProvider.notifier).getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardTypeOfWorkProvider);
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 400, // Add some space between rows
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type of Work', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
          Text('Get a breakdown of work items by their type', style: Theme.of(context).textTheme.bodyMedium),
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

  ListView listData(List<TypeOfWorkModel> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var item = data[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(width: 150, child: Text(item.name.toString(), style: TextStyle(fontSize: 16))),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    var maxWidth = constraints.maxWidth;
                    var boxWidth = (maxWidth * item.count) / 100;
                    return SizedBox(
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Container(height: 40, width: maxWidth, color: Colors.grey[200]),
                            Container(height: 40, width: boxWidth, color: Colors.black38),
                            if (item.count > 0)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text('${item.count.toStringAsFixed(0)}%', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
