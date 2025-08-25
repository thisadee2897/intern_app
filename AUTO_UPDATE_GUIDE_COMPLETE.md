# 🚀 คู่มือระบบ Auto Update สำหรับ InternApp

## 📋 ภาพรวม

ระบบ Auto Update ที่สร้างขึ้นจะทำงานแบบ **End-to-End** โดย:

1. **Build อัตโนมัติ** เมื่อมี Git tag ใหม่
2. **สร้าง Release** บน GitHub พร้อมไฟล์ติดตั้ง
3. **ตรวจสอบอัปเดต** ในแอปโดยอัตโนมัติ
4. **ดาวน์โหลดอัปเดต** เมื่อมีเวอร์ชันใหม่

---

## 🔧 การตั้งค่าครั้งแรก

### 1. ติดตั้ง Dependencies
```bash
flutter pub add package_info_plus url_launcher http
```

### 2. เปิดใช้งาน GitHub Actions
- ไฟล์ `.github/workflows/build-and-release.yml` ถูกสร้างแล้ว
- GitHub จะ build อัตโนมัติเมื่อมี tag ใหม่

### 3. ตั้งค่า Repository
```bash
# ตั้งค่า remote repository (ถ้ายังไม่ได้ทำ)
git remote add origin https://github.com/thisadee2897/intern_app.git

# Push code ขึ้น GitHub
git add .
git commit -m "feat: add auto update system"
git push origin main
```

---

## 🚀 วิธีสร้าง Release ใหม่

### วิธีที่ 1: ใช้ Script (แนะนำ)
```bash
# Build และสร้าง release version 1.0.1
./scripts/build-release.sh 1.0.1
```

### วิธีที่ 2: Manual
```bash
# 1. อัปเดตเวอร์ชันใน pubspec.yaml
version: 1.0.1+1

# 2. Commit และ push
git add .
git commit -m "chore: bump version to 1.0.1"
git push origin main

# 3. สร้าง tag
git tag -a v1.0.1 -m "Release version 1.0.1"
git push origin v1.0.1
```

### วิธีที่ 3: GitHub Actions Manual
- ไปที่ GitHub → Actions
- เลือก "Build and Release"
- กด "Run workflow"

---

## 🔄 กระบวนการทำงาน

### 1. เมื่อสร้าง Release
```
Developer creates tag (v1.0.1)
       ↓
GitHub Actions triggered
       ↓
Build for Windows/macOS/Linux
       ↓
Create installers/packages
       ↓
Upload to GitHub Releases
       ↓
Users can download
```

### 2. เมื่อแอปตรวจสอบอัปเดต
```
App checks GitHub API
       ↓
Compare versions
       ↓
If newer version found
       ↓
Show update dialog
       ↓
User downloads installer
       ↓
Manual installation
```

---

## 📱 การใช้งานในแอป

### 1. การเริ่มต้น (main.dart)
```dart
// ระบบจะเริ่มต้นอัตโนมัติใน main()
await AutoUpdateManager().initialize();
```

### 2. การใช้งาน UI Components
```dart
// Widget อัปเดตแบบเต็ม
const UpdateWidget(),

// Widget สำหรับหน้า Settings
const SettingsUpdateSection(),

// หน้าทดสอบ (สำหรับ development)
const UpdateTestPage(),
```

### 3. การตรวจสอบด้วยตนเอง
```dart
// ตรวจสอบพร้อม UI
AutoUpdateManager().checkForUpdatesWithUI(context);

// ตรวจสอบแบบเงียบ
final updateInfo = await AutoUpdateManager().checkForUpdates(silent: true);
```

---

## 🛠️ การ Customize

### 1. เปลี่ยน URL ตรวจสอบอัปเดต
```dart
// ใน auto_update_manager.dart
static const String UPDATE_CHECK_URL = 'https://api.github.com/repos/YOUR_USERNAME/YOUR_REPO/releases/latest';
```

### 2. เปลี่ยนความถี่ในการตรวจสอบ
```dart
// ใน auto_update_manager.dart
static const Duration CHECK_INTERVAL = Duration(hours: 12); // เปลี่ยนเป็น 12 ชั่วโมง
```

### 3. เพิ่มการแจ้งเตือน
```dart
// ใช้ flutter_local_notifications
void showUpdateNotification(String version) {
  // Code สำหรับแจ้งเตือน
}
```

---

## 🧪 การทดสอบ

### 1. ทดสอบใน Development
```dart
// เพิ่มในหน้าใดหน้าหนึ่ง
Navigator.push(context, MaterialPageRoute(
  builder: (context) => const UpdateTestPage(),
));
```

### 2. ทดสอบ GitHub API
```bash
# ทดสอบ API response
curl https://api.github.com/repos/thisadee2897/intern_app/releases/latest
```

### 3. ทดสอบการ Build
```bash
# ทดสอบ build script
./scripts/build-release.sh 1.0.0-test
```

---

## 📦 โครงสร้างไฟล์

```
lib/
├── main.dart                           # เริ่มต้น AutoUpdateManager
├── utils/services/
│   └── auto_update_manager.dart        # ระบบหลักการอัปเดต
├── components/
│   └── update_widget.dart              # UI Components
└── screens/
    └── update_test_page.dart           # หน้าทดสอบ

scripts/
└── build-release.sh                    # Script สร้าง release

.github/workflows/
└── build-and-release.yml              # GitHub Actions
```

---

## 🔒 Security & Production

### 1. Code Signing (ผลิตจริง)
```bash
# macOS
codesign --sign "Developer ID" --timestamp InternApp.app

# Windows  
signtool sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a InternApp.exe
```

### 2. การตรวจสอบ Checksum
```dart
// เพิ่มการตรวจสอบ SHA256
bool verifyChecksum(String filePath, String expectedHash) {
  // Verification code
}
```

### 3. HTTPS Only
```dart
// ตรวจสอบว่าใช้ HTTPS เท่านั้น
if (!downloadUrl.startsWith('https://')) {
  throw Exception('Insecure download URL');
}
```

---

## 🚨 การแก้ไขปัญหา

### 1. ไม่สามารถตรวจสอบอัปเดตได้
- ตรวจสอบ internet connection
- ตรวจสอบ GitHub repository เป็น public
- ดู console logs สำหรับ error messages

### 2. GitHub Actions ไม่ทำงาน
- ตรวจสอบ GITHUB_TOKEN permissions
- ดู Actions logs ใน GitHub
- ตรวจสอบ Flutter version ใน workflow

### 3. ไฟล์ build ใหญ่เกินไป
```bash
# ใช้ --split-debug-info เพื่อลดขนาด
flutter build windows --release --split-debug-info=debug-info/
```

---

## 📈 สถิติและ Monitoring

### 1. การติดตาม Downloads
```dart
// ส่งข้อมูลไป Analytics
void trackUpdateDownload(String version) {
  // Analytics code
}
```

### 2. การติดตาม Errors
```dart
// Log errors ไป crash reporting service
void logUpdateError(String error) {
  // Error reporting code
}
```

---

## 🎯 Roadmap

### Phase 1: ✅ ระบบพื้นฐาน
- [x] GitHub integration
- [x] Version comparison
- [x] Download management
- [x] UI components

### Phase 2: 🔄 กำลังพัฒนา
- [ ] Background downloads
- [ ] Automatic installation
- [ ] Update rollback
- [ ] Beta channel support

### Phase 3: 📋 แผนอนาคต
- [ ] Delta updates
- [ ] P2P distribution
- [ ] Update scheduling
- [ ] Advanced analytics

---

## 📞 การสนับสนุน

### ข้อมูลการติดต่อ
- **GitHub Issues**: สำหรับ bug reports
- **Discussions**: สำหรับคำถามและข้อเสนอแนะ
- **Email**: สำหรับเรื่องเร่งด่วน

### เอกสารเพิ่มเติม
- [Flutter Desktop Deployment](https://docs.flutter.dev/deployment/desktop)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org/)

---

**🎉 ขอให้การพัฒนาเป็นไปด้วยดี!**
