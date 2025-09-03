// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:project/components/export.dart';
import 'package:project/models/category_model.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/models/user_login_model.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_datail/views/project_detail_screen.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'package:project/utils/extension/async_value_sliver_extension.dart';
import 'package:project/screens/project/category/providers/controllers/delete_project_category_controller.dart';
import 'package:project/utils/extension/context_extension.dart';
import 'package:project/utils/extension/custom_snackbar.dart';
import 'package:project/utils/services/local_storage_service.dart';

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
  // List<ProjectHDModel> _allProjects = [];
  OverlayEntry? _overlayEntry;

  // Animation Controllers
  late AnimationController _fabAnimationController;
  late AnimationController _searchAnimationController;
  late AnimationController _categoryAnimationController;

  late Animation<double> _fabScaleAnimation;
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

    _categoryStaggerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _categoryAnimationController, curve: Curves.easeOutQuart));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(categoryListProvider(widget.workspace.id!));
      _fabAnimationController.forward();
      _searchAnimationController.forward();
      _categoryAnimationController.forward();
      onRefresh();
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
    // final query = _searchController.text.trim();
    // if (query.isNotEmpty) {
    //   _filteredProjects =
    //       _allProjects.where((project) {
    //         final projectName = project.name?.toLowerCase() ?? '';
    //         return projectName.contains(query.toLowerCase());
    //       }).toList();
    //   if (_filteredProjects.isNotEmpty) {
    //     _showOverlay();
    //   } else {
    //     _hideOverlay();
    //   }
    // } else {
    //   _hideOverlay();
    // }
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

  void _hideOverlay() {
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
        ref.read(categoryProvider.notifier).getCategory(widget.workspace.id!);
        CustomSnackbar.showSnackBar(
          context: context,
          title: "สำเร็จ",
          message: "บันทึกหมวดหมู่สำเร็จ",
          contentType: ContentType.success,
          color: Colors.green, // ใส่ไปเพราะ method require
        );
      }
    });
  }

  onRefresh() async {
    await ref.read(categoryProvider.notifier).getCategory(widget.workspace.id!);
  }

  Widget _buildBody(BuildContext context, SizingInformation sizingInformation) {
    // final categoryAsyncValue = ref.watch(categoryListProvider(widget.workspace.id!));
    final stateCategory = ref.watch(categoryProvider);
    EdgeInsets padding = const EdgeInsets.all(16);
    if (sizingInformation.isMobile) {
      padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 4);
    } else if (sizingInformation.isTablet) {
      padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.white,
        title: Text(
          widget.workspace.name ?? '',
          style: const TextStyle(
            // color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        actions: [
          // _buildSearchField(),
          const SizedBox(width: 12),
          OutlinedButton.icon(onPressed: () => _showAddCategoryDialog(CategoryModel(id: '0')), label: const Text('สร้างหมวดหมู่ใหม่')),
          const SizedBox(width: 16),
        ],
      ),
      body: stateCategory.appWhen(
        dataBuilder: (data) {
          return Container(
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [Colors.grey.shade50, Colors.white],
              // ),
            ),
            child: RefreshIndicator(
              onRefresh: () async {
                await onRefresh();
              },
              color: const Color(0xFF667eea),
              backgroundColor: Colors.white,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top + 20)),
                  SliverPadding(
                    padding: padding,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final category = data[index];
                        final categoryId = category.id ?? '0';
                        final isExpanded = categoryExpansionState[categoryId] ?? false;
                        return FadeTransition(
                          opacity: _categoryStaggerAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0.0, 0.5 + (index * 0.1)),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(parent: _categoryAnimationController, curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutBack))),
                            child: _buildCategoryTile(
                              context,
                              isExpanded: isExpanded,
                              onExpansionChanged: (expanded) {
                                setState(() => categoryExpansionState[categoryId] = expanded);
                              },
                              category: category,
                              index: index,
                            ),
                          ),
                        );
                      }, childCount: data.length),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context, {
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
    required CategoryModel category,
    required int index,
  }) {
    return Container(
      padding: const EdgeInsets.all(1),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: context.containerBorder,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300 + (index * 100)),
        curve: Curves.easeOutBack,
        decoration: context.containerColor,
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
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [const Color(0xFF667eea).withOpacity(0.1), const Color(0xFF764ba2).withOpacity(0.1)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.folder_rounded, color: context.secondaryColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.name!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${category.projects.length} projects', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                _buildCategoryActions(category),
              ],
            ),
            children: [
              if (category.projects.isEmpty)
                Container(
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
                ),
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: category.projects.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, projectIndex) {
                  final project = category.projects[projectIndex];
                  return _buildProjectItem(project, projectIndex, category);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryActions(CategoryModel category) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            UserLoginModel userLogin = await ref.read(localStorageServiceProvider).getUserLogin();
            await showModal(
              context: context,
              configuration: const FadeScaleTransitionConfiguration(),
              builder: (context) => InsertOrUpdateProjectHD(category: category, projectHDModel: ProjectHDModel(id: '0', active: true, leader: userLogin.user)),
            );
          },
          label: const Text('เพิ่มโปรเจค'),
          icon: const Icon(Icons.add_rounded),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: Colors.white, size: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 8,
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  onTap: () => _showAddCategoryDialog(category),
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 12),
                      const Text('แก้ไขหมวดหมู่', style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: () => _showDeleteCategoryDialog(category.id!),
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_rounded, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 12),
                      Text('ลบหมวดหมู่', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
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
          await ref.read(categoryProvider.notifier).getCategory(widget.workspace.id!);

          if (context.mounted) {
            CustomSnackbar.showSnackBar(
              context: context,
              title: "สำเร็จ",
              message: "ลบหมวดหมู่สำเร็จ",
              contentType: ContentType.success,
              color: Colors.green, // ใส่ไปเพราะ method require
            );
          }
        } catch (e) {
          if (context.mounted) {
            String errorMessage = '';
            if (e.runtimeType == DioException) {
              DioException err = e as DioException;
              errorMessage = err.message ?? 'เกิดข้อผิดพลาดในการเชื่อมต่อ';
            }

            CustomSnackbar.showSnackBar(
              context: context,
              title: "ผิดพลาด",
              message: " $errorMessage",
              contentType: ContentType.failure,
              color: Colors.red, // ใส่ไปเพราะ method require
            );
          }
        }
      }
    });
  }

  Widget _buildProjectItem(ProjectHDModel project, int index, CategoryModel category) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        ref.read(selectProjectIdProvider.notifier).state = project.id;
        ref.read(projectSelectingProvider.notifier).state = project; // เก็บค่าโปรเจค ก่อนเปิดหน้ารายละเอียด
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProjectDetailScreen(projectId: project.id!)));
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              // padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [const Color(0xFF667eea).withOpacity(0.1), const Color(0xFF764ba2).withOpacity(0.1)]),
                borderRadius: BorderRadius.circular(8),
              ),
              //child: Icon(Icons.folder_rounded, color: const Color(0xFF667eea), size: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    (project.image != null && project.image!.isNotEmpty)
                        ? Image.network(
                          project.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.folder_rounded, color: const Color(0xFF667eea), size: 20),
                        )
                        : Icon(Icons.folder_rounded, color: const Color(0xFF667eea), size: 20),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.name ?? '-', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 4),
                  Text('ID: ${project.id}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildProjectActions(project, category),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectActions(ProjectHDModel project, CategoryModel category) {
    return TextButton(
      onPressed: () async {
        await showModal(
          context: context,
          configuration: const FadeScaleTransitionConfiguration(),
          builder: (context) => InsertOrUpdateProjectHD(category: category, projectHDModel: project),
        );
      },
      child: const Text('แก้ไข'),
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
