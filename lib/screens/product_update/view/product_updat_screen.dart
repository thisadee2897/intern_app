import 'package:flutter/material.dart'; // นำเข้า Material UI จาก Flutter
import 'package:flutter/gestures.dart'; // ใช้งาน Gesture ต่าง ๆ เช่น Tap ใน TextSpan

class ProductUpdatScreen extends StatefulWidget {
  // สร้างหน้าจอแบบ StatefulWidget สำหรับการอัปเดตสินค้า
  const ProductUpdatScreen({super.key}); // Constructor แบบมี key

  @override
  State<ProductUpdatScreen> createState() => _ProductUpdatScreenState(); // สร้าง State ของ Widget นี้
}

class _ProductUpdatScreenState extends State<ProductUpdatScreen> {
  // ส่วนที่จัดการสถานะของหน้าจอ
  bool isNotRobot = false; // ใช้เก็บค่าว่าผู้ใช้ติ๊ก "I'm not a robot" หรือยัง
  String? hoveredCategory; // ใช้เก็บชื่อหมวดหมู่เมื่อเมาส์ชี้อยู่

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold คือโครงสร้างหลักของหน้า
      body: SingleChildScrollView(
        // ทำให้หน้าเลื่อนได้ในแนวตั้ง
        padding: const EdgeInsets.all(24.0), // กำหนด padding รอบนอก
        child: Center(
          // จัดกึ่งกลางเนื้อหาทั้งหมด
          child: ConstrainedBox(
            // กำหนดขนาดสูงสุดของเนื้อหา
            constraints: const BoxConstraints(maxWidth: 1200), // ไม่ให้กว้างเกิน 1200
            child: Column(
              // วางเนื้อหาในแนวตั้ง
              crossAxisAlignment: CrossAxisAlignment.start, // ชิดซ้าย
              children: [
                Row(
                  // แถวแรก ประกอบด้วยชื่อหัวข้อและช่องค้นหา
                  children: [
                    const SelectableText(
                      // ข้อความหัวข้อที่สามารถก๊อปปี้ได้
                      'Update',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 11, 12, 14)),
                    ),
                    const Spacer(), // ดันให้ปุ่มและช่องค้นหาไปชิดขวา
                    SizedBox(
                      // กล่องห่อช่องค้นหา
                      width: 240, // ความกว้างของ TextField
                      child: TextField(
                        // ช่องค้นหา
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          filled: true,
                          fillColor: const Color(0xfff5fff8), // สีพื้นหลังของช่องค้นหา
                          hintText: 'Search...', // ข้อความแนะนำ
                          enabledBorder: OutlineInputBorder(
                            // เส้นขอบปกติ
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          focusedBorder: OutlineInputBorder(
                            // เส้นขอบเมื่อคลิก
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12), // ระยะห่างระหว่างช่องค้นหากับปุ่ม
                    ElevatedButton(
                      // ปุ่มค้นหา
                      onPressed: () {}, // ตอนนี้ยังไม่มีฟังก์ชันทำงาน
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // สีพื้นหลังปุ่ม
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Search', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 24), // เว้นระยะห่างแนวตั้งระหว่างแถว
                Row(
                  // แบ่งเนื้อหาเป็น 2 คอลัมน์: ข่าว + ด้านข้าง
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      // คอลัมน์ซ้าย (หลัก)
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            // รูปภาพข่าวที่ 1
                            'assets/images/1.png',
                            fit: BoxFit.cover,
                            errorBuilder: // ถ้าโหลดรูปไม่ได้
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade300,
                                  height: 300,
                                  child: const Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey)),
                                ),
                          ),
                          const SizedBox(height: 24), // เว้นช่องว่างก่อน card ข่าว
                          newsCard(
                            // ใช้ widget newsCard ที่ประกาศไว้ข้างล่าง
                            version: '2.7',
                            title: '6amMart v2.7: Cashback to Wallet & Extra Packaging Charge',
                            date: 'April 9, 2025',
                            content:
                                'The 6amMart team brings another exciting news for its existing and new users with the release of version 2.7. The new version brings a fresh wave of features designed specifically to level up the multi vendor delivery business experience. This update is packed with improvements for everyone involved – admins, stores, and customers alike. So ...',
                          ),
                          const SizedBox(height: 16),
                          Image.asset(
                            // รูปข่าวที่ 2
                            'assets/images/5.png',
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade300,
                                  height: 300,
                                  child: const Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey)),
                                ),
                          ),
                          const SizedBox(height: 24),
                          newsCard(
                            // ข่าว v2.8
                            version: '2.8',
                            title: '6amMart v2.8: Subscription Model & 3rd Party Storage',
                            date: 'April 9, 2025',
                            content:
                                'Great news for all 6amMart users! The team 6amMart announces the release of version 2.8, packed with exciting new features designed to enhance your eCommerce experience. This update brings advantages to all the stakeholders of the system – especially the store owners and customers. The new updates offer greater flexibility, improved customer interaction, and efficient  ...',
                          ),
                          const SizedBox(height: 16),
                          Image.asset(
                            // รูปข่าวที่ 3
                            'assets/images/6.webp',
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade300,
                                  height: 300,
                                  child: const Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey)),
                                ),
                          ),
                          const SizedBox(height: 24),
                          newsCard(
                            // ข่าวเกี่ยวกับ Car Rental Module
                            version: '',
                            title: 'Introducing 6amMart’s Latest Launch: Car Rental Module Addon',
                            date: 'March 8, 2025',
                            content:
                                'Team 6amMart has officially launched the 6amMart Car Rental Module Addon! This innovative addition comes with powerful features designed to enhance the car rental business. Take a closer look at the exciting new functionalities 6amMart introduced for the rental module  Let’s take a detailed look at these- System Addon Customers receive the addon as a ...',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24), // ระยะห่างระหว่างสองคอลัมน์
                    Expanded(
                      // คอลัมน์ด้านขวา (sidebar)
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SelectableText(
                            // หัวข้อ Recent Posts
                            'Recent Posts',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 6, 6, 7)),
                          ),
                          const SizedBox(height: 12),
                          ...[
                            // ใช้ spread operator เพื่อ map รายการโพสต์เป็น widget
                            {'title': '8 Best Car Rental Software Solutions for 2025', 'date': 'May 26, 2025', 'image': 'assets/images/2.webp'},
                            {'title': 'eCommerce Inventory Management: Best Techniques & Practices', 'date': 'May 8, 2025', 'image': 'assets/images/3.webp'},
                            {'title': 'Discover the Best Zid Alternatives for eCommerce Success', 'date': 'May 5, 2025', 'image': 'assets/images/4.webp'},
                            {'title': 'How to Start a Car Rental Business: Step-by-Step Guide', 'date': 'March 20, 2025', 'image': 'assets/images/7.webp'},
                            {
                              'title': 'Introducing 6amMart’s Latest Launch: Car Rental Module Addon',
                              'date': 'February 27, 2025',
                              'image': 'assets/images/8.webp',
                            },
                          ].map(
                            // แปลงแต่ละรายการเป็น Widget
                            (post) => StatefulBuilder(
                              // ใช้ StatefulBuilder เพื่อจัดการการ hover แต่ละรายการ
                              builder: (context, setState) {
                                // bool isHovering = false; // สถานะ hover
                                return MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  // onEnter: (_) => setState(() => isHovering = true),
                                  // onExit: (_) => setState(() => isHovering = false),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          // รูป thumbnail
                                          post['image']!,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) => Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                                                child: const Icon(Icons.broken_image),
                                              ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          // ข้อความประกอบ
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post['title']!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  decoration: TextDecoration.none,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(post['date']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 80),
                          const SelectableText(
                            // หัวข้อ Categories
                            'Categories',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 8, 9, 10)),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            // แสดงหมวดหมู่แบบหลายบรรทัดได้
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              // สร้าง category เป็น chip
                              categoryChip('Comparison'),
                              categoryChip('Featured'),
                              categoryChip('Guides'),
                              categoryChip('Informative'),
                              categoryChip('Update'),
                            ],
                          ),
                          const SizedBox(height: 48),
                          const SelectableText(
                            // หัวข้อ Subscribe
                            'Subscribe',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 4, 5, 5)),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            // ช่องกรอกชื่อ
                            decoration: InputDecoration(labelText: 'Your Name*', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            // ช่องกรอกอีเมล
                            decoration: InputDecoration(labelText: 'Your Email*', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            // กล่อง checkbox "I'm not a robot"
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Checkbox(
                                  // เช็คว่าไม่ใช่บอท
                                  value: isNotRobot,
                                  onChanged: (value) {
                                    setState(() {
                                      isNotRobot = value ?? false;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Text("I'm not a robot"),
                                const Spacer(),
                                const FlutterLogo(size: 24), // เพิ่มโลโก้เพื่อความสวยงาม
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            // ปุ่มส่งข้อมูล
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {}, // ยังไม่มีฟังก์ชัน
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget newsCard({
    // ฟังก์ชันนี้ใช้สร้าง Widget สำหรับแสดงข่าวแต่ละรายการ
    required String version, // เวอร์ชันของอัปเดต (ไม่ได้ใช้ใน widget แต่รับไว้)
    required String title, // หัวข้อข่าว
    required String date, // วันที่ของข่าว
    required String content, // เนื้อหาย่อของข่าว
  }) {
    return Container(
      // กล่องห่อข่าว
      constraints: const BoxConstraints(maxWidth: 700), // กำหนดขนาดไม่ให้กว้างเกิน 700
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // จัดข้อความชิดซ้าย
        children: [
          Container(
            // แถบ "Update" ด้านบน
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffe4e8ff), // พื้นหลังสีฟ้าอ่อน
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Update', // ข้อความหัวข้อหมวดหมู่
              style: TextStyle(color: Color(0xff001F5B), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12), // เว้นช่องว่างก่อนหัวข้อ
          SelectableText(
            // หัวข้อข่าว
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            // แถวแสดงผู้เขียนและวันที่
            children: [
              const SelectableText(
                'by Editorial Team', // ผู้เขียนข่าว
                style: TextStyle(color: Colors.teal, decoration: TextDecoration.underline),
              ),
              const SizedBox(width: 12),
              SelectableText(date, style: const TextStyle(color: Colors.grey)), // วันที่
            ],
          ),
          const SizedBox(height: 16),
          SelectableText.rich(
            // ข้อความเนื้อหาข่าวพร้อมลิงก์ "Read more"
            TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              children: [
                TextSpan(text: content), // เนื้อหาข่าว
                TextSpan(
                  text: 'Read more', // ลิงก์อ่านเพิ่มเติม
                  style: const TextStyle(color: Colors.green),
                  recognizer:
                      TapGestureRecognizer() // ใช้ gesture เพื่อคลิกได้
                        ..onTap = () {
                          // Read more logic (ยังไม่มีเนื้อหา)
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryChip(String label) {
    // ฟังก์ชันสร้างป้ายหมวดหมู่แบบ hover ได้
    return MouseRegion(
      // ตรวจจับเมาส์
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hoveredCategory = label), // เมื่อเมาส์ชี้
      onExit: (_) => setState(() => hoveredCategory = null), // เมื่อเมาส์ออก
      child: Chip(
        // ป้ายหมวดหมู่ (Chip widget)
        label: Text(label),
        backgroundColor: // เปลี่ยนพื้นหลังตามสถานะ hover
            hoveredCategory == label ? Colors.green.shade50 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.green), // เส้นขอบสีเขียว
        ),
        labelStyle: TextStyle(
          color: hoveredCategory == label ? Colors.green.shade700 : Colors.green, // สีตัวอักษรเมื่อ hover
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
