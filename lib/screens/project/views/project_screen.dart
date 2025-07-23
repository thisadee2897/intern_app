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
import 'package:project/screens/project/category/providers/controllers/delete_project_category_controller.dart';

class ProjectScreen extends BaseStatefulWidget {
  const ProjectScreen({super.key});
  
  @override
  BaseState<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends BaseState<ProjectScreen> {
  String selectedWorkspaceId = '1';
  Map<String, bool> categoryExpansionState = {};
  String _hoveredCategoryId = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<ProjectHDModel> _allProjects = [];
  List<ProjectHDModel> _filteredProjects = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryListProvider(selectedWorkspaceId));
    });
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _filteredProjects = _allProjects.where((project) {
        final projectName = project.name?.toLowerCase() ?? '';
        return projectName.contains(query.toLowerCase());
      }).toList();
      if (_filteredProjects.isNotEmpty) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    } else {
      _hideOverlay();
    }
  }

  void _onSearchFocusChanged() {
    if (!_searchFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!_searchFocusNode.hasFocus) {
          _hideOverlay();
        }
      });
    }
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildSearchSuggestions(),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildSearchSuggestions() {
    return Positioned(
      top: kToolbarHeight + MediaQuery.of(context).padding.top,
      left: 16,
      right: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _filteredProjects.length,
            itemBuilder: (context, index) {
              final project = _filteredProjects[index];
              return InkWell(
                onTap: () {
                  _searchController.clear();
                  _hideOverlay();
                  _searchFocusNode.unfocus();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    ref.read(selectProjectIdProvider.notifier).state = project.id;
                    ref.goSubPath(Routes.projectDetail);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: index == _filteredProjects.length - 1 
                            ? Colors.transparent 
                            : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.folder, color: Colors.blueAccent, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.name ?? '-',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ID: ${project.id}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  onRefresh() async {
    ref.invalidate(categoryListProvider(selectedWorkspaceId));
    ref.invalidate(projectListByCategoryProvider(''));
    await _loadAllProjects();
  }

  Future<void> _loadAllProjects() async {
    final categoryAsyncValue = ref.read(categoryListProvider(selectedWorkspaceId));
    final categories = categoryAsyncValue.value ?? [];
    List<ProjectHDModel> allProjects = [];
    for (var category in categories) {
      final projectsAsync = ref.read(projectListByCategoryProvider(category.id ?? ''));
      final projects = projectsAsync.value ?? [];
      allProjects.addAll(projects);
    }
    setState(() {
      _allProjects = allProjects;
    });
  }

  Widget _buildSearchField() {
    return Container(
      width: 250,
      height: 40,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: 'ค้นหาโปรเจค...',
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _hideOverlay();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: const TextStyle(fontSize: 14),
        onSubmitted: (value) {
          if (_filteredProjects.isNotEmpty) {
            final firstProject = _filteredProjects.first;
            _searchController.clear();
            _hideOverlay();
            _searchFocusNode.unfocus();
            ref.read(selectProjectIdProvider.notifier).state = firstProject.id;
            ref.goSubPath(Routes.projectDetail);
          }
        },
      ),
    );
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'Projects',
          style: TextStyle(color: Color.fromARGB(255, 4, 4, 4), fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          _buildSearchField(),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CategoryAddScreen(workspaceId: selectedWorkspaceId)),
              );
              if (result == true) {
                ref.invalidate(categoryListProvider(selectedWorkspaceId));
                await _loadAllProjects();
              }
            },
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadAllProjects();
              });
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 247, 247, 248), width: 2),
        boxShadow: [
          BoxShadow(color: const Color.fromARGB(171, 232, 232, 233).withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 3))
        ],
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
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProjectUpdateScreen(project: {"project_category_id": categoryId})),
                );
                if (result == true) {
                  ref.invalidate(projectListByCategoryProvider(categoryId));
                  ref.invalidate(categoryListProvider(selectedWorkspaceId));
                  await _loadAllProjects();
                  setState(() {});
                }
              },
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: const Text("Add", style: TextStyle(fontSize: 12, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: const Size(10, 32),
              ),
            ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryEditScreen(
                        workspaceId: selectedWorkspaceId,
                        categoryId: categoryId,
                        categoryName: categoryName,
                      ),
                    ),
                  );
                  if (result == true) {
                    ref.invalidate(categoryListProvider(selectedWorkspaceId));
                    await _loadAllProjects();
                  }
                } else if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('ยืนยันการลบ'),
                      content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบหมวดหมู่นี้?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('ยกเลิก'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('ลบ'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      final body = {"workspace_id": selectedWorkspaceId, "id": categoryId};
                      await ref.read(deleteProjectCategoryControllerProvider.notifier).deleteCategory(body);

                      ref.invalidate(categoryListProvider(selectedWorkspaceId));
                      await _loadAllProjects();

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ลบหมวดหมู่สำเร็จ')),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('ลบหมวดหมู่ล้มเหลว: $e')),
                        );
                      }
                    }
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('แก้ไขหมวดหมู่'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('ลบหมวดหมู่', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return const Padding( padding: EdgeInsets.all(8.0),child: Text('ไม่มีโปรเจคในหมวดหมู่นี้'),
                );
              }
              return Column(children: projects.map((project) => _buildProjectItem(project)).toList(),);},
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
                await _loadAllProjects();
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
