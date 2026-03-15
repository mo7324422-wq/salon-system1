// ==================== المتغيرات العامة ====================
const API_URL = window.location.origin;
let CURRENT_USER = null;
let TOKEN = localStorage.getItem('token');
let CURRENT_FILTER = 'all';
let UPDATE_INTERVAL = null;

// ==================== دوال API ====================
async function apiRequest(endpoint, method = 'GET', data = null) {
    const headers = {
        'Content-Type': 'application/json'
    };
    
    if (TOKEN) {
        headers['Authorization'] = `Bearer ${TOKEN}`;
    }
    
    const config = {
        method,
        headers
    };
    
    if (data) {
        config.body = JSON.stringify(data);
    }
    
    try {
        const response = await fetch(`${API_URL}/api${endpoint}`, config);
        const result = await response.json();
        
        if (!response.ok) {
            throw new Error(result.error || 'حدث خطأ');
        }
        
        return result;
    } catch (error) {
        console.error('API Error:', error);
        throw error;
    }
}

// ==================== دوال تسجيل الدخول ====================
function switchLoginTab(tab) {
    document.querySelectorAll('.login-tab').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
    
    if (tab === 'user') {
        document.getElementById('userLogin').classList.remove('hidden');
        document.getElementById('employeeLogin').classList.add('hidden');
    } else {
        document.getElementById('userLogin').classList.add('hidden');
        document.getElementById('employeeLogin').classList.remove('hidden');
    }
}

async function continueAsUser() {
    CURRENT_USER = {
        id: 'guest',
        name: 'عميل',
        role: 'client'
    };
    
    showMainContent();
    updateUIBasedOnPermissions();
    showMainTab('bookings');
    loadInitialData();
    showMessage('loginMessage', '✅ مرحباً بك', 'success');
}

async function employeeLogin() {
    const username = document.getElementById('loginUsername').value;
    const password = document.getElementById('loginPassword').value;
    
    try {
        const result = await apiRequest('/auth/login', 'POST', { username, password });
        
        TOKEN = result.token;
        localStorage.setItem('token', result.token);
        CURRENT_USER = result.user;
        
        showMainContent();
        updateUIBasedOnPermissions();
        
        if (hasPermission('manage_employees')) {
            showMainTab('employees');
        } else {
            showMainTab('bookings');
        }
        
        loadInitialData();
        
        document.getElementById('loginUsername').value = '';
        document.getElementById('loginPassword').value = '';
        
        showMessage('loginMessage', '✅ مرحباً ' + result.user.full_name, 'success');
        
    } catch (error) {
        showMessage('loginMessage', '❌ ' + error.message, 'error');
    }
}

function logout() {
    TOKEN = null;
    localStorage.removeItem('token');
    CURRENT_USER = null;
    document.getElementById('loginSection').classList.remove('hidden');
    document.getElementById('mainContent').classList.add('hidden');
    document.getElementById('userInfo').classList.add('hidden');
    
    if (UPDATE_INTERVAL) {
        clearInterval(UPDATE_INTERVAL);
    }
}

function showMainContent() {
    document.getElementById('loginSection').classList.add('hidden');
    document.getElementById('mainContent').classList.remove('hidden');
    document.getElementById('userInfo').classList.remove('hidden');
    document.getElementById('currentUserName').textContent = CURRENT_USER.name;
    document.getElementById('currentUserRole').textContent = 
        CURRENT_USER.role === 'admin' ? 'مدير' : 
        CURRENT_USER.role === 'employee' ? 'موظف' : 'عميل';
}

function hasPermission(permission) {
    if (!CURRENT_USER) return false;
    if (CURRENT_USER.role === 'admin') return true;
    if (CURRENT_USER.role === 'employee') {
        return CURRENT_USER.permissions && CURRENT_USER.permissions.includes(permission);
    }
    return permission === 'add';
}

function canSeePhoneNumbers() {
    return CURRENT_USER?.role === 'admin' || 
           (CURRENT_USER?.permissions && CURRENT_USER.permissions.includes('view_phone'));
}

function updateUIBasedOnPermissions() {
    document.getElementById('tabEmployees').disabled = !hasPermission('manage_employees');
    document.getElementById('tabSettings').disabled = !hasPermission('manage_settings');
    document.getElementById('bookingFormCard').style.display = hasPermission('add') ? 'block' : 'none';
}

// ==================== دوال التبويبات ====================
function showMainTab(tabName) {
    document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
    
    document.getElementById('bookingsTab').classList.remove('hidden');
    document.getElementById('employeesTab').classList.add('hidden');
    document.getElementById('settingsTab').classList.add('hidden');
    
    if (tabName === 'employees' && hasPermission('manage_employees')) {
        document.getElementById('employeesTab').classList.remove('hidden');
        refreshEmployees();
    } else if (tabName === 'settings' && hasPermission('manage_settings')) {
        document.getElementById('settingsTab').classList.remove('hidden');
        loadSettings();
    }
}

// ==================== دوال التصفية ====================
function filterBookings(filter) {
    CURRENT_FILTER = filter;
    document.getElementById('filterAll').classList.remove('active');
    document.getElementById('filterActive').classList.remove('active');
    document.getElementById('filterCompleted').classList.remove('active');
    document.getElementById(`filter${filter.charAt(0).toUpperCase() + filter.slice(1)}`).classList.add('active');
    refreshBookings();
}

// ==================== دوال الحجوزات ====================
async function loadSettings() {
    try {
        const settings = await apiRequest('/settings');
        
        const eidStart = settings.eid_start || getDefaultEidDate(3);
        const eidEnd = settings.eid_end || getDefaultEidDate(7);
        
        document.getElementById('eidStartDate').value = eidStart;
        document.getElementById('eidEndDate').value = eidEnd;
        document.getElementById('workStart').value = settings.work_start || '09:00';
        document.getElementById('workEnd').value = settings.work_end || '23:00';
        
        populateDates(eidStart, eidEnd);
        
    } catch (error) {
        console.error('خطأ في تحميل الإعدادات:', error);
    }
}

function getDefaultEidDate(daysToAdd) {
    const date = new Date();
    date.setDate(date.getDate() + daysToAdd);
    return date.toISOString().split('T')[0];
}

function populateDates(startDate, endDate) {
    const dateSelect = document.getElementById('date');
    dateSelect.innerHTML = '<option value="">-- اختر التاريخ --</option>';
    
    const start = new Date(startDate);
    const end = new Date(endDate);
    
    for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
        const dateStr = d.toISOString().split('T')[0];
        const option = document.createElement('option');
        option.value = dateStr;
        option.textContent = d.toLocaleDateString('ar-EG', { 
            weekday: 'long', 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric' 
        });
        dateSelect.appendChild(option);
    }
}

function generateTimes() {
    const times = [];
    for (let hour = 9; hour <= 23; hour++) {
        times.push(`${hour.toString().padStart(2, '0')}:00`);
        times.push(`${hour.toString().padStart(2, '0')}:30`);
    }
    return times;
}

async function getAvailableTimes(selectedDate) {
    const allTimes = generateTimes();
    const appointments = await getAppointmentsFromAPI();
    
    const bookedTimes = appointments
        .filter(app => app.date === selectedDate && app.status === 'active')
        .map(app => app.time);
    
    return allTimes.filter(time => !bookedTimes.includes(time));
}

async function getAppointmentsFromAPI() {
    if (CURRENT_USER?.role === 'client' || !TOKEN) {
        const response = await fetch(`${API_URL}/api/appointments/public`);
        return await response.json();
    } else {
        return await apiRequest('/appointments');
    }
}

document.getElementById('date').addEventListener('change', async function() {
    const timeSelect = document.getElementById('time');
    timeSelect.innerHTML = '<option value="">-- اختر الوقت --</option>';
    
    if (!this.value) return;
    
    const availableTimes = await getAvailableTimes(this.value);
    
    if (availableTimes.length === 0) {
        const option = document.createElement('option');
        option.value = '';
        option.textContent = '-- لا توجد أوقات متاحة --';
        option.disabled = true;
        timeSelect.appendChild(option);
    } else {
        availableTimes.forEach(time => {
            const option = document.createElement('option');
            option.value = time;
            option.textContent = time;
            timeSelect.appendChild(option);
        });
    }
});

document.getElementById('bookingForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const name = document.getElementById('name').value;
    const phone = document.getElementById('phone').value;
    const date = document.getElementById('date').value;
    const time = document.getElementById('time').value;

    if (!name || !phone || !date || !time) {
        showMessage('bookingMessage', '❌ يرجى ملء جميع الحقول', 'error');
        return;
    }

    try {
        await apiRequest('/appointments', 'POST', {
            client_name: name,
            client_phone: phone,
            date,
            time
        });
        
        this.reset();
        document.getElementById('time').innerHTML = '<option value="">-- اختر الوقت --</option>';
        showMessage('bookingMessage', '✅ تم حجز الموعد بنجاح', 'success');
        refreshBookings();
        
    } catch (error) {
        showMessage('bookingMessage', '❌ ' + error.message, 'error');
    }
});

async function refreshBookings() {
    try {
        const appointments = await getAppointmentsFromAPI();
        
        appointments.sort((a, b) => {
            const nameCompare = (a.client_name || '').localeCompare(b.client_name || '', 'ar');
            if (nameCompare !== 0) return nameCompare;
            return a.date.localeCompare(b.date) || a.time.localeCompare(b.time);
        });

        document.getElementById('totalBookings').textContent = appointments.length;
        document.getElementById('completedCount').textContent = 
            appointments.filter(a => a.status === 'completed').length;

        let filtered = appointments;
        if (CURRENT_FILTER === 'active') {
            filtered = appointments.filter(a => a.status === 'active');
        } else if (CURRENT_FILTER === 'completed') {
            filtered = appointments.filter(a => a.status === 'completed');
        }

        const tableBody = document.getElementById('appointmentsTable');
        const canEdit = hasPermission('edit');
        const canDelete = hasPermission('delete');
        const canSeePhone = canSeePhoneNumbers();
        
        document.getElementById('actionsHeader').style.display = 
            (canEdit || canDelete) ? 'table-cell' : 'none';
        
        if (filtered.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="7">لا توجد حجوزات</td></tr>';
            document.getElementById('currentTurn').textContent = '-';
        } else {
            let html = '';
            filtered.forEach((app, index) => {
                const phoneDisplay = canSeePhone 
                    ? `<span class="phone-number">${app.client_phone || '05xxxxxxx'}</span>`
                    : `<span class="phone-hidden"><i class="fas fa-lock"></i> مخفي</span>`;
                
                const rowClass = app.status === 'completed' ? 'completed-row' : 
                                app.status === 'cancelled' ? 'cancelled-row' : '';
                
                html += `<tr class="${rowClass}">
                    <td><span class="queue-badge">${index + 1}</span></td>
                    <td>${app.client_name}</td>
                    <td>${phoneDisplay}</td>
                    <td>${app.date}</td>
                    <td>${app.time}</td>
                    <td><span class="status-badge status-${app.status}">${
                        app.status === 'active' ? 'نشط' : 
                        app.status === 'completed' ? 'مكتمل' : 'ملغي'
                    }</span></td>
                    <td>`;
                
                if (app.status === 'active') {
                    if (canEdit) {
                        html += `<button onclick="updateStatus('${app.id}', 'completed')" class="btn-small btn-success">مكتمل</button>`;
                    }
                    if (canDelete) {
                        html += `<button onclick="updateStatus('${app.id}', 'cancelled')" class="btn-small btn-danger">إلغاء</button>`;
                    }
                } else if (app.status === 'completed' && canEdit) {
                    html += `<button onclick="updateStatus('${app.id}', 'active')" class="btn-small btn-warning">إرجاع</button>`;
                }
                
                html += `</td></tr>`;
            });
            tableBody.innerHTML = html;
            
            const firstActive = appointments.find(a => a.status === 'active');
            document.getElementById('currentTurn').textContent = firstActive ? firstActive.client_name : '-';
        }
        
        document.getElementById('lastUpdate').textContent = new Date().toLocaleTimeString('ar-EG');
        
    } catch (error) {
        console.error('خطأ في تحديث الحجوزات:', error);
    }
}

async function updateStatus(id, status) {
    if (!hasPermission('edit')) {
        Swal.fire('خطأ', 'ليس لديك صلاحية', 'error');
        return;
    }
    
    const result = await Swal.fire({
        title: 'تأكيد',
        text: `هل أنت متأكد من ${status === 'completed' ? 'إكمال' : status === 'active' ? 'إرجاع' : 'إلغاء'} هذا الحجز؟`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'نعم',
        cancelButtonText: 'إلغاء'
    });

    if (result.isConfirmed) {
        try {
            await apiRequest(`/appointments/${id}`, 'PUT', { status });
            refreshBookings();
            Swal.fire('تم', 'تم تحديث الحجز', 'success');
        } catch (error) {
            Swal.fire('خطأ', error.message, 'error');
        }
    }
}

// ==================== دوال الموظفين ====================
document.getElementById('employeeForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const name = document.getElementById('empName').value;
    const username = document.getElementById('empUsernameField').value;
    const password = document.getElementById('empPasswordField').value;
    
    if (!name || !username || !password) {
        showMessage('employeeMessage', '❌ جميع الحقول مطلوبة', 'error');
        return;
    }
    
    const permissions = ['view'];
    if (document.getElementById('permAdd').checked) permissions.push('add');
    if (document.getElementById('permEdit').checked) permissions.push('edit');
    if (document.getElementById('permDelete').checked) permissions.push('delete');
    if (document.getElementById('permViewPhone').checked) permissions.push('view_phone');
    
    try {
        await apiRequest('/employees', 'POST', {
            full_name: name,
            username,
            password,
            permissions
        });
        
        this.reset();
        document.getElementById('permView').checked = true;
        Swal.fire('تم', 'تم إضافة الموظف', 'success');
        refreshEmployees();
        
    } catch (error) {
        showMessage('employeeMessage', '❌ ' + error.message, 'error');
    }
});

async function refreshEmployees() {
    try {
        const employees = await apiRequest('/employees');
        const tableBody = document.getElementById('employeesTable');
        
        if (employees.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="5">لا يوجد موظفين</td></tr>';
            return;
        }
        
        let html = '';
        employees.forEach(emp => {
            html += `<tr>
                <td>${emp.full_name}</td>
                <td>${emp.username}</td>
                <td>${emp.role === 'admin' ? 'مدير' : 'موظف'}</td>
                <td><span class="status-badge status-${emp.status}">${emp.status === 'active' ? 'نشط' : 'غير نشط'}</span></td>
                <td>
                    <button onclick="toggleEmployeeStatus('${emp.id}', '${emp.status}')" class="btn-small btn-warning">
                        ${emp.status === 'active' ? 'تعطيل' : 'تفعيل'}
                    </button>
                    <button onclick="deleteEmployee('${emp.id}')" class="btn-small btn-danger">حذف</button>
                </td>
            </tr>`;
        });
        tableBody.innerHTML = html;
        
    } catch (error) {
        console.error('خطأ في جلب الموظفين:', error);
    }
}

async function toggleEmployeeStatus(id, currentStatus) {
    const newStatus = currentStatus === 'active' ? 'inactive' : 'active';
    
    try {
        await apiRequest(`/employees/${id}/status`, 'PUT', { status: newStatus });
        refreshEmployees();
        Swal.fire('تم', 'تم تغيير حالة الموظف', 'success');
    } catch (error) {
        Swal.fire('خطأ', error.message, 'error');
    }
}

async function deleteEmployee(id) {
    const result = await Swal.fire({
        title: 'تأكيد الحذف',
        text: 'هل أنت متأكد؟',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'نعم',
        cancelButtonText: 'إلغاء'
    });

    if (result.isConfirmed) {
        try {
            await apiRequest(`/employees/${id}`, 'DELETE');
            refreshEmployees();
            Swal.fire('تم', 'تم حذف الموظف', 'success');
        } catch (error) {
            Swal.fire('خطأ', error.message, 'error');
        }
    }
}

// ==================== دوال الإعدادات ====================
async function saveSettings() {
    try {
        await apiRequest('/settings', 'PUT', {
            eid_start: document.getElementById('eidStartDate').value,
            eid_end: document.getElementById('eidEndDate').value
        });
        Swal.fire('تم', 'تم حفظ الإعدادات', 'success');
        loadSettings();
    } catch (error) {
        Swal.fire('خطأ', error.message, 'error');
    }
}

async function saveWorkSettings() {
    try {
        await apiRequest('/settings', 'PUT', {
            work_start: document.getElementById('workStart').value,
            work_end: document.getElementById('workEnd').value
        });
        Swal.fire('تم', 'تم حفظ أوقات العمل', 'success');
    } catch (error) {
        Swal.fire('خطأ', error.message, 'error');
    }
}

// ==================== دوال مساعدة ====================
function showMessage(elementId, text, type) {
    const element = document.getElementById(elementId);
    element.textContent = text;
    element.className = `message ${type}`;
    setTimeout(() => {
        element.textContent = '';
        element.className = 'message';
    }, 3000);
}

// ==================== التهيئة ====================
async function loadInitialData() {
    await loadSettings();
    await refreshBookings();
    await refreshEmployees();
    
    if (UPDATE_INTERVAL) {
        clearInterval(UPDATE_INTERVAL);
    }
    UPDATE_INTERVAL = setInterval(refreshBookings, 10000);
}

// التحقق من وجود توكن عند التحميل
window.addEventListener('load', async () => {
    document.getElementById('lastUpdate').textContent = new Date().toLocaleTimeString('ar-EG');
    
    if (TOKEN) {
        try {
            const user = await apiRequest('/auth/me');
            CURRENT_USER = user;
            showMainContent();
            updateUIBasedOnPermissions();
            showMainTab('bookings');
            await loadInitialData();
        } catch (error) {
            localStorage.removeItem('token');
        }
    }
});