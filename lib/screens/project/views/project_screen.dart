// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:project/components/export.dart';
import 'package:project/config/routes/route_config.dart';
import 'package:project/config/routes/route_helper.dart';
import 'package:project/models/category_model.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/project_controller.dart';
import 'package:project/screens/project/project_update/view/project_edit_screen.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'package:project/utils/extension/async_value_sliver_extension.dart';
import 'package:project/screens/project/category/providers/controllers/delete_project_category_controller.dart';

import 'widgets/category_dialog.dart';
import 'widgets/insert_or_update_project.dart';

class ProjectScreen extends BaseStatefulWidget {
  final WorkspaceModel workspace;
  const ProjectScreen(this.workspace, {super.key});

  @override
  BaseState<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends BaseState<ProjectScreen> with TickerProviderStateMixin {
  // String widget.workspaceId = '1';
  Map<String, bool> categoryExpansionState = {};
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<ProjectHDModel> _allProjects = [];
  List<ProjectHDModel> _filteredProjects = [];
  OverlayEntry? _overlayEntry;

  // Animation Controllers
  late AnimationController _fabAnimationController;
  late AnimationController _searchAnimationController;
  late AnimationController _categoryAnimationController;

  late Animation<double> _fabScaleAnimation;
  late Animation<double> _searchFadeAnimation;
  late Animation<Offset> _searchSlideAnimation;
  late Animation<double> _categoryStaggerAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controllers
    _fabAnimationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _searchAnimationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _categoryAnimationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    // Initialize Animations
    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fabAnimationController, curve: Curves.elasticOut));

    _searchFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _searchAnimationController, curve: Curves.easeInOut));

    _searchSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _searchAnimationController, curve: Curves.easeOutBack));

    _categoryStaggerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _categoryAnimationController, curve: Curves.easeOutQuart));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryListProvider(widget.workspace.id!));
      _fabAnimationController.forward();
      _searchAnimationController.forward();
      _categoryAnimationController.forward();
    });

    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _searchAnimationController.dispose();
    _categoryAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _filteredProjects =
          _allProjects.where((project) {
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
    _overlayEntry = OverlayEntry(builder: (context) => _buildSearchSuggestions());
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
      top: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _searchSlideAnimation,
        child: FadeTransition(
          opacity: _searchFadeAnimation,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            shadowColor: Colors.black26,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _filteredProjects.length,
                  itemBuilder: (context, index) {
                    final project = _filteredProjects[index];
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 200 + (index * 50)),
                      curve: Curves.easeOutBack,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: index == _filteredProjects.length - 1 ? Colors.transparent : Colors.grey.shade100)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.folder_outlined, color: Colors.blueAccent, size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(project.name ?? '-', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
                                    const SizedBox(height: 4),
                                    Text('ID: ${project.id}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
                                child: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // สร้าง Dialog สวยๆ สำหรับเพิ่ม Category
  Future<void> _showAddCategoryDialog(CategoryModel item) async {
    await showModal(
      context: context,
      configuration: const FadeScaleTransitionConfiguration(
        barrierDismissible: true,
        transitionDuration: Duration(milliseconds: 400),
        reverseTransitionDuration: Duration(milliseconds: 300),
      ),
      builder: (context) => AddCategoryDialog(category: item, workspaceId: widget.workspace.id!),
    ).then((result) {
      if (result == true) {
        ref.invalidate(categoryListProvider(widget.workspace.id!));
        _loadAllProjects();
      }
    });
  }

  onRefresh() async {
    ref.invalidate(categoryListProvider(widget.workspace.id!));
    ref.invalidate(projectListByCategoryProvider(''));
    await _loadAllProjects();
  }

  Future<void> _loadAllProjects() async {
    final categoryAsyncValue = ref.read(categoryListProvider(widget.workspace.id!));
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
    return SlideTransition(
      position: _searchSlideAnimation,
      child: FadeTransition(
        opacity: _searchFadeAnimation,
        child: Container(
          width: 220,
          height: 44,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'ค้นหาโปรเจค...',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w400),
              prefixIcon: Container(padding: const EdgeInsets.all(12), child: Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 20)),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: Icon(Icons.clear_rounded, color: Colors.grey.shade500, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _hideOverlay();
                        },
                      )
                      : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SizingInformation sizingInformation) {
    final categoryAsyncValue = ref.watch(categoryListProvider(widget.workspace.id!));
    EdgeInsets padding = const EdgeInsets.all(16);
    if (sizingInformation.isMobile) {
      padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 4);
    } else if (sizingInformation.isTablet) {
      padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.white,
        title: Text(widget.workspace.name ?? '', style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w700)),
        centerTitle: false,
        actions: [
          _buildSearchField(),
          const SizedBox(width: 12),
          ScaleTransition(
            scale: _fabScaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                boxShadow: [BoxShadow(color: const Color(0xFF667eea).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _showAddCategoryDialog(CategoryModel(id: '0')),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded, size: 20, color: Colors.white),
                        const SizedBox(width: 8),
                        const Text('New Category', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.grey.shade50, Colors.white]),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await onRefresh();
          },
          color: const Color(0xFF667eea),
          backgroundColor: Colors.white,
          child: categoryAsyncValue.appWhen(
            dataBuilder: (categories) {
              // กรณีมีข้อมูล → โหลด project ทุกหมวดหมู่
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadAllProjects();
              });

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top + 20)),
                  SliverPadding(
                    padding: padding,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final category = categories[index];
                        final categoryId = category.id ?? '0';
                        final categoryName = category.name ?? '-';
                        final isExpanded = categoryExpansionState[categoryId] ?? false;
                        final projectAsyncValue = ref.watch(projectListByCategoryProvider(categoryId));

                        return FadeTransition(
                          opacity: _categoryStaggerAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0.0, 0.5 + (index * 0.1)),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(parent: _categoryAnimationController, curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutBack))),
                            child: _buildCategoryTile(
                              context,
                              categoryName: categoryName,
                              categoryId: categoryId,
                              isExpanded: isExpanded,
                              onExpansionChanged: (expanded) {
                                setState(() => categoryExpansionState[categoryId] = expanded);
                              },
                              projectsAsync: projectAsyncValue,
                              category: category,
                              index: index,
                            ),
                          ),
                        );
                      }, childCount: categories.length),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
    required CategoryModel category,
    required int index,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8), spreadRadius: -4),
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
        ],
        border: Border.all(color: isExpanded ? const Color(0xFF667eea).withOpacity(0.3) : Colors.grey.shade200, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 16),
          iconColor: const Color(0xFF667eea),
          collapsedIconColor: Colors.grey.shade600,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [const Color(0xFF667eea).withOpacity(0.1), const Color(0xFF764ba2).withOpacity(0.1)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.folder_rounded, color: const Color(0xFF667eea), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(categoryName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(
                      '${projectsAsync.value?.length ?? 0} projects',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              _buildCategoryActions(category, categoryId, categoryName),
            ],
          ),
          children: [
            projectsAsync.when(
              data: (projects) {
                if (projects.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.folder_open_rounded, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text('ไม่มีโปรเจคในหมวดหมู่นี้', style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: projects.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, projectIndex) {
                    final project = projects[projectIndex];
                    return _buildProjectItem(project, projectIndex);
                  },
                );
              },
              loading:
                  () => Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(32),
                    child: const Center(child: CircularProgressIndicator(color: Color(0xFF667eea))),
                  ),
              error:
                  (error, _) => Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 32),
                          const SizedBox(height: 8),
                          Text('โหลดโปรเจคล้มเหลว: $error', style: TextStyle(color: Colors.red.shade700, fontSize: 14), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryActions(CategoryModel category, String categoryId, String categoryName) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: const Color(0xFF667eea).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                await showModal(
                  context: context,
                  configuration: const FadeScaleTransitionConfiguration(),
                  builder: (context) => InsertOrUpdateProjectHD(category: category),
                );
                ref.invalidate(projectListByCategoryProvider(categoryId));
                ref.invalidate(categoryListProvider(widget.workspace.id!));
                await _loadAllProjects();
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    const Text("Add", style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
          child: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.grey.shade600, size: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 8,
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    onTap: () => _showAddCategoryDialog(category),
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, color: Colors.blue.shade600, size: 20),
                        const SizedBox(width: 12),
                        const Text('แก้ไขหมวดหมู่', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () => _showDeleteCategoryDialog(categoryId),
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, color: Colors.red.shade600, size: 20),
                        const SizedBox(width: 12),
                        Text('ลบหมวดหมู่', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteCategoryDialog(String categoryId) async {
    await showModal(
      context: context,
      configuration: const FadeScaleTransitionConfiguration(),
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(children: [Icon(Icons.warning_rounded, color: Colors.orange.shade600), const SizedBox(width: 12), const Text('ยืนยันการลบ')]),
            content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบหมวดหมู่นี้? การกระทำนี้ไม่สามารถย้อนกลับได้', style: TextStyle(fontSize: 14)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text('ยกเลิก', style: TextStyle(color: Colors.grey.shade600))),
              Container(
                decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(8)),
                child: TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('ลบ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          await ref.read(deleteProjectCategoryControllerProvider.notifier).deleteCategory({'project_category_id': categoryId});
          ref.invalidate(categoryListProvider(widget.workspace.id!));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text('ลบหมวดหมู่สำเร็จ')]),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            String errorMessage = '';
            if (e.runtimeType == DioException) {
              DioException err = e as DioException;
              errorMessage = err.message ?? 'เกิดข้อผิดพลาดในการเชื่อมต่อ';
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [const Icon(Icons.error, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text('เกิดข้อผิดพลาด: $errorMessage'))],
                ),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            );
          }
        }
      }
    });
  }

  Widget _buildProjectItem(ProjectHDModel project, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200 + (index * 50)),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ref.read(selectProjectIdProvider.notifier).state = project.id;
          ref.goSubPath(Routes.projectDetail);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [const Color(0xFF667eea).withOpacity(0.1), const Color(0xFF764ba2).withOpacity(0.1)]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.folder_rounded, color: const Color(0xFF667eea), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name ?? '-', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text('ID: ${project.id}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildProjectActions(project),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectActions(ProjectHDModel project) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectEditScreen(project: project)));
                if (result == true) {
                  ref.invalidate(projectListByCategoryProvider(project.categoryId ?? ''));
                  ref.invalidate(categoryListProvider(widget.workspace.id!));
                  await _loadAllProjects();
                  setState(() {});
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_rounded, size: 16, color: Colors.grey.shade700),
                    const SizedBox(width: 6),
                    Text('แก้ไข', style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: const Color(0xFF667eea).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                ref.read(selectProjectIdProvider.notifier).state = project.id;
                ref.goSubPath(Routes.projectDetail);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.open_in_new_rounded, size: 16, color: Colors.white),
                    SizedBox(width: 6),
                    Text('เปิด', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
