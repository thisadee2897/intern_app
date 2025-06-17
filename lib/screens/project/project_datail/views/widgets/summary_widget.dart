import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:project/components/export.dart';

import 'context_summary_widget.dart';

class SummaryWidget extends BaseStatefulWidget {
  const SummaryWidget({super.key});
  @override
  BaseState<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends BaseState<SummaryWidget> {
  List<Widget> contextSummaryWidgets = [
    ContextSummaryWidget(title: 'Completed Tasks', count: '10'),
    ContextSummaryWidget(title: 'In Progress Tasks', count: '5'),
    ContextSummaryWidget(title: 'INPENDING', count: '2'),
    ContextSummaryWidget(title: 'Due soon', count: '3'),
  ];
  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double contextSummaryWidth = constraints.maxWidth / 4;
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(children: contextSummaryWidgets.map((widget) => SizedBox(width: contextSummaryWidth, child: widget)).toList()),
                Row(
                  children: [
                    SizedBox(width: constraints.maxWidth / 2, child: _statusOverview(context)),
                    SizedBox(width: constraints.maxWidth / 2, child: _recentActivity(context)),
                  ],
                ),
                Gap(5),
                Row(
                  children: [
                    SizedBox(width: constraints.maxWidth / 2, child: _priorityBreakdown(context)),
                    SizedBox(width: constraints.maxWidth / 2, child: _typesOfWork(context)),
                  ],
                ),
                Gap(5),
                SizedBox(width: constraints.maxWidth / 2, child: _teamWorkload(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double contextSummaryWidth = constraints.maxWidth / 2;
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: contextSummaryWidgets.take(2).map((widget) => SizedBox(width: contextSummaryWidth, child: widget)).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: contextSummaryWidgets.skip(2).map((widget) => SizedBox(width: contextSummaryWidth, child: widget)).toList(),
                ),
                Row(
                  children: [
                    SizedBox(width: constraints.maxWidth / 2, child: _statusOverview(context)),
                    SizedBox(width: constraints.maxWidth / 2, child: _recentActivity(context)),
                  ],
                ),
                Gap(5),
                Row(
                  children: [
                    SizedBox(width: constraints.maxWidth / 2, child: _priorityBreakdown(context)),
                    SizedBox(width: constraints.maxWidth / 2, child: _typesOfWork(context)),
                  ],
                ),
                Gap(5),
                SizedBox(width: constraints.maxWidth / 2, child: _teamWorkload(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double contextSummaryWidth = constraints.maxWidth;
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Column(children: contextSummaryWidgets.map((widget) => SizedBox(width: contextSummaryWidth, child: widget)).toList()),
                SizedBox(width: constraints.maxWidth, child: _statusOverview(context)),
                Gap(5),
                SizedBox(width: constraints.maxWidth, child: _recentActivity(context)),
                Gap(5),
                SizedBox(width: constraints.maxWidth, child: _priorityBreakdown(context)),
                Gap(5),
                SizedBox(width: constraints.maxWidth, child: _typesOfWork(context)),
                Gap(5),
                SizedBox(width: constraints.maxWidth, child: _teamWorkload(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _teamWorkload(BuildContext context) {
    return Container(
      height: 300, // Add some space between rows
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
      child: Center(child: Text('Team workload', style: Theme.of(context).textTheme.titleLarge)),
    );
  }

  Container _typesOfWork(BuildContext context) {
    return Container(
      height: 300, // Add some space between rows
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
      child: Center(child: Text('Types of work', style: Theme.of(context).textTheme.titleLarge)),
    );
  }

  Container _priorityBreakdown(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 300, // Add some space between rows
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
      child: Center(child: Text('Priority breakdown', style: Theme.of(context).textTheme.titleLarge)),
    );
  }

  Container _recentActivity(BuildContext context) {
    return Container(
      height: 300, // Add some space between rows
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
      child: Center(child: Text('Recent activity', style: Theme.of(context).textTheme.titleLarge)),
    );
  }

  Container _statusOverview(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 300, // Add some space between rows
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
      child: Center(child: Text('Status overview', style: Theme.of(context).textTheme.titleLarge)),
    );
  }
}
