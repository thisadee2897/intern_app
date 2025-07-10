import 'package:flutter/material.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/project_datail/views/widgets/count_work_type_widget.dart';
import 'package:project/screens/project/sprint/views/widgets/insert_update_sprint.dart';
import 'package:project/utils/extension/context_extension.dart';

class BacklogGroupWidget extends StatefulWidget {
  final bool isExpanded;
  final SprintModel? item;
  const BacklogGroupWidget({super.key, this.isExpanded = false, this.item});

  @override
  State<BacklogGroupWidget> createState() => _BacklogGroupWidgetState();
}

class _BacklogGroupWidgetState extends State<BacklogGroupWidget> {
  bool isExpanding = false;

  @override
  void initState() {
    isExpanding = widget.isExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;

        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              isExpanding
                                  ? const Icon(Icons.expand_less)
                                  : const Icon(Icons.expand_more),
                          onPressed: () {
                            setState(() {
                              isExpanding = !isExpanding;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            widget.item?.name ?? 'Backlog',
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isSmallScreen)
                    Flexible(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        alignment: WrapAlignment.end,
                        children: _buildCountersAndButton(),
                      ),
                    ),
                ],
              ),

              if (isSmallScreen)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: _buildCountersAndButton(),
                  ),
                ),

              if (isExpanding)
                ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(
                        Icons.check_circle_outline,
                        color: context.primaryColor,
                      ),
                      title: Text("Work Item ${index + 1}"),

                      trailing: SizedBox(
                        width: isSmallScreen ? constraints.maxWidth * 0.5 : 300,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            SizedBox(
                              width: 120,
                              child: DropdownButtonFormField(
                                isDense: true,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                ),
                                value: 'Todo',
                                items:
                                    <String>[
                                          'Todo',
                                          'In Progress',
                                          'In Review',
                                          'Done',
                                        ]
                                        .map(
                                          (value) => DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (newValue) {},
                              ),
                            ),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey[300],
                              child: const Icon(
                                Icons.person_outline,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildCountersAndButton() {
    return [
      CountWorkTypeWidget(title: 'todo', count: '0 of 0'),
      CountWorkTypeWidget(
        title: 'in progress',
        count: '0 of 0',
        color: Colors.lightBlue,
      ),
      CountWorkTypeWidget(
        title: 'in review',
        count: '0 of 0',
        color: Colors.deepOrange,
      ),
      CountWorkTypeWidget(
        title: 'done',
        count: '0 of 0',
        color: Colors.lightGreenAccent,
      ),
      OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InsertUpdateSprint()),
          );
        },
        child: const Text("Create Sprint"),
      ),
    ];
  }
}
