import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/config/routes/route_config.dart';
import 'package:project/screens/project/project_datail/providers/controllers/project_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';


// 🎨 พาเลตสีจาก Dashboard
const backgroundColor = Color(0xFFF5F7FB);     // ฟ้าอ่อน
const cardColor = Colors.white;               // กล่องสีขาว
const shadowColor = Color(0xFFE0E6F1);         // เงานวล
const primaryTextColor = Color(0xFF1A237E);    // น้ำเงินเข้ม
const accentColor = Color(0xFF3D5AFE);         // น้ำเงินสด
const progressBackground = Color(0xFFE0E6F1);  // สีหลัง progress bar

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectController = ref.read(projectControllerProvider);
    final categoryController = ref.read(categoryControllerProvider);
    return FutureBuilder(
      future: Future.wait([
        projectController.getProjects(),
        categoryController.getCategories(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: \\${snapshot.error}')),
          );
        } else {
          final projects = snapshot.data![0] as List<ProjectHDModel>;
          final categories = snapshot.data![1]; // List<CategoryModel>
          final categorizedProjects = <String, List<ProjectHDModel>>{
            'โปรเจคด้านแอปพลิเคชันมือถือ (Mobile App Projects)':
                projects.where((p) => p.categoryId == 'mobile').toList(),
            'โปรเจคด้านการพัฒนาเว็บ (Web Development Projects)':
                projects.where((p) => p.categoryId == 'web').toList(),
            'โปรเจคด้านปัญญาประดิษฐ์ (AI Projects)':
                projects.where((p) => p.categoryId == 'ai').toList(),
            'โปรเจคด้านเกม (Game Development Projects)':
                projects.where((p) => p.categoryId == 'game').toList(),
          };

          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 219, 239, 243),
            appBar: AppBar(
              title: const Text('Projects'),
              shape: const Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            body: Stack(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            'รายการโครงการที่พัฒนาทั้งหมด',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                        ...categorizedProjects.entries.map((entry) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: shadowColor.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ExpansionTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                                title: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: primaryTextColor,
                                  ),
                                ),
                                childrenPadding: const EdgeInsets.only(bottom: 12),
                                children: entry.value.isEmpty
                                    ? [
                                        const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text('ไม่มีโปรเจคในหมวดหมู่นี้'),
                                        ),
                                      ]
                                    : entry.value.map((project) {
                                        final progress = project.progress ?? 0.0;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: backgroundColor,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: ListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                              leading: const Icon(Icons.folder_open_rounded, color: accentColor),
                                              title: Text(
                                                project.name ?? 'ไม่มีชื่อโปรเจกต์',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 80,
                                                        height: 6,
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color: progressBackground,
                                                                borderRadius: BorderRadius.circular(4),
                                                              ),
                                                            ),
                                                            FractionallySizedBox(
                                                              widthFactor: progress,
                                                              alignment: Alignment.centerLeft,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: accentColor,
                                                                  borderRadius: BorderRadius.circular(4),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text('${(progress * 100).toStringAsFixed(0)}%'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                              onTap: () => Navigator.of(context).pushNamed(Routes.projectDetail),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
