import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/config/routes/route_config.dart';
import 'package:project/config/routes/route_helper.dart';


final projectListProvider = FutureProvider<List<ProjectHDModel>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    ProjectHDModel(name: 'แอปฟิตเนส', categoryId: 'mobile', progress: 0.3),
    ProjectHDModel(name: 'แอปโซเชียลมีเดีย', categoryId: 'mobile', progress: 0.5),
    ProjectHDModel(name: 'เว็บไซต์ข่าวสาร', categoryId: 'web', progress: 0.7),
    ProjectHDModel(name: 'ระบบจัดการร้านค้า', categoryId: 'web', progress: 0.6),
    ProjectHDModel(name: 'เว็บแอปการศึกษา', categoryId: 'web', progress: 0.9),
    ProjectHDModel(name: 'ระบบแนะนำสินค้า', categoryId: 'ai', progress: 0.4),
    ProjectHDModel(name: 'แชทบอทอัจฉริยะ', categoryId: 'ai', progress: 0.8),
  ];
});

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        shape: const Border(
          bottom: BorderSide(color: Color.fromARGB(255, 227, 222, 222), width: 1.0),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: projectAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (projects) {
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

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    width: 150,
                    height: 85,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 203, 229, 245),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'รายการโครงการที่พัฒนาทั้งหมด',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 57, 59, 60)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...categorizedProjects.entries.map((entry) {
                    if (entry.value.isEmpty) {
                      return ExpansionTile(
                        title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text('ไม่มีโปรเจคในหมวดหมู่นี้'),
                          ),
                        ],
                      );
                    }
                    return ExpansionTile(
                      title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                      children: entry.value.map((project) {
                        final progress = project.progress ?? 0.0;
                        return ListTile(
                          visualDensity: VisualDensity.compact,
                          leading: const Icon(Icons.folder, color: Colors.lightBlue),
                          title: Text(project.name ?? 'ไม่มีชื่อโปรเจกต์'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${(progress * 100).toInt()}/100 tasks', style: const TextStyle(color: Colors.grey)),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.grey.shade300,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${(progress * 100).toStringAsFixed(0)}%'),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => ref.goSubPath(Routes.projectDetail),
                        );
                      }).toList(),
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
}
