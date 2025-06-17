import 'package:riverpod/riverpod.dart';

final mockupBacklogGroupProvider = Provider<List<BacklogGroupModel>>((ref) {
  return [
    BacklogGroupModel(
      titleId: 'todo',
      title: 'To Do',
      itemCount: 5,
      todoCount: 5,
      inProgressCount: 0,
      reviewCount: 0,
      doneCount: 0,
      isBacklog: true,
      backlogItems: [
        BacklogitemModel(
          id: '1',
          title: 'Task 1',
          description: 'Description for Task 1',
          status: 'todo',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          assignedTo: 'user1',
          projectId: 'project1',
          groupId: 'group1',
          storyPoints: 3,
        ),
        // Add more items as needed
      ],
    ),
    // Add more groups as needed
  ];
});

class BacklogGroupModel {
  String? titleId;
  String? title;
  num? itemCount;
  num? todoCount;
  num? inProgressCount;
  num? reviewCount;
  num? doneCount;
  bool? isBacklog;
  List<BacklogitemModel>? backlogItems;
  BacklogGroupModel({
    this.titleId,
    this.title,
    this.itemCount,
    this.todoCount,
    this.inProgressCount,
    this.reviewCount,
    this.doneCount,
    this.isBacklog,
    this.backlogItems,
  });
  //copyWith method
  BacklogGroupModel copyWith({
    String? titleId,
    String? title,
    num? itemCount,
    num? todoCount,
    num? inProgressCount,
    num? reviewCount,
    num? doneCount,
    bool? isBacklog,
    List<BacklogitemModel>? backlogItems,
  }) {
    return BacklogGroupModel(
      titleId: titleId ?? this.titleId,
      title: title ?? this.title,
      itemCount: itemCount ?? this.itemCount,
      todoCount: todoCount ?? this.todoCount,
      inProgressCount: inProgressCount ?? this.inProgressCount,
      reviewCount: reviewCount ?? this.reviewCount,
      doneCount: doneCount ?? this.doneCount,
      isBacklog: isBacklog ?? this.isBacklog,
      backlogItems: backlogItems ?? this.backlogItems,
    );
  }
}

class BacklogitemModel {
  String? id;
  String? title;
  String? description;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? assignedTo;
  String? projectId;
  String? groupId;
  num? storyPoints;
  BacklogitemModel({
    this.id,
    this.title,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.assignedTo,
    this.projectId,
    this.groupId,
    this.storyPoints,
  });
  //copyWith method
  BacklogitemModel copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? assignedTo,
    String? projectId,
    String? groupId,
    num? storyPoints,
  }) {
    return BacklogitemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedTo: assignedTo ?? this.assignedTo,
      projectId: projectId ?? this.projectId,
      groupId: groupId ?? this.groupId,
      storyPoints: storyPoints ?? this.storyPoints,
    );
  }
}
