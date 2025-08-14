import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/project/project_datail/views/widgets/project_over_view_widget.dart';
import 'priority_breakdown_widget.dart';
import 'recent_activity_widget.dart';
import 'status_overview_widget.dart';
import 'team_workload_widget.dart';
import 'type_of_work_widget.dart';

class SummaryWidget extends BaseStatefulWidget {
  const SummaryWidget({super.key});
  @override
  BaseState<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends BaseState<SummaryWidget> {
  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                ProjectOverViewWidget(),
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
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                ProjectOverViewWidget(),
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
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                ProjectOverViewWidget(),
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

  TeamWorkloadWidget _teamWorkload(BuildContext context) {
    return TeamWorkloadWidget();
  }

  TypeOfWorkWidget _typesOfWork(BuildContext context) {
    return TypeOfWorkWidget();
  }

  PriorityBreakdownWidget _priorityBreakdown(BuildContext context) {
    return PriorityBreakdownWidget();
  }

  RecentActivityWidget _recentActivity(BuildContext context) {
    return RecentActivityWidget();
  }

  StatusOverviewWidget _statusOverview(BuildContext context) {
    return StatusOverviewWidget();
  }
}
