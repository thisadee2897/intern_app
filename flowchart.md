# OHO Task Management System - Flowchart

## ภาพรวมระบบ
Flowchart นี้แสดงการไหลของกระบวนการทำงานหลักใน OHO Task Management System ตั้งแต่การเข้าสู่ระบบจนถึงการจัดการงานต่างๆ

## 1. Authentication Flow (การเข้าสู่ระบบ)

```mermaid
flowchart TD
    A[เริ่มต้นแอป] --> B{มี Token หรือไม่}
    B -->|ไม่มี| C[หน้า Login]
    B -->|มี| D{Token หมดอายุ}
    D -->|หมดอายุ| C
    D -->|ยังใช้ได้| E[หน้า Home]
    
    C --> F[กรอก Username และ Password]
    F --> G[ส่งข้อมูลไป Backend]
    G --> H{Login สำเร็จ}
    H -->|สำเร็จ| I[บันทึก Token]
    H -->|ไม่สำเร็จ| J[แสดง Error Message]
    J --> F
    I --> K[บันทึกข้อมูล User]
    K --> E
    
    E --> L[แสดง Workspace List]
```

## 2. Workspace Management Flow (การจัดการ Workspace)

```mermaid
flowchart TD
    A[หน้า Home] --> B[โหลด Workspace List]
    B --> C{มี Workspace}
    C -->|ไม่มี| D[แสดงข้อความไม่พบ workspace]
    C -->|มี| E[แสดง Workspace Cards]
    
    E --> F{User Action}
    F -->|สร้าง Workspace ใหม่| G[เปิด Create Dialog]
    F -->|แก้ไข Workspace| H[เปิด Edit Dialog]
    F -->|จัดการ User| I[เปิด User Management]
    F -->|เข้า Workspace| J[ไปหน้า Project]
    
    G --> K[กรอกข้อมูล Workspace]
    K --> L[ส่งข้อมูลไป API]
    L --> M{สร้างสำเร็จ}
    M -->|สำเร็จ| N[รีเฟรช Workspace List]
    M -->|ไม่สำเร็จ| O[แสดง Error]
    O --> K
    N --> E
    
    H --> P[แก้ไขข้อมูล Workspace]
    P --> Q[ส่งข้อมูลไป API]
    Q --> R{แก้ไขสำเร็จ}
    R -->|สำเร็จ| N
    R -->|ไม่สำเร็จ| S[แสดง Error]
    S --> P
    
    I --> T[แสดงรายชื่อ User]
    T --> U{User Action}
    U -->|เพิ่ม User| V[ค้นหาและเพิ่ม User]
    U -->|ลบ User| W[ยืนยันการลบ]
    V --> X[อัพเดท User List]
    W --> Y[ลบ User จาก Workspace]
    Y --> X
    X --> T
    
    J --> Z[ไปหน้า Project Management]
```

## 3. Project Management Flow (การจัดการโปรเจค)

```mermaid
flowchart TD
    A[หน้า Project] --> B[โหลด Category List]
    B --> C[โหลด Project List]
    C --> D[แสดง Project Grid]
    
    D --> E{User Action}
    E -->|สร้าง Category| F[เปิด Category Dialog]
    E -->|สร้าง Project| G[เปิด Project Dialog]
    E -->|แก้ไข Category| H[เปิด Edit Category]
    E -->|แก้ไข Project| I[เปิด Edit Project]
    E -->|ลบ Category| J[ยืนยันการลบ Category]
    E -->|ลบ Project| K[ยืนยันการลบ Project]
    E -->|เข้า Project| L[ไปหน้า Project Detail]
    
    F --> M[กรอกข้อมูล Category]
    M --> N[ส่งข้อมูลไป API]
    N --> O{สร้างสำเร็จ?}
    O -->|สำเร็จ| P[รีเฟรช Category List]
    O -->|ไม่สำเร็จ| Q[แสดง Error]
    Q --> M
    P --> D
    
    G --> R[กรอกข้อมูล Project]
    R --> S[เลือก Category]
    S --> T[ส่งข้อมูลไป API]
    T --> U{สร้างสำเร็จ?}
    U -->|สำเร็จ| V[รีเฟรช Project List]
    U -->|ไม่สำเร็จ| W[แสดง Error]
    W --> R
    V --> D
    
    J --> X[ลบ Category และ Projects]
    K --> Y[ลบ Project]
    X --> P
    Y --> V
    
    L --> Z[ไปหน้า Project Detail]
```

## 4. Task Management Flow (การจัดการงาน)

```mermaid
flowchart TD
    A[หน้า Project Detail] --> B[เลือก Tab]
    B --> C{Tab ที่เลือก}
    C -->|Summary| D[แสดง Dashboard]
    C -->|Backlog| E[แสดง Sprint และ Task List]
    C -->|Board| F[แสดง Kanban Board]
    C -->|Timeline| G[แสดง Gantt Chart]
    
    E --> H{User Action}
    H -->|สร้าง Sprint| I[เปิด Sprint Dialog]
    H -->|สร้าง Task| J[เปิด Task Form]
    H -->|แก้ไข Sprint| K[เปิด Edit Sprint]
    H -->|แก้ไข Task| L[เปิด Edit Task]
    H -->|ลบ Sprint| M[ยืนยันการลบ Sprint]
    H -->|ลบ Task| N[ยืนยันการลบ Task]
    H -->|เริ่ม Sprint| O[ยืนยันเริ่ม Sprint]
    H -->|จบ Sprint| P[ยืนยันจบ Sprint]
    
    I --> Q[กรอกข้อมูล Sprint]
    Q --> R[ตั้งวันที่เริ่ม-สิ้นสุด]
    R --> S[ส่งข้อมูลไป API]
    S --> T{สร้างสำเร็จ?}
    T -->|สำเร็จ| U[รีเฟรช Sprint List]
    T -->|ไม่สำเร็จ| V[แสดง Error]
    V --> Q
    U --> E
    
    J --> W[กรอกข้อมูล Task]
    W --> X[เลือก Sprint]
    X --> Y[เลือก Assignee]
    Y --> Z[เลือก Priority]
    Z --> AA[เลือก Type of Work]
    AA --> BB[ส่งข้อมูลไป API]
    BB --> CC{สร้างสำเร็จ?}
    CC -->|สำเร็จ| U
    CC -->|ไม่สำเร็จ| DD[แสดง Error]
    DD --> W
    
    F --> EE{Board Action}
    EE -->|Drag Task| FF[อัพเดท Task Status]
    EE -->|เปิด Task Detail| GG[แสดง Task Detail Modal]
    
    FF --> HH[ส่งข้อมูลไป API]
    HH --> II{อัพเดทสำเร็จ?}
    II -->|สำเร็จ| JJ[อัพเดท Board UI]
    II -->|ไม่สำเร็จ| KK[ย้อนกลับ Position]
    KK --> F
    JJ --> F
    
    GG --> LL[แสดงรายละเอียด Task]
    LL --> MM{Task Action}
    MM -->|แก้ไข Task| L
    MM -->|เพิ่ม Comment| NN[เพิ่ม Comment]
    MM -->|อัพเดท Status| FF
    MM -->|ปิด Modal| F
    
    NN --> OO[ส่ง Comment ไป API]
    OO --> PP{เพิ่มสำเร็จ?}
    PP -->|สำเร็จ| QQ[อัพเดท Comment List]
    PP -->|ไม่สำเร็จ| RR[แสดง Error]
    QQ --> LL
    RR --> NN
```

## 5. Profile Management Flow (การจัดการข้อมูลส่วนตัว)

```mermaid
flowchart TD
    A[หน้า Settings] --> B[เลือก Profile]
    B --> C[โหลดข้อมูล User]
    C --> D[แสดงข้อมูลปัจจุบัน]
    
    D --> E{User Action}
    E -->|แก้ไขข้อมูล| F[เปิด Edit Form]
    E -->|เปลี่ยนรหัสผ่าน| G[เปิด Change Password Form]
    E -->|เปลี่ยนรูปโปรไฟล์| H[เลือกรูปใหม่]
    E -->|Logout| I[ยืนยัน Logout]
    
    F --> J[แก้ไขข้อมูลส่วนตัว]
    J --> K[ตรวจสอบข้อมูล]
    K --> L{ข้อมูลถูกต้อง?}
    L -->|ไม่ถูกต้อง| M[แสดง Validation Error]
    L -->|ถูกต้อง| N[ส่งข้อมูลไป API]
    M --> J
    N --> O{อัพเดทสำเร็จ?}
    O -->|สำเร็จ| P[อัพเดท Local Storage]
    O -->|ไม่สำเร็จ| Q[แสดง Error]
    P --> R[รีเฟรชข้อมูล]
    Q --> J
    R --> D
    
    G --> S[กรอกรหัสผ่านเก่า]
    S --> T[กรอกรหัสผ่านใหม่]
    T --> U[ยืนยันรหัสผ่านใหม่]
    U --> V[ตรวจสอบรหัสผ่าน]
    V --> W{รหัสผ่านถูกต้อง?}
    W -->|ไม่ถูกต้อง| X[แสดง Validation Error]
    W -->|ถูกต้อง| Y[ส่งข้อมูลไป API]
    X --> S
    Y --> Z{เปลี่ยนสำเร็จ?}
    Z -->|สำเร็จ| AA[แสดงข้อความสำเร็จ]
    Z -->|ไม่สำเร็จ| BB[แสดง Error]
    AA --> D
    BB --> S
    
    H --> CC[ตรวจสอบไฟล์รูป]
    CC --> DD{ไฟล์ถูกต้อง?}
    DD -->|ไม่ถูกต้อง| EE[แสดง Error ไฟล์]
    DD -->|ถูกต้อง| FF[อัพโหลดรูป]
    EE --> H
    FF --> GG{อัพโหลดสำเร็จ?}
    GG -->|สำเร็จ| HH[อัพเดทรูปโปรไฟล์]
    GG -->|ไม่สำเร็จ| II[แสดง Error]
    HH --> P
    II --> H
    
    I --> JJ[ลบ Token]
    JJ --> KK[ลบข้อมูล User]
    KK --> LL[ไปหน้า Login]
```

## 6. Error Handling Flow (การจัดการ Error)

```mermaid
flowchart TD
    A[API Call] --> B{Response Status}
    B -->|200-299| C[Success Response]
    B -->|400| D[Bad Request Error]
    B -->|401| E[Unauthorized Error]
    B -->|403| F[Forbidden Error]
    B -->|404| G[Not Found Error]
    B -->|422| H[Validation Error]
    B -->|500| I[Server Error]
    B -->|Network Error| J[Connection Error]
    
    C --> K[อัพเดท UI State]
    
    D --> L[แสดง Validation Messages]
    L --> M[ให้ User แก้ไขข้อมูล]
    
    E --> N[ลบ Token]
    N --> O[Redirect ไป Login]
    
    F --> P[แสดงข้อความ Permission Denied]
    
    G --> Q[แสดงข้อความ Data Not Found]
    
    H --> R[แสดง Field Validation Errors]
    R --> S[Highlight Error Fields]
    
    I --> T[แสดงข้อความ Server Error]
    T --> U[ให้ Retry Option]
    
    J --> V[แสดงข้อความ Connection Error]
    V --> W[ให้ Retry Option]
    
    U --> X{User เลือก Retry?}
    W --> X
    X -->|Yes| A
    X -->|No| Y[กลับหน้าเดิม]
```

## 7. Data Synchronization Flow (การซิงค์ข้อมูล)

```mermaid
flowchart TD
    A[User Action] --> B[อัพเดท Local State]
    B --> C[แสดง Loading State]
    C --> D[ส่ง API Request]
    D --> E{API Success?}
    
    E -->|Success| F[อัพเดท Local Storage]
    F --> G[อัพเดท UI State]
    G --> H[แสดง Success Message]
    H --> I[รีเฟรชข้อมูลที่เกี่ยวข้อง]
    
    E -->|Error| J[Rollback Local State]
    J --> K[แสดง Error Message]
    K --> L[ให้ Retry Option]
    L --> M{User เลือก Retry?}
    M -->|Yes| D
    M -->|No| N[กลับสู่สถานะเดิม]
    
    I --> O[invalidate Related Providers]
    O --> P[Trigger Re-fetch]
    P --> Q[อัพเดท UI ด้วยข้อมูลใหม่]
```

## 8. Navigation Flow (การนำทาง)

```mermaid
flowchart TD
    A[App Start] --> B{Authentication Check}
    B -->|Authenticated| C[Home Screen]
    B -->|Not Authenticated| D[Login Screen]
    
    C --> E[Workspace Selection]
    E --> F[Project Screen]
    F --> G[Project Detail]
    
    G --> H{Tab Selection}
    H -->|Summary| I[Dashboard View]
    H -->|Backlog| J[Sprint Management]
    H -->|Board| K[Kanban Board]
    H -->|Timeline| L[Gantt Chart]
    
    C --> M[Settings]
    M --> N{Settings Option}
    N -->|Profile| O[Profile Management]
    N -->|Preferences| P[App Preferences]
    
    subgraph Modal_Navigation
        Q[Task Detail Modal]
        R[Create/Edit Dialogs]
        S[Confirmation Dialogs]
    end
    
    subgraph Back_Navigation
        T[Browser Back] --> U[Previous Screen]
        V[App Back Button] --> U
    end
```

---

*Flowchart นี้แสดงการไหลของกระบวนการทำงานทั้งหมดในระบบ OHO Task Management ครอบคลุมตั้งแต่การเข้าสู่ระบบ การจัดการ workspace, project, task จนถึงการจัดการข้อมูลส่วนตัวและการจัดการ error ต่างๆ*
