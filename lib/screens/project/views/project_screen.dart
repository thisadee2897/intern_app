import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/project_controller.dart';

class ProjectScreen extends ConsumerStatefulWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends ConsumerState<ProjectScreen> {
  String selectedWorkspaceId = '1';
  Map<String, bool> categoryExpansionState = {};

  @override
  Widget build(BuildContext context) {
    final categoryAsyncValue = ref.watch(categoryListProvider(selectedWorkspaceId));
    final allProjectsAsyncValue = ref.watch(projectListByCategoryProvider('0'));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 168, 208, 240),
        title: const Text('Project Screen'),
        centerTitle: false,
      ),
      body: categoryAsyncValue.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('ไม่พบหมวดหมู่โปรเจค'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// All Categories Section
              ExpansionTile(
                title: const Text(
                  'โปรเจคทั้งหมด (All Categories)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                initiallyExpanded: categoryExpansionState['0'] ?? false,
                onExpansionChanged: (expanded) {
                  setState(() {
                    categoryExpansionState['0'] = expanded;
                  });
                },
                children: [
                  allProjectsAsyncValue.when(
                    data: (projects) {
                      if (projects.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('ไม่มีโปรเจคในหมวดหมู่นี้'),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 4 / 3,
                        ),
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return _buildProjectCard(project);
                        },
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('โหลดโปรเจคล้มเหลว: $error'),
                    ),
                  ),
                ],
              ),

              /// ✅ Category Sections
              ...categories.map((category) {
                final categoryId = category.id ?? '0';
                final categoryName = category.name ?? '-';
                final isExpanded = categoryExpansionState[categoryId] ?? false;
                final projectAsyncValue = ref.watch(projectListByCategoryProvider(categoryId));

                return ExpansionTile(
                  backgroundColor: const Color.fromARGB(119, 204, 233, 247),
                  title: Text(
                    '$categoryName ($categoryId)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  initiallyExpanded: isExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      categoryExpansionState[categoryId] = expanded;
                    });
                  },
                  children: [
                    projectAsyncValue.when(
                      data: (projects) {
                        if (projects.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('ไม่มีโปรเจคในหมวดหมู่นี้'),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 4 / 3,
                          ),
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            return _buildProjectCard(project);
                          },
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, _) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('โหลดโปรเจคล้มเหลว: $error'),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('เกิดข้อผิดพลาด: $error')),
      ),
    );
  }

  /// ✅ Extracted reusable Card Widget
  Widget _buildProjectCard(dynamic project) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: เปิดรายละเอียดโปรเจค
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image, size: 48), // หรือใส่ Image.network(project.imageUrl ?? '')
                ),
              ),
              const SizedBox(height: 8),
              Text(
                project.name ?? '-',
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${project.id}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
