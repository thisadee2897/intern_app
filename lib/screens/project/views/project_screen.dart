import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/project_controller.dart';
import 'package:project/screens/project/project_update/view/project_update_screen.dart';
import 'package:project/utils/extension/async_value_sliver_extension.dart';

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
        child: categoryAsyncValue.appWhen(
          dataBuilder: (categories) {
            if (categories.isEmpty) return const Center(child: Text('ไม่พบหมวดหมู่โปรเจค'));
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 40),
                ...categories.map((category) {
                  final categoryId = category.id ?? '0';
                  final categoryName = category.name ?? '-';
                  final isExpanded = categoryExpansionState[categoryId] ?? false;
                  final projectAsyncValue = ref.watch(projectListByCategoryProvider(categoryId));
                  return _buildCategoryTile(
                    context,
                    categoryName: categoryName,
                    categoryId: categoryId,
                    isExpanded: isExpanded,
                    onExpansionChanged: (expanded) => setState(() => categoryExpansionState[categoryId] = expanded),
                    projectsAsync: projectAsyncValue,
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context, {
    required String categoryName,
    required String categoryId,
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
        boxShadow: [BoxShadow(color: const Color.fromARGB(158, 68, 137, 255).withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.folder, color: Colors.blueAccent),
        backgroundColor: const Color.fromARGB(119, 204, 233, 247),
        collapsedBackgroundColor: const Color.fromARGB(62, 255, 255, 255),
        initiallyExpanded: isExpanded,
        onExpansionChanged: onExpansionChanged,
        title: Row(
          children: [
            Expanded(child: Text('$categoryName (${projectsAsync.value?.length ?? 0})', style: const TextStyle(fontWeight: FontWeight.bold))),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProjectUpdateScreen(project: {"categoryId": categoryId})),
                );
                if (result == true) {
                  ref.invalidate(projectListByCategoryProvider(categoryId));
                  ref.invalidate(categoryListProvider(selectedWorkspaceId)); // สำคัญ: ดึง category ใหม่ด้วยถ้ามีการเพิ่ม
                  setState(() {}); // รีเฟรชหน้าจอ
                }
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text("Update", style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: const Size(10, 32),
              ),
            ),
          ],
        ),
        children: [
          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) return const Padding(padding: EdgeInsets.all(8.0), child: Text('ไม่มีโปรเจคในหมวดหมู่นี้'));
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1 / 1.3,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) => _buildProjectCard(projects[index]),
              );
            },
            loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
            error: (error, _) => Padding(padding: const EdgeInsets.all(16), child: Text('โหลดโปรเจคล้มเหลว: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(dynamic project) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(248, 230, 232, 232),
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported, size: 60, color: Color.fromARGB(246, 100, 99, 99)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text("ID: ${project.id}", style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) => const SizedBox();

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) => const SizedBox();
}
