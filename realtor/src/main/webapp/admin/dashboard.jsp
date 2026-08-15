<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员面板</title>
    <link rel="icon" href="/realtor/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="/realtor/favicon.ico" type="image/x-icon">
    <script src="../js/vue.global.js"></script>
    <script src="../js/axios.min.js"></script>
    <script src="../js/api.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #E0E5EC; min-height: 100vh; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .sidebar {
            min-height: 100vh;
            background: #E0E5EC;
            padding: 25px;
            position: fixed;
            width: 220px;
            left: 0;
            top: 0;
            box-shadow: 6px 0 16px rgb(163,177,198,0.4), -3px 0 10px rgba(255,255,255,0.3);
        }
        .sidebar-title { font-size: 20px; font-weight: 700; margin-bottom: 30px; display: flex; align-items: center; gap: 8px; color: #3D4852; }
        .sidebar-link {
            color: #6B7280; text-decoration: none; display: block;
            padding: 12px 15px; margin-bottom: 8px; border-radius: 16px;
            transition: all 0.3s; font-size: 15px; display: flex; align-items: center; gap: 10px;
            cursor: pointer; font-weight: 500;
            box-shadow: 3px 3px 6px rgb(163,177,198,0.3), -3px -3px 6px rgba(255,255,255,0.3);
        }
        .sidebar-link:hover { color: #3D4852; box-shadow: 5px 5px 10px rgb(163,177,198,0.4), -5px -5px 10px rgba(255,255,255,0.4); transform: translateY(-1px); }
        .sidebar-link.active {
            color: white; background: #6C63FF;
            box-shadow: inset 4px 4px 8px rgba(0,0,0,0.2), inset -4px -4px 8px rgba(255,255,255,0.1);
        }
        .sidebar-link.logout { margin-top: 50px; color: #6B7280; }
        .sidebar-link.logout:hover { color: #E53E3E; }
        .content { margin-left: 220px; padding: 30px; }
        .card {
            background: #E0E5EC; border-radius: 32px;
            box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
            padding: 25px;
        }
        .card-title { font-size: 20px; font-weight: 700; color: #3D4852; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .btn-add {
            background: #6C63FF;
            border: none; color: white; padding: 10px 20px;
            border-radius: 16px; font-weight: 600; transition: all 0.3s;
            cursor: pointer;
            box-shadow: 5px 5px 10px rgb(163,177,198,0.6), -5px -5px 10px rgba(255,255,255,0.5);
        }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 9px 9px 16px rgb(163,177,198,0.7), -9px -9px 16px rgba(255,255,255,0.6); }
        .btn-add:active { transform: translateY(1px); box-shadow: inset 4px 4px 8px rgba(0,0,0,0.15), inset -4px -4px 8px rgba(255,255,255,0.08); }
        .btn-edit { color: #6C63FF; cursor: pointer; font-size: 18px; transition: color 0.2s; border: none; background: none; padding: 4px; }
        .btn-edit:hover { color: #8B84FF; }
        .btn-delete { color: #E53E3E; cursor: pointer; font-size: 18px; transition: color 0.2s; border: none; background: none; padding: 4px; }
        .btn-delete:hover { color: #C53030; }
        .btn-approve {
            background: #38B2AC; border: none; color: white; padding: 8px 20px;
            border-radius: 16px; cursor: pointer; font-weight: 600;
            transition: all 0.3s; margin-right: 10px;
            box-shadow: 5px 5px 10px rgb(163,177,198,0.6), -5px -5px 10px rgba(255,255,255,0.5);
        }
        .btn-approve:hover { transform: translateY(-2px); box-shadow: 9px 9px 16px rgb(163,177,198,0.7), -9px -9px 16px rgba(255,255,255,0.6); }
        .btn-reject {
            background: #ED8936; border: none; color: white; padding: 8px 20px;
            border-radius: 16px; cursor: pointer; font-weight: 600;
            transition: all 0.3s;
            box-shadow: 5px 5px 10px rgb(163,177,198,0.6), -5px -5px 10px rgba(255,255,255,0.5);
        }
        .btn-reject:hover { transform: translateY(-2px); box-shadow: 9px 9px 16px rgb(163,177,198,0.7), -9px -9px 16px rgba(255,255,255,0.6); }
        .btn-search {
            background: #E0E5EC; border: none; border-radius: 16px; padding: 8px 15px;
            color: #6B7280; cursor: pointer;
            box-shadow: 3px 3px 6px rgb(163,177,198,0.5), -3px -3px 6px rgba(255,255,255,0.5);
        }
        .btn-search:hover { box-shadow: 5px 5px 10px rgb(163,177,198,0.6), -5px -5px 10px rgba(255,255,255,0.5); }
        .search-input {
            border: none; border-radius: 16px; padding: 10px 15px; font-size: 14px;
            background: #E0E5EC; color: #3D4852;
            box-shadow: inset 4px 4px 8px rgb(163,177,198,0.6), inset -4px -4px 8px rgba(255,255,255,0.5);
        }
        .search-input:focus { outline: none; box-shadow: inset 8px 8px 14px rgb(163,177,198,0.7), inset -8px -8px 14px rgba(255,255,255,0.6); }
        .custom-modal {
            display: none; position: fixed; top: 0; left: 0;
            width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5);
            justify-content: center; align-items: center; z-index: 1000;
            animation: fadeIn 0.2s ease;
        }
        .custom-modal.show { display: flex; }
        .modal-content {
            background: #E0E5EC; border-radius: 32px; padding: 30px;
            max-width: 550px; width: 90%; max-height: 90vh;
            overflow-y: auto; position: relative;
            box-shadow: 12px 12px 24px rgb(163,177,198,0.7), -12px -12px 24px rgba(255,255,255,0.7);
            animation: slideUp 0.3s ease;
            color: #3D4852;
            scrollbar-width: none;
            -ms-overflow-style: none;
        }
        .modal-content::-webkit-scrollbar {
            display: none;
        }
        .close-btn {
            position: absolute; top: 15px; right: 15px; font-size: 28px;
            cursor: pointer; color: #6B7280; width: 40px; height: 40px;
            display: flex; align-items: center; justify-content: center;
            border-radius: 50%; transition: all 0.2s;
            background: #E0E5EC; border: none;
            box-shadow: 3px 3px 6px rgb(163,177,198,0.6), -3px -3px 6px rgba(255,255,255,0.5);
        }
        .close-btn:hover { color: #3D4852; box-shadow: inset 3px 3px 6px rgb(163,177,198,0.6), inset -3px -3px 6px rgba(255,255,255,0.5); }
        .property-card {
            background: #E0E5EC; border-radius: 24px; padding: 20px;
            margin-bottom: 15px; transition: all 0.3s;
            box-shadow: 5px 5px 10px rgb(163,177,198,0.4), -5px -5px 10px rgba(255,255,255,0.4);
        }
        .property-card:hover { box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5); transform: translateY(-2px); }
        .property-title { font-size: 16px; font-weight: 700; color: #3D4852; margin-bottom: 8px; }
        .property-info { font-size: 14px; color: #6B7280; margin-bottom: 6px; }
        .status-released { color: #38B2AC; font-weight: 600; }
        .status-pending { color: #ED8936; font-weight: 600; }
        .table { background: #E0E5EC; border-radius: 16px; overflow: hidden; }
        .table th { font-weight: 600; color: #6B7280; border-bottom: none; padding: 14px; }
        .table td { color: #3D4852; border-bottom: none; padding: 14px; }
        .table tbody tr:hover { background: rgba(108, 99, 255, 0.05); }
        .form-control, .form-select {
            border: none; border-radius: 16px; padding: 10px 15px; font-size: 14px;
            background: #E0E5EC; color: #3D4852; width: 100%;
            box-shadow: inset 4px 4px 8px rgb(163,177,198,0.6), inset -4px -4px 8px rgba(255,255,255,0.5);
        }
        .form-control:focus, .form-select:focus { outline: none; box-shadow: inset 8px 8px 14px rgb(163,177,198,0.7), inset -8px -8px 14px rgba(255,255,255,0.6); }
        .form-label { font-weight: 600; color: #3D4852; margin-bottom: 5px; display: block; }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .neumorphic-toast {
            position: fixed; bottom: 50px; left: 50%; transform: translateX(-50%) translateY(100px);
            padding: 15px 25px; background: #3D4852; color: white;
            border-radius: 16px; z-index: 2000; opacity: 0; transition: all 0.3s ease;
            font-size: 14px; box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
        }
        .neumorphic-toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
    </style>
</head>
<body>
    <!-- ========== Vue 根元素 ========== -->
    <div id="app">
        <!-- ========== 侧边栏：@click 切换 Tab ========== -->
        <div class="sidebar">
            <div class="sidebar-title">🏠 管理面板</div>
            <!-- :class 动态绑定激活样式，@click 切换 Tab 并加载对应数据 -->
            <div class="sidebar-link" :class="{active: activeTab === 'users'}" @click="switchTab('users')">👥 用户管理</div>
            <div class="sidebar-link" :class="{active: activeTab === 'properties'}" @click="switchTab('properties')">🏢 房源管理</div>
            <div class="sidebar-link" :class="{active: activeTab === 'approval'}" @click="switchTab('approval')">✅ 审核发布</div>
            <div class="sidebar-link logout" @click="logout()">🚪 退出登录</div>
        </div>

        <div class="content">
            <div v-show="activeTab === 'users'">
                <div class="card">
                    <div class="card-title">👥 用户管理</div>
                    <div class="d-flex justify-between align-items-center mb-4">
                        <div class="input-group" style="width: 350px;">
                            <!-- v-model 绑定搜索词，@keyup.enter 回车触发搜索 -->
                            <input type="text" v-model="userSearch" class="search-input form-control" placeholder="搜索用户名/邮箱">
                            <button class="btn btn-search" @click="searchUsers()">🔍</button>
                        </div>
                    </div>
                    <table class="table">

                        <%--表头--%>
                        <thead>
                            <tr>
                                <th>头像</th><th>ID</th><th>用户名</th><th>邮箱</th><th>密码(加密)</th><th>角色</th><th>创建时间</th>
                            </tr>
                        </thead>

                        <tbody>
                            <!-- v-for 遍历用户列表，:key 唯一标识 -->
                            <tr v-for="user in users" :key="user.id">
                                <td>
                                    <!-- v-if/v-else 头像兜底 -->
                                    <div v-if="user.avatar" style="width:32px;height:32px;border-radius:50%;overflow:hidden;box-shadow:2px 2px 4px rgb(163,177,198,0.4),-2px -2px 4px rgba(255,255,255,0.5);">
                                        <img :src="normalizeAvatar(user.avatar)" @error="e => { e.target.style.display='none'; }" style="width:100%;height:100%;object-fit:cover;">
                                    </div>
                                    <div v-else style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#6C63FF,#8B84FF);display:flex;align-items:center;justify-content:center;color:white;font-size:13px;font-weight:600;">
                                        {{ user.username.charAt(0) }} <!--显示用户名首字-->
                                    </div>
                                </td>
                                <td>{{ user.id }}</td><td>{{ user.username }}</td><td>{{ user.email }}</td>
                                <td style="font-family: monospace; font-size: 12px; color: #A0AEC0;">{{ user.password }}</td>
                                <td>{{ user.role }}</td><td>{{ user.createdAt }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- ========== 房源管理 Tab ========== -->
            <div v-show="activeTab === 'properties'">
                <div class="card">
                    <div class="d-flex justify-between align-items-center mb-4" style="gap: 40px;">
                        <div class="card-title" style="flex-shrink: 0;">🏢 房源管理</div>
                        <div class="d-flex gap-3">
                            <div class="input-group" style="width: 350px;">
                                <input type="text" v-model="propertySearch" class="search-input form-control" placeholder="搜索房源">
                                <button class="btn btn-search" @click="searchProperties()">🔍</button>
                            </div>
                            <!-- @click 打开新增/编辑模态框 -->
                            <button class="btn btn-add" @click="openAddModal()">+ 新增房源</button>
                        </div>
                    </div>
                    <!-- v-for 渲染房源卡片，响应式列布局 -->
                    <div class="row">
                        <div v-for="property in properties" :key="property.id" class="col-md-6">
                            <div class="property-card">
                                <div class="d-flex justify-between align-start">
                                    <div style="flex: 1;">
                                        <h5 class="property-title">{{ property.title }}</h5>
                                        <p class="property-info">{{ property.type }} | {{ property.area }}㎡ | {{ property.price }}💎</p>
                                        <p class="property-info">📍 {{ property.region }} - {{ property.address }}</p>
                                        <p class="property-info" style="font-size: 13px; color: #A0AEC0;">{{ property.description }}</p>

                                        <span :class="property.status === 'released' ? 'status-released' : 'status-pending'" class="property-info">
                                            {{ property.status === 'released' ? '✓ 已发布' : '⏳ 待审核' }}
                                        </span>
                                    </div>
                                    <div class="text-right ml-4 d-flex gap-2">
                                        <button class="btn-edit" @click="editProperty(property)">✏️</button>
                                        <button class="btn-delete" @click="confirmDelete(property.id)">🗑️</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ========== 审核发布 Tab ========== -->
            <div v-show="activeTab === 'approval'">
                <div class="card">
                    <div class="card-title">✅ 审核发布</div>
                    <div class="row">
                        <div v-for="property in pendingProperties" :key="property.id" class="col-md-6">
                            <div class="property-card">
                                <h5 class="property-title">{{ property.title }}</h5>
                                <p class="property-info">{{ property.type }} | {{ property.area }}㎡ | {{ property.price }}💎</p>
                                <p class="property-info">📍 {{ property.region }} - {{ property.address }}</p>
                                <div class="mt-3">
                                    <button class="btn btn-approve" @click="approveProperty(property.id)">✓ 通过</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- v-if 列表为空时显示提示 -->
                    <div v-if="pendingProperties.length === 0" class="text-center py-10">
                        <p style="color: #6B7280;">暂无待审核房源</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== 新增/编辑房源模态框 ========== -->
        <div class="custom-modal" :class="{show: showAddModal}">
            <div class="modal-content">
                <span class="close-btn" @click="closeAddModal()">×</span>
                <h4 class="mb-4">{{ editingProperty ? '编辑房源' : '新增房源' }}</h4>
                <!-- v-model 双向绑定表单字段 -->
                <div class="mb-3"><label class="form-label">标题</label><input type="text" v-model="propertyForm.title" class="form-control"></div>
                <div class="mb-3"><label class="form-label">户型</label><input type="text" v-model="propertyForm.type" class="form-control" placeholder="如：三室两厅、写字楼"></div>
                <div class="mb-3"><label class="form-label">面积(㎡)</label><input type="number" v-model="propertyForm.area" class="form-control"></div>
                <div class="mb-3"><label class="form-label">价格(💎)</label><input type="number" v-model="propertyForm.price" class="form-control"></div>
                <div class="mb-3"><label class="form-label">区域</label><input type="text" v-model="propertyForm.region" class="form-control" placeholder="如：朝阳区、浦东新区"></div>
                <div class="mb-3"><label class="form-label">地址</label><input type="text" v-model="propertyForm.address" class="form-control"></div>
                <div class="mb-4"><label class="form-label">描述</label><textarea v-model="propertyForm.description" class="form-control" rows="3"></textarea></div>
                <!-- 文件上传：隐藏 input，label 触发选择，v-if 显示上传状态 -->
                <div class="mb-4">
                    <label class="form-label">预览图片</label>
                    <div class="d-flex gap-3 align-items-center">
                        <label class="btn btn-search" style="cursor:pointer;padding:10px 20px;margin:0;">📁 选择文件<input type="file" accept="image/*" style="display:none;" @change="handleImageUpload"></label>
                        <span v-if="uploading" style="color:#6B7280;font-size:13px;">上传中...</span>
                        <span v-else-if="propertyForm.imageUrl" style="color:#38B2AC;font-size:13px;">已上传</span>
                    </div>
                    <div v-if="propertyForm.imageUrl" style="margin-top:10px;max-width:200px;border-radius:16px;overflow:hidden;box-shadow:6px 6px 12px rgb(163,177,198,0.4),-3px -3px 8px rgba(255,255,255,0.6);">
                        <img :src="propertyForm.imageUrl" style="width:100%;display:block;">
                    </div>
                </div>
                <button class="btn btn-add w-100" @click="saveProperty()">{{ editingProperty ? '保存修改' : '添加房源' }}</button>
            </div>
        </div>

        <!-- ========== 删除确认模态框 ========== -->
        <div class="custom-modal" :class="{show: showDeleteModal}">
            <div class="modal-content">
                <h4 class="mb-3">确认删除</h4>
                <p style="color: #6B7280;">确定要删除这条房源吗？</p>
                <div class="d-flex gap-3 mt-4">
                    <button class="btn btn-add" style="background: #E53E3E;" @click="deleteProperty()">确认删除</button>
                    <button class="btn btn-search" style="padding: 12px 20px;" @click="closeDeleteModal()">取消</button>
                </div>
            </div>
        </div>

        <!-- Toast 通知 -->
        <div class="neumorphic-toast" :class="{show: showToast}">{{ toastMessage }}</div>
    </div>

    <script>
        const { createApp, ref, reactive, onMounted } = Vue;
        createApp({
            setup() {
                const activeTab = ref('users');
                const users = ref([]);
                const properties = ref([]);
                const pendingProperties = ref([]);
                const userSearch = ref('');
                const propertySearch = ref('');
                const showAddModal = ref(false);
                const showDeleteModal = ref(false);
                const editingProperty = ref(null);
                const deleteId = ref(null);
                const uploading = ref(false);
                const showToast = ref(false);
                const toastMessage = ref('');
                const propertyForm = reactive({ title: '', type: '', area: '', price: '', region: '', address: '', description: '', imageUrl: '' });
                const showToastMsg = (msg) => {
                    toastMessage.value = msg;
                    showToast.value = true;
                    setTimeout(() => { showToast.value = false; }, 3000);
                };

                const handleImageUpload = async (e) => {
                    const file = e.target.files[0];
                    if (!file) return;
                    uploading.value = true;
                    try {
                        const formData = new FormData();
                        formData.append('image', file);
                        const data = await api.post('/upload', formData);
                        if (data.status === 'success') {
                            propertyForm.imageUrl = data.url;
                        }
                    } catch (err) { console.error('上传失败'); }
                    finally { uploading.value = false; }
                };

                const normalizeAvatar = (avatar) => {
                        if (!avatar) return '';
                        if (avatar.startsWith('/realtor')) return avatar;
                        if (avatar.startsWith('/')) return '/realtor' + avatar;
                        return avatar;
                    };

                    const loadUsers = async () => {
                    try {

                        /*
                        这是一个看起来不起眼，但其实非常关键的函数！
                        当我们要查询时，大部分情况都是输入中文
                        但是，由于中文不能作为URL的一部分（否则可能出现解码失败）
                        我们必须先解码成安全字符，再拼接到URL中查询
                        */
                        const url = userSearch.value ? `/admin/users?keyword=${encodeURIComponent(userSearch.value)}` : '/admin/users';

                        const data = await api.get(url);
                        if (data.status === 'success') users.value = data.data;
                    } catch (e) { console.error('加载用户失败'); }
                };
                const loadProperties = async () => {
                    try {
                        const url = propertySearch.value ? `/property/search?keyword=${encodeURIComponent(propertySearch.value)}` : '/admin/properties';
                        const data = await api.get(url);
                        if (data.status === 'success') properties.value = data.data;
                    } catch (e) { console.error('加载房源失败'); }
                };
                const loadPendingProperties = async () => {
                    try {
                        const data = await api.get('/admin/pending');
                        if (data.status === 'success') pendingProperties.value = data.data;
                    } catch (e) { console.error('加载待审核房源失败'); }
                };
                const searchUsers = () => loadUsers();
                const searchProperties = () => loadProperties();
                const openAddModal = () => {
                    editingProperty.value = null;
                    propertyForm.title = ''; propertyForm.type = ''; propertyForm.area = '';
                    propertyForm.price = ''; propertyForm.region = ''; propertyForm.address = ''; propertyForm.description = ''; propertyForm.imageUrl = '';
                    showAddModal.value = true;
                };
                const closeAddModal = () => { showAddModal.value = false; editingProperty.value = null; };
                const editProperty = (property) => {
                    editingProperty.value = property;
                    propertyForm.title = property.title; propertyForm.type = property.type; propertyForm.area = property.area;
                    propertyForm.price = property.price; propertyForm.region = property.region; propertyForm.address = property.address;
                    propertyForm.description = property.description; propertyForm.imageUrl = property.imageUrl || '';
                    showAddModal.value = true;
                };
                const saveProperty = async () => {
                    try {
                        const dataObj = {
                            title: propertyForm.title, type: propertyForm.type,
                            area: propertyForm.area, price: propertyForm.price, region: propertyForm.region,
                            address: propertyForm.address, description: propertyForm.description,
                            imageUrl: propertyForm.imageUrl || ''
                        };
                        if (editingProperty.value) {
                            dataObj.id = editingProperty.value.id;
                            await api.post('/property/update', dataObj);
                            showToastMsg('房源修改成功');
                        } else {
                            await api.post('/property', dataObj);
                            showToastMsg('房源添加成功');
                        }
                        closeAddModal(); loadProperties(); loadPendingProperties();
                    } catch (e) { console.error('保存失败'); showToastMsg('保存失败'); }
                };
                const confirmDelete = (id) => { deleteId.value = id; showDeleteModal.value = true; };
                const closeDeleteModal = () => { showDeleteModal.value = false; deleteId.value = null; };
                const deleteProperty = async () => {
                    try {
                        await api.post('/property/delete', { id: deleteId.value });
                        closeDeleteModal(); loadProperties();
                        showToastMsg('房源删除成功');
                    } catch (e) { console.error('删除失败'); showToastMsg('删除失败'); }
                };
                const approveProperty = async (id) => {
                    try {
                        await api.post('/admin/approve', { id: id });
                        loadPendingProperties(); loadProperties();
                        showToastMsg('审核通过');
                    } catch (e) { console.error('审核失败'); showToastMsg('审核失败'); }
                };
                const rejectProperty = async (id) => {
                    if (!confirm('确定要拒绝该房源吗？')) return;
                    try {
                        await api.post('/admin/reject', { id: id });
                        loadPendingProperties();
                        showToastMsg('已拒绝');
                    } catch (e) { console.error('操作失败'); showToastMsg('操作失败'); }
                };

                // 切换用户跳转到注册登录界面
                const logout = () => { localStorage.removeItem('user'); window.location.href = '../index.jsp'; };

                const switchTab = (tab) => {
                    activeTab.value = tab;
                    if (tab === 'users') loadUsers();
                    else if (tab === 'properties') loadProperties();
                    else if (tab === 'approval') loadPendingProperties();
                };

                // 钩子函数（回调函数）
                onMounted(() => { loadUsers(); loadProperties(); loadPendingProperties(); });
                return {
                    activeTab, users, properties, pendingProperties, userSearch, propertySearch,
                    showAddModal, showDeleteModal, editingProperty, propertyForm, uploading,
                    showToast, toastMessage,
                    searchUsers, searchProperties, openAddModal, closeAddModal,
                    editProperty, saveProperty, confirmDelete, closeDeleteModal,
                    deleteProperty, approveProperty, rejectProperty, logout, switchTab,
                    handleImageUpload, normalizeAvatar, showToastMsg
                };
            }

        }).mount('#app');
    </script>
</body>
</html>
