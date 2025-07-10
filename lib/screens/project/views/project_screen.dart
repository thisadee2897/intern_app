import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/config/routes/route_config.dart';
import 'package:project/config/routes/route_helper.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/screens/project/category/views/category_add_screen.dart';
import 'package:project/screens/project/category/views/category_edit_screen.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/project_controller.dart';
import 'package:project/screens/project/project_update/view/project_edit_screen.dart';
import 'package:project/screens/project/project_update/view/project_update_screen.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'package:project/utils/extension/async_value_sliver_extension.dart';

class ProjectScreen extends BaseStatefulWidget {
  const ProjectScreen({super.key});
  @override
  BaseState<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends BaseState<ProjectScreen> {
  String selectedWorkspaceId = '1';
  Map<String, bool> categoryExpansionState = {};
  String _hoveredCategoryId = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryListProvider(selectedWorkspaceId));
    });
    super.initState();
  }

  onRefresh() async {
    ref.invalidate(categoryListProvider(selectedWorkspaceId));
    ref.invalidate(projectListByCategoryProvider(''));
  }

  Widget _buildBody(BuildContext context, SizingInformation sizingInformation) {
    final categoryAsyncValue = ref.watch(categoryListProvider(selectedWorkspaceId));
    EdgeInsets padding = const EdgeInsets.all(16);
    double topSpace = 40;
    if (sizingInformation.isMobile) {
      padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 4);
      topSpace = 16;
    } else if (sizingInformation.isTablet) {
      padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
      topSpace = 24;
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 242, 245),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 164, 253),
        title: const Text(
          'Projects',
          style: TextStyle(color: Color.fromARGB(255, 4, 4, 4), fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) async {
              if (value == 'refresh') {
                await onRefresh();
              } else if (value == 'add') {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CategoryAddScreen(workspaceId: selectedWorkspaceId)),
                );
                if (result == true) {
                  ref.invalidate(categoryListProvider(selectedWorkspaceId));
                }
              } else if (value == 'edit') {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CategoryEditScreen(workspaceId: selectedWorkspaceId)),
                );
                if (result == true) {
                  ref.invalidate(categoryListProvider(selectedWorkspaceId));
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'refresh',
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('รีเฟรชข้อมูล'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'add',
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('เพิ่มหมวดหมู่'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('แก้ไขหมวดหมู่'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: RefreshIndicator(
          onRefresh: () async {
            await onRefresh();
          },
          child: categoryAsyncValue.appWhen(
            dataBuilder: (categories) {
              if (categories.isEmpty) return const Center(child: Text('ไม่พบหมวดหมู่โปรเจค'));
              return ListView(
                padding: padding,
                children: [
                  SizedBox(height: topSpace),
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
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context, {
    required String categoryName,
    required String categoryId,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
    required AsyncValue<List<ProjectHDModel>> projectsAsync,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 247, 247, 248), width: 2),
        boxShadow: [BoxShadow(color: const Color.fromARGB(171, 232, 232, 233).withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        initiallyExpanded: isExpanded,
        onExpansionChanged: onExpansionChanged,
        title: Row(
          children: [
            const Icon(Icons.folder, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$categoryName (${projectsAsync.value?.length ?? 0})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            MouseRegion(
              onEnter: (_) => setState(() => _hoveredCategoryId = categoryId),
              onExit: (_) => setState(() => _hoveredCategoryId = ''),
              child: AnimatedScale(
                scale: _hoveredCategoryId == categoryId ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProjectUpdateScreen(project: {"project_category_id": categoryId})),
                    );
                    if (result == true) {
                      ref.invalidate(projectListByCategoryProvider(categoryId));
                      ref.invalidate(categoryListProvider(selectedWorkspaceId));
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                  label: const Text("Add", style: TextStyle(fontSize: 12, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: const Size(10, 32),
                  ),
                ),
              ),
            ),
          ],
        ),
        children: [
          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) return const Padding(padding: EdgeInsets.all(8.0), child: Text('ไม่มีโปรเจคในหมวดหมู่นี้'));
              return Column(children: projects.map((project) => _buildProjectItem(project)).toList());
            },
            loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
            error: (error, _) => Padding(padding: const EdgeInsets.all(16), child: Text('โหลดโปรเจคล้มเหลว: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectItem(ProjectHDModel project) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('ID: ${project.id}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('แก้ไข', style: TextStyle(fontSize: 12)),
            onPressed: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectEditScreen(project: project)));
              if (result == true) {
                ref.invalidate(projectListByCategoryProvider(project.categoryId ?? ''));
                ref.invalidate(categoryListProvider(selectedWorkspaceId));
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD2CCE5),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(10, 32),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('เปิด', style: TextStyle(fontSize: 12)),
            onPressed: () {
              ref.read(selectProjectIdProvider.notifier).state = project.id;
              ref.goSubPath(Routes.projectDetail);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD2CCE5),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(10, 32),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return _buildBody(context, sizingInformation);
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return _buildBody(context, sizingInformation);
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return _buildBody(context, sizingInformation);
  }
}
