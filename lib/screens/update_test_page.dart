import 'package:flutter/material.dart';
import 'package:project/components/update_widget.dart';
import 'package:project/utils/services/auto_update_manager.dart';

class UpdateTestPage extends StatefulWidget {
  const UpdateTestPage({super.key});

  @override
  State<UpdateTestPage> createState() => _UpdateTestPageState();
}

class _UpdateTestPageState extends State<UpdateTestPage> {
  final _updateManager = AutoUpdateManager();
  bool _isChecking = false;
  String _lastCheckResult = 'ยังไม่ได้ตรวจสอบ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ทดสอบระบบอัปเดต'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isChecking ? null : _quickCheck,
            tooltip: 'ตรวจสอบด่วน',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'สถานะระบบอัปเดต',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStatusRow('แอปพลิเคชัน', _updateManager.appName),
                    _buildStatusRow('เวอร์ชันปัจจุบัน', _updateManager.currentVersion),
                    _buildStatusRow('Build Number', _updateManager.buildNumber),
                    _buildStatusRow('ผลการตรวจสอบล่าสุด', _lastCheckResult),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Main Update Widget
            const UpdateWidget(),
            
            const SizedBox(height: 16),
            
            // Manual Test Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🧪 การทดสอบขั้นสูง',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ใช้สำหรับนักพัฒนาในการทดสอบระบบอัปเดต',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isChecking ? null : _testGitHubAPI,
                          icon: const Icon(Icons.api),
                          label: const Text('ทดสอบ GitHub API'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _showDebugInfo,
                          icon: const Icon(Icons.bug_report),
                          label: const Text('ข้อมูล Debug'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _simulateUpdate,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('จำลองอัปเดต'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Instructions Card
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        Text(
                          'วิธีทดสอบระบบอัปเดต',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('1. กดปุ่ม "ตรวจสอบอัปเดต" เพื่อเช็กเวอร์ชันใหม่'),
                    const Text('2. ระบบจะเชื่อมต่อ GitHub API'),
                    const Text('3. เปรียบเทียบเวอร์ชันกับ Releases ล่าสุด'),
                    const Text('4. แสดงผลลัพธ์การตรวจสอบ'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'หมายเหตุ: ต้องมี internet connection และ GitHub repository ที่มี releases',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _quickCheck() async {
    setState(() {
      _isChecking = true;
      _lastCheckResult = 'กำลังตรวจสอบ...';
    });
    
    try {
      final updateInfo = await _updateManager.checkForUpdates(silent: false);
      setState(() {
        _lastCheckResult = updateInfo != null 
            ? 'มีอัปเดตใหม่: ${updateInfo.version}'
            : 'ใช้เวอร์ชันล่าสุดแล้ว';
      });
    } catch (e) {
      setState(() {
        _lastCheckResult = 'เกิดข้อผิดพลาด: $e';
      });
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
  }
  
  void _testGitHubAPI() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('กำลังทดสอบ GitHub API...'),
          ],
        ),
      ),
    );
    
    try {
      final updateInfo = await _updateManager.checkForUpdates(silent: false);
      
      if (mounted) {
        Navigator.of(context).pop();
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('ผลการทดสอบ GitHub API'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🔗 URL: ${AutoUpdateManager.UPDATE_CHECK_URL}'),
                  const SizedBox(height: 8),
                  Text('📱 เวอร์ชันปัจจุบัน: ${_updateManager.currentVersion}'),
                  const SizedBox(height: 8),
                  if (updateInfo != null) ...[
                    Text('✅ เวอร์ชันใหม่ที่พบ: ${updateInfo.version}'),
                    Text('📥 ลิงก์ดาวน์โหลด: ${updateInfo.downloadUrl}'),
                  ] else ...[
                    const Text('ℹ️ ไม่มีเวอร์ชันใหม่'),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ตกลง'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('เกิดข้อผิดพลาด'),
            content: Text('ไม่สามารถเชื่อมต่อ GitHub API ได้\n\nรายละเอียด: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ตกลง'),
              ),
            ],
          ),
        );
      }
    }
  }
  
  void _showDebugInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ข้อมูล Debug'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🔧 ข้อมูลระบบ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Platform: ${Theme.of(context).platform}'),
              Text('App Name: ${_updateManager.appName}'),
              Text('Version: ${_updateManager.currentVersion}'),
              Text('Build: ${_updateManager.buildNumber}'),
              const SizedBox(height: 12),
              const Text('🌐 การเชื่อมต่อ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('GitHub API: ${AutoUpdateManager.UPDATE_CHECK_URL}'),
              Text('Check Interval: ${AutoUpdateManager.CHECK_INTERVAL.inHours} hours'),
              const SizedBox(height: 12),
              const Text('📱 สถานะ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Last Check: $_lastCheckResult'),
              Text('Is Checking: $_isChecking'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }
  
  void _simulateUpdate() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('จำลองอัปเดต'),
        content: const Text('จำลองการมีอัปเดตใหม่เวอร์ชัน 2.0.0'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // จำลองการแสดง update dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.system_update, color: Colors.green),
                      SizedBox(width: 8),
                      Text('มีอัปเดตใหม่! (จำลอง)'),
                    ],
                  ),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🔢 เวอร์ชันปัจจุบัน: 1.0.0'),
                      Text('✨ เวอร์ชันใหม่: 2.0.0'),
                      SizedBox(height: 12),
                      Text('📝 รายละเอียดการอัปเดต:'),
                      Text('- เพิ่มฟีเจอร์ใหม่\n- แก้ไข bugs\n- ปรับปรุงประสิทธิภาพ'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('ภายหลัง'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('นี่เป็นการจำลอง - ไม่มีการดาวน์โหลดจริง'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      child: const Text('ดาวน์โหลดอัปเดต'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('เริ่มจำลอง'),
          ),
        ],
      ),
    );
  }
}
