import 'package:flutter/material.dart';
import 'package:project/models/workspace_model.dart';
import 'board_card.dart'; // เรียกใช้ BoardCard Widget ที่แยกไฟล์ไว้
import 'mock_boards.dart'; // เรียกใช้ mock data จากไฟล์แยก

class HomeDesktopUI extends StatelessWidget {
  const HomeDesktopUI({
    super.key,
    required WorkspaceModel workspace,
  }); // Constructor แบบ const สำหรับ StatelessWidget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold = โครงหน้า Layout หลัก
      backgroundColor: const Color.fromARGB(255, 35, 35, 37), // สีพื้นหลังเข้ม
      body: Padding(
        padding: const EdgeInsets.all(32.0), // Padding รอบนอกทั้งหมด 32 px
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // จัดเนื้อหาชิดซ้าย
          children: [
            Text(
              // หัวข้อ WORKSPACES ด้านบน
              'WORKSPACES',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color.fromARGB(255, 240, 239, 239),
              ),
            ),
            const SizedBox(height: 18), // ระยะห่างระหว่างหัวข้อกับ GridView
            Expanded(
              // ขยาย GridView ให้เต็มพื้นที่ที่เหลือ
              child: GridView.builder(
                // ใช้ GridView.builder สร้างการ์ดแบบ grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // จำนวนคอลัมน์ต่อ 1 แถว
                  crossAxisSpacing: 24, // ระยะห่างแนวนอนระหว่างการ์ด
                  mainAxisSpacing: 24, // ระยะห่างแนวตั้งระหว่างการ์ด
                  childAspectRatio: 1.8, // อัตราส่วนกว้าง:สูง ของการ์ด
                ),
                itemCount:
                    mockBoards.length, // จำนวนการ์ด = จำนวนข้อมูลใน mockBoards
                itemBuilder: (context, index) {
                  final board = mockBoards[index]; // ดึงข้อมูล board ทีละอัน
                  return BoardCard(
                    // เรียกใช้ Widget BoardCard
                    imageUrl: board['image'], // ส่ง URL ภาพไป
                    members: board['members'], // ส่งจำนวนสมาชิกไป
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
