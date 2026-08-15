<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MC Realtor - 用户首页</title>
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
        .navbar { background: #E0E5EC; box-shadow: 0 4px 16px rgb(163,177,198,0.4); padding: 15px 0; }
        .navbar-brand { font-size: 20px; font-weight: 700; color: #3D4852 !important; }
        .avatar-circle {
            width: 45px; height: 45px; border-radius: 50%; overflow: hidden;
            background: linear-gradient(135deg, #6C63FF 0%, #8B84FF 100%);
            cursor: pointer; border: 3px solid #E0E5EC;
            box-shadow: 5px 5px 10px rgb(163,177,198,0.6), -5px -5px 10px rgba(255,255,255,0.5);
            display: flex; align-items: center; justify-content: center;
            color: white; font-weight: 600; font-size: 18px;
            transition: transform 0.2s, box-shadow 0.3s;
        }
        .avatar-circle img { width: 100%; height: 100%; object-fit: cover; }
        .avatar-circle:hover { transform: scale(1.05); box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5); }
        .favorites-btn {
            background: linear-gradient(135deg, #6C63FF 0%, #8B84FF 100%);
            border: none; color: white; padding: 10px 20px;
            border-radius: 16px; font-weight: 600; cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 5px 5px 10px rgb(163,177,198,0.6), -5px -5px 10px rgba(255,255,255,0.5);
        }
        .favorites-btn:hover { transform: translateY(-2px); box-shadow: 9px 9px 16px rgb(163,177,198,0.7), -9px -9px 16px rgba(255,255,255,0.6); }
        .property-card {
            background: #E0E5EC; border-radius: 32px;
            box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
            overflow: hidden; transition: all 0.3s ease; cursor: pointer; position: relative;
        }
        .property-card:hover { transform: translateY(-3px); box-shadow: 12px 12px 20px rgb(163,177,198,0.7), -12px -12px 20px rgba(255,255,255,0.6); }
        .property-card-body { padding: 20px; }
        .property-card-image { width: 100%; height: 180px; overflow: hidden; }
        .property-card-image img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s ease; }
        .property-card:hover .property-card-image img { transform: scale(1.05); }
        .property-card-placeholder {
            width: 100%; height: 180px; display: flex; align-items: center; justify-content: center;
            box-shadow: inset 6px 6px 12px rgb(163,177,198,0.4), inset -4px -4px 8px rgba(255,255,255,0.5);
            background: #E0E5EC;
        }
        .property-title { font-size: 18px; font-weight: 700; color: #3D4852; margin-bottom: 10px; }
        .property-info { color: #6B7280; font-size: 14px; margin-bottom: 8px; }
        .property-price { color: #6C63FF; font-weight: 700; font-size: 20px; }
        .favorite-btn { font-size: 26px; cursor: pointer; transition: all 0.2s ease; position: absolute; top: 15px; right: 15px; }
        .favorite-btn:hover { transform: scale(1.1); }
        .favorite-btn.favorited { color: #ffc107; text-shadow: 0 0 10px rgba(255, 193, 7, 0.5); }
        .neumorphic-toast {
            position: fixed; bottom: 50px; left: 50%; transform: translateX(-50%) translateY(100px);
            padding: 15px 25px; background: #3D4852; color: white;
            border-radius: 16px; z-index: 2000; opacity: 0; transition: all 0.3s ease;
            font-size: 14px; box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
        }
        .neumorphic-toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
        .search-box { position: relative; }
        .search-box input { padding-right: 45px; }
        .search-btn { position: absolute; right: 8px; top: 50%; transform: translateY(-50%); color: #6B7280; border-radius: 25px; background: none; border: none; font-size: 18px; cursor: pointer; }
        .filter-select {
            border: none; border-radius: 16px;
            padding: 10px 15px; background: #E0E5EC; cursor: pointer;
            box-shadow: inset 4px 4px 8px rgb(163,177,198,0.6), inset -4px -4px 8px rgba(255,255,255,0.5);
            color: #3D4852; font-size: 14px;
        }
        .filter-select:focus { outline: none; box-shadow: inset 8px 8px 14px rgb(163,177,198,0.7), inset -8px -8px 14px rgba(255,255,255,0.6); }
        input.form-control {
            border: none; border-radius: 16px;
            padding: 10px 15px; background: #E0E5EC;
            box-shadow: inset 4px 4px 8px rgb(163,177,198,0.6), inset -4px -4px 8px rgba(255,255,255,0.5);
            color: #3D4852; font-size: 14px;
        }
        input.form-control:focus { outline: none; box-shadow: inset 8px 8px 14px rgb(163,177,198,0.7), inset -8px -8px 14px rgba(255,255,255,0.6); }
        .custom-modal {
            display: none; position: fixed; top: 0; left: 0;
            width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5);
            justify-content: center; align-items: center; z-index: 1000;
            animation: fadeIn 0.2s ease;
        }
        .custom-modal.show { display: flex; }
        .modal-content {
            background: #E0E5EC; border-radius: 32px; padding: 30px;
            max-width: 600px; width: 90%; max-height: 80vh;
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
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
    <!-- ========== Vue 根元素 ========== -->
    <div id="app">
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container">
                <a class="navbar-brand" href="home.jsp">🏠 MC Realtor</a>
                <div class="d-flex align-items-center gap-4">
                    <button class="favorites-btn" @click="goToFavorites">收藏夹</button>

                    <!-- v-if/v-else 条件渲染头像：有时显示图片，无时显示用户名首字 -->
                    <div class="avatar-circle" @click="goToProfile">

                        <%--这里的错误处理，非常巧妙地使用e.target获取到发生错误的头像元素，并隐藏该头像--%>
                        <img v-if="user.avatar" :src="normalizeAvatar(user.avatar)" @error="e => { e.target.style.display='none'; }">

                        <span v-else>{{ getFirstChar(user.username) }}</span>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container" style="margin-top: 60px;">
            <!-- ========== 筛选栏：v-model 双向绑定筛选条件，@change 条件变化时自动筛选 ========== -->
            <div class="row mb-4">
                <div class="col-md-3">

                    <!-- v-for 动态渲染下拉选项，:value 绑定实际值，显示文本用选项本身 -->
                    <%--简单来说，一旦检测到数据发生改变，调用applyfilters方法，这个方法声明在下面--%>
                    <select v-model="filters.type" class="filter-select w-100" @change="applyFilters">
                        <option value="">全部户型</option>
                        <option v-for="type in types" :key="type" :value="type">{{ type }}</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select v-model="filters.region" class="filter-select w-100" @change="applyFilters">
                        <option value="">全部区域</option>
                        <option v-for="region in regions" :key="region" :value="region">{{ region }}</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <input type="number" v-model="filters.minPrice" class="form-control filter-select" placeholder="最低价格(💎)" @change="applyFilters">
                </div>
                <div class="col-md-3">
                    <input type="number" v-model="filters.maxPrice" class="form-control filter-select" placeholder="最高价格(💎)" @change="applyFilters">
                </div>
            </div>

            <!-- ========== 搜索框：@keyup.enter 回车触发搜索 ========== -->
            <div class="mb-4 search-box">
                <input type="text" v-model="searchKeyword" class="form-control" placeholder="搜索房源..." @keyup.enter="searchProperties">
                <button class="search-btn" @click="searchProperties">🔍</button>
            </div>

            <!-- ========== 房源卡片列表：v-for 遍历渲染 ========== -->
            <div class="row">
                <div
                    v-for="property in properties"
                    :key="property.id"
                    class="col-lg-4 col-md-6 mb-4"
                    @click="openPropertyModal(property)"
                >
                    <div class="property-card">
                        <!-- v-if/v-else 根据是否有图片决定渲染图片还是占位符 -->
                        <div v-if="property.imageUrl" class="property-card-image">
                            <img :src="property.imageUrl" style="width:100%;height:180px;object-fit:cover;display:block;" @error="e => e.target.style.display='none'">
                        </div>
                        <div v-else class="property-card-placeholder">
                            <span style="font-size:40px;">🏠</span>
                        </div>
                        <div class="property-card-body">
                            <div class="d-flex justify-between align-start mb-3">
                                <h5 class="property-title">{{ property.title }}</h5>

                                <!--
                                :class 动态绑定收藏状态样式，.stop 阻止事件冒泡

                                事件冒泡也是vue中一个很巧妙的设计
                                具体来说，大组件中如果包含小组件，
                                为了不让我们点击（或者说触发）小组件时以外触发大组件（即事件冒泡），
                                就需要使用.stop来阻止
                                -->
                                <span class="favorite-btn" :class="{ favorited: isFavorite(property.id) }" @click.stop="toggleFavorite(property.id)">
                                    <!--若收藏则显示实心⭐，否则显示空心☆-->
                                    {{ isFavorite(property.id) ? '⭐' : '☆' }}
                                </span>

                            </div>
                            <p class="property-info">{{ property.type }} | {{ property.area }}㎡</p>
                            <p class="property-info">📍 {{ property.region }} - {{ property.address }}</p>
                            <p class="property-info text-muted" style="font-size: 13px; line-height: 1.5;">{{ property.description }}</p>
                            <div class="property-price mt-3">{{ property.price }}💎</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- v-if 列表为空时显示提示 -->
            <div v-if="properties.length === 0" class="text-center py-10">
                <p style="color: #6B7280;">暂无房源数据</p>
            </div>
        </div>

        <!-- ========== Toast 通知 ========== -->
        <div class="neumorphic-toast" :class="{show: showToast}">{{ toastMessage }}</div>

        <!-- ========== 详情模态框：:class 动态控制显示/隐藏 ========== -->
        <div class="custom-modal" :class="{show: showPropertyModal}">
            <div class="modal-content">
                <span class="close-btn" @click="closePropertyModal">×</span>
                <!-- 可选链操作符 ?. 防止 selectedProperty 为 null 时报错 -->
                <h4 class="mb-4" style="color: #3D4852;">{{ selectedProperty?.title }}</h4>
                <div v-if="selectedProperty">
                    <div v-if="selectedProperty.imageUrl" style="margin-bottom: 16px; border-radius: 20px; overflow: hidden; box-shadow: inset 4px 4px 8px rgb(163,177,198,0.5), inset -3px -3px 6px rgba(255,255,255,0.5);">
                        <img :src="selectedProperty.imageUrl" style="width:100%;max-height:280px;object-fit:cover;display:block;" @error="e => e.target.style.display='none'">
                    </div>
                    <p><strong>户型：</strong>{{ selectedProperty.type }}</p>
                    <p><strong>面积：</strong>{{ selectedProperty.area }} ㎡</p>
                    <p><strong>价格：</strong>{{ selectedProperty.price }} 💎</p>
                    <p><strong>区域：</strong>{{ selectedProperty.region }}</p>
                    <p><strong>地址：</strong>{{ selectedProperty.address }}</p>
                    <p><strong>描述：</strong>{{ selectedProperty.description }}</p>
                    <p><strong>状态：</strong>{{ selectedProperty.status === 'released' ? '已发布' : '待审核' }}</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        /* ========== Vue3 Composition API ========== */
        const { createApp, ref, reactive, onMounted, computed } = Vue;
        createApp({
            /* ========== setup() = 所有响应式状态和业务逻辑 ========== */
            setup() {
                const user = reactive(JSON.parse(localStorage.getItem('user') || '{}'));
                    const properties = ref([]);              // 房源列表
                const favoriteIds = ref([]);             // 当前用户收藏的房源 ID 列表
                const showToast = ref(false);            // Toast 显示状态
                const toastMessage = ref('');             // Toast 消息内容
                const searchKeyword = ref('');            // 搜索关键词
                const showPropertyModal = ref(false);     // 详情模态框是否显示
                const selectedProperty = ref(null);      // 当前选中的房源对象
                const types = ref([]);                   // 户型列表（动态从 API 获取）
                const regions = ref([]);                  // 区域列表（动态从 API 获取）

                /* reactive() 深响应式：适合批量管理表单字段 */
                const filters = reactive({ type: '', region: '', minPrice: '', maxPrice: '' });

                /* 计算属性 computed：根据 favoriteIds 判断某房源是否已收藏 */
                const isFavorite = (propertyId) => favoriteIds.value.includes(propertyId);

                /* 头像首字母和路径处理 */
                const getFirstChar = (str) => str ? str.charAt(0) : '?';
                const normalizeAvatar = (avatar) => {
                    if (!avatar) return '';
                    if (avatar.startsWith('/realtor')) return avatar;
                    if (avatar.startsWith('/')) return '/realtor' + avatar;
                    return avatar;
                };

                /* 跳转方法 */
                const goToProfile = () => window.location.href = 'profile.jsp';
                const goToFavorites = () => window.location.href = 'favorites.jsp';

                /* 房源详情模态框 */
                const openPropertyModal = (property) => {
                    selectedProperty.value = property;
                    showPropertyModal.value = true;
                };
                const closePropertyModal = () => {
                    showPropertyModal.value = false;
                    selectedProperty.value = null;
                };

                /* ========== 数据加载函数 ========== */
                const loadProperties = async () => {
                    const data = await api.get('/property');
                    if (data.status === 'success') properties.value = data.data;
                };
                const loadTypes = async () => {
                    const data = await api.get('/property/types');
                    if (data.status === 'success') types.value = data.data;
                };
                const loadRegions = async () => {
                    const data = await api.get('/property/regions');
                    if (data.status === 'success') regions.value = data.data;
                };
                const loadFavorites = async () => {
                    if (!user.id) return;
                    const data = await api.get('/favorite/list/' + user.id);
                    if (data.status === 'success') {
                        /* 从收藏列表提取 ID 数组，用于快速判断 */
                        favoriteIds.value = data.data.map(p => p.id);
                    }
                };

                /* 切换收藏状态：已收藏则取消，未收藏则添加 */
                const toggleFavorite = async (propertyId) => {
                    if (!user.id) { showToastMsg('请先登录'); return; }
                    if (isFavorite(propertyId)) {
                        await api.post('/favorite/remove', { userId: user.id, propertyId: propertyId });
                        favoriteIds.value = favoriteIds.value.filter(id => id !== propertyId); // 移除
                        showToastMsg('已取消收藏');
                    } else {
                        await api.post('/favorite/add', { userId: user.id, propertyId: propertyId });
                        favoriteIds.value.push(propertyId); // 添加
                        showToastMsg('已收藏');
                    }
                };

                /* 关键词搜索 */
                const searchProperties = async () => {
                    if (!searchKeyword.value) { loadProperties(); return; }
                    const data = await api.get('/property/search', { keyword: searchKeyword.value });
                    if (data.status === 'success') properties.value = data.data;
                };

                /* 在这里！刚才提到的动态过滤方法 */
                const applyFilters = async () => {
                    const filterObj = {};
                    if (filters.type) filterObj.type = filters.type;
                    if (filters.region) filterObj.region = filters.region;
                    if (filters.minPrice) filterObj.minPrice = filters.minPrice;
                    if (filters.maxPrice) filterObj.maxPrice = filters.maxPrice;

                    // 通过api层，向对应的servlet发送get请求
                    const data = await api.get('/property/filter', filterObj);
                    if (data.status === 'success') properties.value = data.data;
                };

                /* Toast 通知：3秒自动隐藏 */
                const showToastMsg = (msg) => {
                    toastMessage.value = msg;
                    showToast.value = true;
                    setTimeout(() => { showToast.value = false; }, 3000);
                };

                /* ========== 钩子函数 ========== */
                onMounted(() => {
                    /* 页面加载时：加载所有数据 */
                    loadProperties();
                    loadFavorites();
                    loadTypes();
                    loadRegions();
                    refreshUserInfo();
                });

                /* 刷新用户信息：从后端拉取最新数据并同步到 localStorage */
                const refreshUserInfo = async () => {
                    if (!user.id) return;
                    const data = await api.get('/user/info/' + user.id);
                    if (data.status === 'success') {
                        const d = data.data;
                        user.username = d.username;
                        user.email = d.email;
                        user.avatar = d.avatar || '';
                        user.role = d.role;
                        localStorage.setItem('user', JSON.stringify(user));
                    }
                };

                /* ========== 暴露给模板的变量和方法 ========== */
                return {
                    user, properties, favoriteIds, showToast, toastMessage,
                    searchKeyword, filters, showPropertyModal, selectedProperty,
                    types, regions,
                    getFirstChar, normalizeAvatar, isFavorite, toggleFavorite, searchProperties,
                    applyFilters, goToProfile, goToFavorites, openPropertyModal, closePropertyModal,
                    showToastMsg
                };
            }
        }).mount('#app'); // 挂载到 #app
    </script>
</body>
</html>
