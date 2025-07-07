import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DocumentationScreen extends StatelessWidget {
  const DocumentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 25),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: const [HeaderSection(), SizedBox(height: 45), DocCardGrid()]),
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 160),
      decoration: BoxDecoration(color: const Color.fromARGB(255, 234, 234, 234), borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: [
          const Text('6amMart Documentation', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 26, 45, 71))),
          const SizedBox(height: 30),
          Container(
            constraints: const BoxConstraints(maxWidth: 900),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 120, 120, 150), width: 0.3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 120, 120, 150), width: 0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> docCards = const [
  {
    'title': 'Introduction',
    'count': 1,
    'items': ['Overview'],
  },
  {
    'title': 'Configuration Summary',
    'count': 1,
    'items': ['Overview'],
  },
  {
    'title': 'Admin Application Configuration',
    'count': 7,
    'items': ['Prerequisite', 'Environment Configuration', 'Installation', 'Mandatory Setup', 'Customizations', '3rd Party Setup', 'Rental Module addon'],
  },
  {
    'title': 'Mobile Application & Web Configuration',
    'count': 9,
    'items': [
      'Prerequisites',
      'Environment Setup',
      'Mandatory Setups',
      'Customisation',
      'App Build & Release',
      'Web App',
      '3rd Party Setup (Only For User App)',
      'System Update',
      'Rental Module addon',
    ],
  },
  {
    'title': 'React Web App',
    'count': 7,
    'items': [
      'Prerequisite',
      'Environment Setup',
      'Mandatory setup (Admin panel)',
      'Mandatory Setup (Web)',
      'Customization Setup',
      'Site Build and Deploy',
      'Rental Module addon',
    ],
  },
  {
    'title': 'Version Update',
    'count': 2,
    'items': ['Mobile Application', 'Admin Panel'],
  },
  {
    'title': 'Common Issues',
    'count': 1,
    'items': ['TYPICAL ISSUES'],
  },
];

class DocCardGrid extends StatelessWidget {
  const DocCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: _getCrossAxisCount(context),
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 20.0,
      children:
          docCards.map((card) {
            return StaggeredGridTile.fit(
              crossAxisCellCount: 1,
              child: DocCard(title: card['title'] as String, count: card['count'] as int, items: List<String>.from(card['items'])),
            );
          }).toList(),
    );
  }

  // Helper method สำหรับกำหนดจำนวนคอลัมน์ตามขนาดหน้าจอ
  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 1; // มือถือ แสดง 1 คอลัมน์
    } else if (screenWidth < 900) {
      return 2; // (แท็บเล็ต แสดง 2 คอลัมน์
    } else {
      return 3; // แท็บเล็ตแนวนอน/เดสก์ท็อป แสดง 3 คอลัมน์
    }
  }
}

class DocCard extends StatelessWidget {
  final String title;
  final int count;
  final List<String> items;

  const DocCard({super.key, required this.title, required this.count, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Image.asset('assets/images/66.png', width: 45, height: 45),

                      const SizedBox(width: 8),
                      Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 11, 139, 64)))),
                    ],
                  ),
                ),

                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 11, 139, 64),
                  radius: 12,
                  child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Align(alignment: Alignment.center, child: SizedBox(width: 370, child: const Divider(thickness: 1.5, color: Color.fromARGB(255, 11, 139, 64)))),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return HoverableListItem(text: items[index]);
            },
          ),
        ],
      ),
    );
  }
}

class HoverableListItem extends StatefulWidget {
  final String text;
  const HoverableListItem({super.key, required this.text});

  @override
  State<HoverableListItem> createState() => _HoverableListItemState();
}

class _HoverableListItemState extends State<HoverableListItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 12, 15, 12),
        child: Row(
          children: [
            const Icon(
              Icons.article_outlined, // icon item
              size: 18,
              color: Color.fromARGB(221, 52, 50, 80),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isHovered ? Color.fromARGB(255, 11, 139, 64) : const Color.fromARGB(221, 52, 50, 80),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
