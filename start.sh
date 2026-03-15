<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SalonPro | نظام إدارة صالونات الحلاقة</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1><i class="fas fa-cut"></i> SalonPro <span>v5.0</span></h1>
            <p>نظام إدارة صالونات الحلاقة المتكامل - عيد الأضحى المبارك</p>
            <div id="userInfo" class="user-info hidden">
                <i class="fas fa-user-circle"></i>
                <span id="currentUserName"></span>
                <span id="currentUserRole" class="role-badge"></span>
                <button onclick="logout()" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i> تسجيل خروج
                </button>
            </div>
        </div>

        <!-- Login Section -->
        <div id="loginSection">
            <div class="login-container">
                <h2><i class="fas fa-lock"></i> تسجيل الدخول</h2>
                <div class="login-tabs">
                    <button class="login-tab active" onclick="switchLoginTab('user')">
                        <i class="fas fa-user"></i> عميل
                    </button>
                    <button class="login-tab" onclick="switchLoginTab('employee')">
                        <i class="fas fa-user-tie"></i> موظف
                    </button>
                </div>
                
                <div id="userLogin">
                    <p>يمكنك حجز موعد بدون تسجيل</p>
                    <button onclick="continueAsUser()" class="btn" style="width: 100%;">
                        <i class="fas fa-arrow-right"></i> متابعة كعميل
                    </button>
                </div>
                
                <div id="employeeLogin" class="hidden">
                    <div class="form-group">
                        <label><i class="fas fa-user"></i> اسم المستخدم</label>
                        <input type="text" id="loginUsername" placeholder="أدخل اسم المستخدم">
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-key"></i> كلمة السر</label>
                        <input type="password" id="loginPassword" placeholder="أدخل كلمة السر">
                    </div>
                    <button onclick="employeeLogin()" class="btn" style="width: 100%;">
                        <i class="fas fa-sign-in-alt"></i> دخول
                    </button>
                </div>
                
                <div id="loginMessage" class="message"></div>
            </div>
        </div>

        <!-- Main Content -->
        <div id="mainContent" class="hidden">
            <!-- Live Update -->
            <div class="live-badge">
                <i class="fas fa-circle"></i> تحديث مباشر
                <span id="lastUpdate"></span>
            </div>

            <!-- Main Tabs -->
            <div class="tabs">
                <button class="tab-btn active" onclick="showMainTab('bookings')" id="tabBookings">
                    <i class="fas fa-calendar-check"></i> الحجوزات
                </button>
                <button class="tab-btn" onclick="showMainTab('employees')" id="tabEmployees" disabled>
                    <i class="fas fa-users-cog"></i> إدارة الموظفين
                </button>
                <button class="tab-btn" onclick="showMainTab('settings')" id="tabSettings" disabled>
                    <i class="fas fa-cog"></i> الإعدادات
                </button>
            </div>

            <!-- Bookings Tab -->
            <div id="bookingsTab">
                <!-- Booking Form -->
                <div class="card" id="bookingFormCard">
                    <div class="card-header">
                        <h2><i class="fas fa-plus-circle"></i> حجز موعد جديد</h2>
                    </div>
                    <form id="bookingForm">
                        <div class="form-grid">
                            <div class="form-group">
                                <label><i class="fas fa-user"></i> الاسم الكامل</label>
                                <input type="text" id="name" placeholder="أدخل اسمك الثلاثي" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-phone"></i> رقم الجوال</label>
                                <input type="tel" id="phone" placeholder="05xxxxxxxx" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-calendar"></i> التاريخ</label>
                                <select id="date" required>
                                    <option value="">-- اختر التاريخ --</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-clock"></i> الوقت</label>
                                <select id="time" required>
                                    <option value="">-- اختر الوقت --</option>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn" style="width: 100%;">
                            <i class="fas fa-check"></i> تأكيد الحجز
                        </button>
                    </form>
                    <div id="bookingMessage" class="message"></div>
                </div>

                <!-- Appointments List -->
                <div class="card">
                    <div class="card-header">
                        <h2><i class="fas fa-list"></i> قائمة الحجوزات</h2>
                        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                            <div class="filter-buttons">
                                <button class="filter-btn active" onclick="filterBookings('all')" id="filterAll">الكل</button>
                                <button class="filter-btn" onclick="filterBookings('active')" id="filterActive">النشطة</button>
                                <button class="filter-btn" onclick="filterBookings('completed')" id="filterCompleted">المكتملة</button>
                            </div>
                            <button onclick="refreshBookings()" class="btn btn-small">
                                <i class="fas fa-sync-alt"></i> تحديث
                            </button>
                        </div>
                    </div>
                    <div class="stats-grid">
                        <div class="stat-card">
                            <i class="fas fa-users"></i>
                            <h3>إجمالي الحجوزات</h3>
                            <div class="stat-number" id="totalBookings">0</div>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-arrow-left"></i>
                            <h3>الدور الحالي</h3>
                            <div class="stat-number" id="currentTurn">-</div>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-check-circle"></i>
                            <h3>المكتملة</h3>
                            <div class="stat-number" id="completedCount">0</div>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>العميل</th>
                                    <th>رقم الجوال</th>
                                    <th>التاريخ</th>
                                    <th>الوقت</th>
                                    <th>الحالة</th>
                                    <th id="actionsHeader">إجراءات</th>
                                </tr>
                            </thead>
                            <tbody id="appointmentsTable">
                                <tr><td colspan="7" style="text-align: center;">جاري تحميل البيانات...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Employees Tab -->
            <div id="employeesTab" class="hidden">
                <div class="card">
                    <div class="card-header">
                        <h2><i class="fas fa-user-plus"></i> إضافة موظف جديد</h2>
                    </div>
                    <form id="employeeForm">
                        <div class="form-grid">
                            <div class="form-group">
                                <label>الاسم الكامل</label>
                                <input type="text" id="empName" required>
                            </div>
                            <div class="form-group">
                                <label>اسم المستخدم</label>
                                <input type="text" id="empUsernameField" required>
                            </div>
                            <div class="form-group">
                                <label>كلمة السر</label>
                                <input type="password" id="empPasswordField" required>
                            </div>
                        </div>

                        <h3>صلاحيات الموظف</h3>
                        <div class="permissions-grid">
                            <div class="permission-item">
                                <input type="checkbox" id="permView" checked disabled>
                                <label>مشاهدة الحجوزات</label>
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" id="permAdd">
                                <label>إضافة حجوزات</label>
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" id="permEdit">
                                <label>تعديل الحجوزات</label>
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" id="permDelete">
                                <label>إلغاء الحجوزات</label>
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" id="permViewPhone">
                                <label>رؤية أرقام الجوال</label>
                            </div>
                        </div>

                        <button type="submit" class="btn">حفظ الموظف</button>
                    </form>
                    <div id="employeeMessage" class="message"></div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h2><i class="fas fa-users"></i> قائمة الموظفين</h2>
                        <button onclick="refreshEmployees()" class="btn btn-small">تحديث</button>
                    </div>
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>الموظف</th>
                                    <th>اسم المستخدم</th>
                                    <th>الدور</th>
                                    <th>الحالة</th>
                                    <th>الإجراءات</th>
                                </tr>
                            </thead>
                            <tbody id="employeesTable"></tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Settings Tab -->
            <div id="settingsTab" class="hidden">
                <div class="card">
                    <h2>إعدادات أيام العيد</h2>
                    <div class="form-group">
                        <label>أول أيام العيد</label>
                        <input type="date" id="eidStartDate">
                    </div>
                    <div class="form-group">
                        <label>آخر أيام العيد</label>
                        <input type="date" id="eidEndDate">
                    </div>
                    <button onclick="saveSettings()" class="btn">حفظ الإعدادات</button>
                </div>

                <div class="card">
                    <h2>إعدادات أوقات العمل</h2>
                    <div class="form-group">
                        <label>من الساعة</label>
                        <input type="time" id="workStart" value="09:00">
                    </div>
                    <div class="form-group">
                        <label>إلى الساعة</label>
                        <input type="time" id="workEnd" value="23:00">
                    </div>
                    <button onclick="saveWorkSettings()" class="btn">حفظ أوقات العمل</button>
                </div>
            </div>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>