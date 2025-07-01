import 'package:flutter/material.dart';

class HomeDesktopUI extends StatelessWidget {
  const HomeDesktopUI({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> boards = [
      {
        'image':
            'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'members': 1,
      },
      {
        'image':
            'https://images.unsplash.com/photo-1519389950473-47ba0277781c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'members': 1,
      },
      {
        'image':
            'https://images.unsplash.com/photo-1516321497487-e288fb19713f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'members': 1,
      },
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 35, 37),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WORKSPACE',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 20, color: const Color.fromARGB(255, 240, 239, 239),                  ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.5,
                ),
                itemCount: boards.length,
                itemBuilder: (context, index) {
                  final board = boards[index];
                  final members = board['members'] as int;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(5), // เดิม 12
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background image
                        Image.network(
                          board['image']!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(child: Icon(Icons.error)),
                            );
                          },
                        ),
                        // Dark overlay
                        Container(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        // Template label top-left
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5), // เดิม12
                            ),
                            child: const Text(
                              'Template',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                        // Centered 'User'
                        const Center(
                          child: Text(
                            'User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Members icon + count bottom-right
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.group, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  members.toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
