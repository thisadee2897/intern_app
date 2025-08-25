import 'package:flutter/material.dart';
import 'package:project/utils/services/auto_update_manager.dart';

class UpdateWidget extends StatefulWidget {
  const UpdateWidget({super.key});

  @override
  State<UpdateWidget> createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends State<UpdateWidget> {
  final _updateManager = AutoUpdateManager();
  bool _isChecking = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.system_update,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ระบบอัปเดตอัตโนมัติ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ตรวจสอบเวอร์ชันใหม่จาก GitHub',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // App Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                      const SizedBox(width: 6),
                      Text(
                        'ข้อมูลแอปพลิเคชัน',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('ชื่อแอป', _updateManager.appName),
                  _buildInfoRow('เวอร์ชัน', _updateManager.currentVersion),
                  _buildInfoRow('Build', _updateManager.buildNumber),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Actions
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isChecking ? null : _checkForUpdates,
                    icon: _isChecking 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(_isChecking ? 'กำลังตรวจสอบ...' : 'ตรวจสอบอัปเดต'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    onPressed: _showInfo,
                    icon: const Icon(Icons.help_outline),
                    label: const Text('ช่วยเหลือ'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            
            // Auto-check info
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.green),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'ระบบจะตรวจสอบอัปเดตอัตโนมัติทุก 6 ชั่วโมง',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _checkForUpdates() async {
    setState(() {
      _isChecking = true;
    });
    
    try {
      await _updateManager.checkForUpdatesWithUI(context);
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }
  
  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('วิธีการทำงาน'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🔄 ระบบอัปเดตอัตโนมัติ', 
                   style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• ตรวจสอบเวอร์ชันใหม่จาก GitHub Releases'),
              Text('• เปรียบเทียบกับเวอร์ชันปัจจุบัน'),
              Text('• แจ้งเตือนเมื่อมีอัปเดตใหม่'),
              Text('• ดาวน์โหลดไฟล์ติดตั้งอัตโนมัติ'),
              SizedBox(height: 12),
              Text('🖥️ รองรับแพลตฟอร์ม', 
                   style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Windows (.exe)'),
              Text('• macOS (.dmg)'),
              Text('• Linux (.AppImage)'),
              SizedBox(height: 12),
              Text('⚠️ หมายเหตุ', 
                   style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('ระบบนี้ทำงานเฉพาะบน Desktop เท่านั้น'),
              Text('Mobile จะไม่แสดงฟีเจอร์นี้'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('เข้าใจแล้ว'),
          ),
        ],
      ),
    );
  }
}

// Settings Page Integration Widget
class SettingsUpdateSection extends StatelessWidget {
  const SettingsUpdateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final updateManager = AutoUpdateManager();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'การอัปเดต',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.system_update, color: Colors.blue),
          ),
          title: const Text('ตรวจสอบอัปเดต'),
          subtitle: Text('เวอร์ชันปัจจุบัน: ${updateManager.currentVersion}'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            updateManager.checkForUpdatesWithUI(context);
          },
        ),
        
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.schedule, color: Colors.green),
          ),
          title: const Text('อัปเดตอัตโนมัติ'),
          subtitle: const Text('ตรวจสอบทุก 6 ชั่วโมง'),
          trailing: Chip(
            label: const Text('เปิดใช้งาน', style: TextStyle(fontSize: 12)),
            backgroundColor: Colors.green.withOpacity(0.1),
            side: BorderSide.none,
          ),
        ),
        
        const Divider(),
      ],
    );
  }
}
