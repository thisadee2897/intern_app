import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:project/screens/project/project_datail/views/widgets/count_work_type_widget.dart';
import 'package:project/utils/extension/context_extension.dart';

class BacklogGroupWidget extends StatelessWidget {
  bool isExpanded;
  BacklogGroupWidget({super.key, this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_right_sharp, color: Colors.grey[700]),
                    onPressed: () {
                      // Handle back navigation
                    },
                  ),
                  Text("Title (1 work item)", style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              Row(
                children: [
                  CountWorkTypeWidget(title: 'todo', count: '0 of 0'),
                  CountWorkTypeWidget(title: 'in progress', count: '0 of 0', color: Colors.lightBlue),
                  CountWorkTypeWidget(title: 'in review', count: '0 of 0', color: Colors.deepOrange),
                  CountWorkTypeWidget(title: 'done', count: '0 of 0', color: Colors.lightGreenAccent),
                  // Create sprint button
                  OutlinedButton(onPressed: () {}, child: Text("Create Sprint")),
                ],
              ),
            ],
          ),
          // lsit items
          if (isExpanded)
            ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.check_circle_outline, color: context.primaryColor),
                  title: Text("Work Item ${index + 1}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 150,
                        //dropdown button for status
                        child: DropdownButtonFormField(
                          isDense: true,
                          decoration: InputDecoration(isDense: true, border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                          value: 'Todo',
                          items: <String>['Todo', 'In Progress', 'In Review', 'Done'].map((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis));
                          }).toList(),
                          onChanged: (String? newValue) {
                            // Handle status change
                          },
                        ),
                      ),
                      Gap(10),
                      // Icon AssignTo
                      CircleAvatar(radius: 12, backgroundColor: Colors.grey[300], child: Icon(Icons.person_outline, size: 16, color: Colors.grey[700])),
                      // Icon for more options
                      // if hover show more options
                      IconButton(
                        icon: Icon(Icons.more_vert, color: Colors.grey[500]),
                        onPressed: () {
                          // Handle more options
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
