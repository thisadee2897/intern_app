import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AutoUpdateManager {
  static final AutoUpdateManager _instance = AutoUpdateManager._internal();
  factory AutoUpdateManager() => _instance;
  AutoUpdateManager._internal();

  // 🔧 Configuration
  static const String UPDATE_CHECK_URL = 'https://api.github.com/repos/thisadee2897/intern_app/releases/latest';
  static const Duration CHECK_INTERVAL = Duration(hours: 6); // ตรวจสอบทุก 6 ชั่วโมง
  
  bool _isInitialized = false;
  PackageInfo? _packageInfo;
  
  // 📱 Initialize Auto Updater
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _isInitialized = true;
      
      print('🎯 Auto Updater initialized');
      print('📦 App Name: ${_packageInfo!.appName}');
      print('🔢 Current Version: ${_packageInfo!.version}');
      print('🏗️ Build Number: ${_packageInfo!.buildNumber}');
      
      // เช็กอัปเดตเมื่อเปิดแอป (เฉพาะ Desktop)
      if (_isDesktop()) {
        await checkForUpdates(silent: true);
      }
    } catch (e) {
      print('❌ Failed to initialize Auto Updater: $e');
    }
  }
  
  // 🔍 Check for updates
  Future<UpdateInfo?> checkForUpdates({bool silent = false}) async {
    if (!_isInitialized || !_isDesktop()) {
      if (!silent) print('⚠️ Auto updater not available on this platform');
      return null;
    }
    
    try {
      if (!silent) print('🔄 Checking for updates...');
      
      final response = await http.get(
        Uri.parse(UPDATE_CHECK_URL),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestVersion = data['tag_name']?.replaceFirst('v', '') ?? '';
        final downloadUrl = _getDownloadUrl(data['assets']);
        final releaseNotes = data['body'] ?? '';
        
        if (_isNewVersionAvailable(latestVersion)) {
          final updateInfo = UpdateInfo(
            version: latestVersion,
            downloadUrl: downloadUrl,
            releaseNotes: releaseNotes,
            currentVersion: _packageInfo!.version,
          );
          
          if (!silent) {
            print('✅ New version available: $latestVersion');
            print('📥 Download URL: $downloadUrl');
          }
          
          return updateInfo;
        } else {
          if (!silent) print('ℹ️ You are using the latest version');
          return null;
        }
      } else if (response.statusCode == 404) {
        if (!silent) print('ℹ️ No releases found yet');
        return null;
      } else {
        if (!silent) print('❌ Failed to check for updates: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      if (!silent) print('❌ Error checking for updates: $e');
      return null;
    }
  }
  
  // 📱 Check with UI feedback
  Future<void> checkForUpdatesWithUI(BuildContext context) async {
    // แสดง loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('กำลังตรวจสอบอัปเดต...'),
          ],
        ),
      ),
    );
    
    final updateInfo = await checkForUpdates(silent: false);
    
    if (context.mounted) {
      Navigator.of(context).pop(); // ปิด loading dialog
      
      if (updateInfo != null) {
        _showUpdateDialog(context, updateInfo);
      } else {
        _showNoUpdateDialog(context);
      }
    }
  }
  
  // 🔄 Get download URL based on platform
  String _getDownloadUrl(List<dynamic> assets) {
    String platform = '';
    String extension = '';
    
    if (Platform.isWindows) {
      platform = 'windows';
      extension = '.exe';
    } else if (Platform.isMacOS) {
      platform = 'macos';
      extension = '.dmg';
    } else if (Platform.isLinux) {
      platform = 'linux';
      extension = '.AppImage';
    }
    
    // หาไฟล์ที่ตรงกับ platform
    for (var asset in assets) {
      final name = asset['name']?.toString().toLowerCase() ?? '';
      if (name.contains(platform) && name.endsWith(extension)) {
        return asset['browser_download_url'] ?? '';
      }
    }
    
    // ถ้าไม่เจอให้ใช้ไฟล์แรก
    return assets.isNotEmpty ? assets[0]['browser_download_url'] ?? '' : '';
  }
  
  // 🔍 Compare versions
  bool _isNewVersionAvailable(String latestVersion) {
    try {
      final current = _packageInfo!.version;
      return _compareVersions(latestVersion, current) > 0;
    } catch (e) {
      return false;
    }
  }
  
  // 🔢 Version comparison (semantic versioning)
  int _compareVersions(String version1, String version2) {
    final v1Parts = version1.split('.').map(int.parse).toList();
    final v2Parts = version2.split('.').map(int.parse).toList();
    
    // Pad with zeros if needed
    while (v1Parts.length < 3) v1Parts.add(0);
    while (v2Parts.length < 3) v2Parts.add(0);
    
    for (int i = 0; i < 3; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    
    return 0;
  }
  
  // 🖥️ Check if running on desktop
  bool _isDesktop() {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }
  
  // 💬 Show update dialog
  void _showUpdateDialog(BuildContext context, UpdateInfo updateInfo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.system_update, color: Colors.green),
            SizedBox(width: 8),
            Text('มีอัปเดตใหม่!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🔢 เวอร์ชันปัจจุบัน: ${updateInfo.currentVersion}'),
            Text('✨ เวอร์ชันใหม่: ${updateInfo.version}'),
            const SizedBox(height: 12),
            if (updateInfo.releaseNotes.isNotEmpty) ...[
              const Text('📝 รายละเอียดการอัปเดต:', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                height: 100,
                width: double.maxFinite,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  child: Text(updateInfo.releaseNotes),
                ),
              ),
            ],
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
              _downloadUpdate(updateInfo.downloadUrl);
            },
            child: const Text('ดาวน์โหลดอัปเดต'),
          ),
        ],
      ),
    );
  }
  
  // ❌ Show no update dialog
  void _showNoUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.blue),
            SizedBox(width: 8),
            Text('อัปเดตแล้ว'),
          ],
        ),
        content: Text('คุณใช้เวอร์ชันล่าสุดแล้ว (${_packageInfo!.version})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }
  
  // 📥 Download update
  Future<void> _downloadUpdate(String url) async {
    try {
      if (url.isNotEmpty) {
        await launchUrl(Uri.parse(url));
        print('🌐 Opening download URL: $url');
      } else {
        print('❌ No download URL available');
      }
    } catch (e) {
      print('❌ Failed to open download URL: $e');
    }
  }
  
  // 📊 Get current app info
  String get currentVersion => _packageInfo?.version ?? 'Unknown';
  String get appName => _packageInfo?.appName ?? 'Unknown';
  String get buildNumber => _packageInfo?.buildNumber ?? 'Unknown';
}

// 📦 Update Information Model
class UpdateInfo {
  final String version;
  final String downloadUrl;
  final String releaseNotes;
  final String currentVersion;
  
  UpdateInfo({
    required this.version,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.currentVersion,
  });
  
  @override
  String toString() {
    return 'UpdateInfo(version: $version, currentVersion: $currentVersion)';
  }
}
