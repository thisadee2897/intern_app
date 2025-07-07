import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/project_controller.dart';

class ProjectScreen extends BaseStatefulWidget {
  const ProjectScreen({super.key});

  @override
  BaseState<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends BaseState<ProjectScreen> {
  String selectedWorkspaceId = '1';
  Map<String, bool> categoryExpansionState = {};

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    final categoryAsyncValue = ref.watch(categoryListProvider(selectedWorkspaceId));
    final allProjectsAsyncValue = ref.watch(projectListByCategoryProvider('0'));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Projects', style: TextStyle(color: Color.fromARGB(255, 94, 92, 92), fontWeight: FontWeight.bold)),

        centerTitle: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.pinimg.com/736x/8e/a5/3a/8ea53ad02e66cc60ec4240478ed4c9cb.jpg'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: categoryAsyncValue.when(
          data: (categories) {
            if (categories.isEmpty) {
              return const Center(child: Text('ไม่พบหมวดหมู่โปรเจค'));
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 40), // ระยะห่าง
                /// All Categories Section
                _buildCategoryTile(
                  context,
                  title: 'โปรเจคทั้งหมด (All Categories)',
                  icon: Icons.folder_special,
                  isExpanded: categoryExpansionState['0'] ?? false,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      categoryExpansionState['0'] = expanded;
                    });
                  },
                  projectsAsync: allProjectsAsyncValue,
                ),

                /// Category Sections
                ...categories.map((category) {
                  final categoryId = category.id ?? '0';
                  final categoryName = category.name ?? '-';
                  final isExpanded = categoryExpansionState[categoryId] ?? false;
                  final projectAsyncValue = ref.watch(projectListByCategoryProvider(categoryId));

                  return _buildCategoryTile(
                    context,
                    title: '$categoryName ($categoryId)',
                    icon: Icons.folder,
                    isExpanded: isExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        categoryExpansionState[categoryId] = expanded;
                      });
                    },
                    projectsAsync: projectAsyncValue,
                  );
                }).toList(),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('เกิดข้อผิดพลาด: $error')),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
    required AsyncValue<List<dynamic>> projectsAsync,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(59, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(107, 68, 137, 255), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(158, 68, 137, 255).withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.blueAccent),
        backgroundColor: const Color.fromARGB(119, 204, 233, 247),
        collapsedBackgroundColor: const Color.fromARGB(62, 255, 255, 255),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: isExpanded,
        onExpansionChanged: onExpansionChanged,
        children: [
          projectsAsync.when(
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
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1 / 1,
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
    );
  }

  /// Card Widget สำหรับโปรเจคแต่ละตัว
  Widget _buildProjectCard(dynamic project) {
    return SizedBox(
      height: 180,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: const Color.fromARGB(248, 230, 232, 232),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Color.fromARGB(246, 100, 99, 99),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.name ?? '-',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text('ID: ${project.id}', style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return const SizedBox(); // ยังไม่ทำ
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return const SizedBox(); // ยังไม่ทำ
  }
}
