<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的收藏</title>
    <link rel="icon" href="/realtor/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="/realtor/favicon.ico" type="image/x-icon">
    <script src="../js/vue.global.js"></script>
    <script src="../js/axios.min.js"></script>
    <script src="../js/api.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #E0E5EC; min-height: 100vh; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .navbar { background: #E0E5EC; box-shadow: 0 4px 16px rgb(163,177,198,0.4); padding: 15px 0; }
        .navbar-brand { font-size: 20px; font-weight: 700; color: #3D4852 !important; }
        .btn-back { font-size: 28px; cursor: pointer; color: #6B7280; transition: color 0.2s; background: none; border: none; }
        .btn-back:hover { color: #3D4852; }
        .avatar-circle {
            width: 45px; height: 45px; border-radius: 50%; overflow: hidden;
            background: linear-gradient(135deg, #6C63FF 0%, #8B84FF 100%);
            cursor: pointer; border: 3px solid #E0E5EC;
            box-shadow: 5px 5px 10px rgb(163,177,198,0.6), -5px -5px 10px rgba(255,255,255,0.5);
            display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 18px;
            transition: transform 0.2s, box-shadow 0.3s;
        }
        .avatar-circle img { width: 100%; height: 100%; object-fit: cover; }
        .avatar-circle:hover { transform: scale(1.05); box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5); }
        .user-name { color: #3D4852; font-weight: 600; margin-right: 15px; }
        .page-title { font-size: 24px; font-weight: 700; color: #3D4852; margin-bottom: 30px; display: flex; align-items: center; gap: 10px; }
        .favorite-card {
            background: #E0E5EC; border-radius: 32px;
            box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
            padding: 20px; margin-bottom: 15px; transition: all 0.3s; cursor: pointer;
        }
        .favorite-card:hover { transform: translateY(-3px); box-shadow: 12px 12px 20px rgb(163,177,198,0.7), -12px -12px 20px rgba(255,255,255,0.6); }
        .favorite-title { font-size: 18px; font-weight: 700; color: #3D4852; margin-bottom: 8px; }
        .favorite-info { font-size: 14px; color: #6B7280; margin-bottom: 6px; }
        .favorite-price { color: #6C63FF; font-weight: 700; font-size: 20px; }
        .btn-remove {
            color: #6B7280; cursor: pointer; font-size: 20px; transition: color 0.2s;
            background: none; border: none;
        }
        .btn-remove:hover { color: #E53E3E; }
        .neumorphic-toast {
            position: fixed; bottom: 50px; left: 50%; transform: translateX(-50%) translateY(100px);
            padding: 15px 25px; background: #3D4852; color: white;
            border-radius: 16px; z-index: 2000; opacity: 0; transition: all 0.3s ease;
            font-size: 14px; box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
        }
        .neumorphic-toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
        /* 详情模态框 */
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
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
            border-radius: 50%; background: #E0E5EC; display: flex;
            align-items: center; justify-content: center; transition: all 0.2s;
            box-shadow: 4px 4px 8px rgb(163,177,198,0.5), -4px -4px 8px rgba(255,255,255,0.6);
        }
        .close-btn:hover { box-shadow: inset 4px 4px 8px rgb(163,177,198,0.5), inset -4px -4px 8px rgba(255,255,255,0.6); }
    </style>
</head>
<body>
    <!-- ========== Vue 根元素 ========== -->
    <div id="app">
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container">
                <div class="d-flex align-items-center gap-3">
                    <span class="btn-back" @click="goBack">⬅️</span>
                    <a class="navbar-brand" href="home.jsp">🏠 MC Realtor</a>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="user-name">{{ user.username }}</span>
                    <!-- v-if/v-else 头像兜底，@error 图片加载失败时隐藏 -->
                    <div class="avatar-circle" @click="goToProfile">
                        <img v-if="user.avatar" :src="normalizeAvatar(user.avatar)" @error="e => { e.target.style.display='none'; }">
                        <span v-else>{{ getFirstChar(user.username) }}</span>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container" style="margin-top: 60px;">
            <div class="page-title">⭐ 我的收藏</div>

            <!-- v-if 列表为空时显示空状态 -->
            <div v-if="favorites.length === 0" class="text-center py-15">
                <div style="font-size: 60px; margin-bottom: 20px;">📭</div>
                <p style="color: #6B7280; font-size: 18px;">你还没有收藏哦~</p>
                <p style="color: #A0AEC0; font-size: 14px; margin-top: 10px;">快去看看自己喜欢的吧！</p>
            </div>

            <!-- ========== 收藏列表：v-for 遍历，@click 点击卡片打开详情 ========== -->
            <div v-for="property in favorites" :key="property.id" class="favorite-card" @click="openDetail(property)">
                <div class="d-flex align-items-start" style="gap: 16px;">
                    <!-- v-if/v-else 条件渲染图片或占位符 -->
                    <div v-if="property.imageUrl" style="flex-shrink:0;width:120px;height:90px;border-radius:16px;overflow:hidden;box-shadow:6px 6px 12px rgb(163,177,198,0.4),-3px -3px 8px rgba(255,255,255,0.6);">
                        <img :src="property.imageUrl" style="width:100%;height:100%;object-fit:cover;" @error="e => e.target.style.display='none'">
                    </div>
                    <div v-else style="flex-shrink:0;width:120px;height:90px;border-radius:16px;display:flex;align-items:center;justify-content:center;box-shadow:inset 4px 4px 8px rgb(163,177,198,0.4),inset -3px -3px 6px rgba(255,255,255,0.6);font-size:36px;">🏠</div>
                    <div style="flex: 1; min-width: 0;">
                        <div class="favorite-title">{{ property.title }}</div>
                        <div class="favorite-info">{{ property.type }} | {{ property.area }}㎡</div>
                        <div class="favorite-info">📍 {{ property.region }} - {{ property.address }}</div>
                        <div class="favorite-price mt-3">{{ property.price }}💎</div>
                    </div>
                    <!-- .stop 阻止冒泡，防止触发卡片点击打开详情 -->
                    <span class="btn-remove" @click.stop="removeFavorite(property.id)">🗑️</span>
                </div>
            </div>
        </div>

        <!-- Toast 通知 -->
        <div class="neumorphic-toast" :class="{show: showToast}">{{ toastMessage }}</div>

        <!-- ========== 详情模态框 ========== -->
        <div class="custom-modal" :class="{show: showDetail}">
            <div class="modal-content">
                <span class="close-btn" @click="closeDetail">×</span>
                <h4 class="mb-4" style="color:#3D4852;">{{ selected?.title }}</h4>
                <div v-if="selected">
                    <div v-if="selected.imageUrl" style="margin-bottom:16px;border-radius:20px;overflow:hidden;box-shadow:inset 4px 4px 8px rgb(163,177,198,0.5),inset -3px -3px 6px rgba(255,255,255,0.5);">
                        <img :src="selected.imageUrl" style="width:100%;max-height:280px;object-fit:cover;display:block;" @error="e => e.target.style.display='none'">
                    </div>
                    <p><strong>户型：</strong>{{ selected.type }}</p>
                    <p><strong>面积：</strong>{{ selected.area }} ㎡</p>
                    <p><strong>价格：</strong>{{ selected.price }} 💎</p>
                    <p><strong>区域：</strong>{{ selected.region }}</p>
                    <p><strong>地址：</strong>{{ selected.address }}</p>
                    <p><strong>描述：</strong>{{ selected.description }}</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        /* ========== Vue3 Composition API ========== */
        const { createApp, ref, reactive, onMounted, computed } = Vue;
        createApp({
            /* ========== setup() ========== */
            setup() {
                /* reactive() 用于 localStorage 反序列化用户对象，深响应式 */
                const user = reactive(JSON.parse(localStorage.getItem('user') || '{}'));
                /* ref() 用于数组/布尔等，浅响应式 */
                const favorites = ref([]);         // 收藏列表
                const showToast = ref(false);      // Toast 状态
                const toastMessage = ref('');       // Toast 内容
                const showDetail = ref(false);      // 详情模态框
                const selected = ref(null);        // 当前选中房源

                /* 头像首字母和路径处理 */
                const getFirstChar = (str) => str ? str.charAt(0) : '?';
                const normalizeAvatar = (avatar) => {
                    if (!avatar) return '';
                    if (avatar.startsWith('/realtor')) return avatar;
                    if (avatar.startsWith('/')) return '/realtor' + avatar;
                    return avatar;
                };

                /* 跳转方法 */
                const goBack = () => window.location.href = 'home.jsp';
                const goToProfile = () => window.location.href = 'profile.jsp';

                /* 房源详情模态框 */
                const openDetail = (property) => { selected.value = property; showDetail.value = true; };
                const closeDetail = () => { showDetail.value = false; selected.value = null; };

                /* 加载收藏列表 */
                const loadFavorites = async () => {
                    const data = await api.get('/favorite/list/' + user.id);
                    if (data.status === 'success') favorites.value = data.data;
                };

                /* 取消收藏：从列表移除 + 调用 API */
                const removeFavorite = async (propertyId) => {
                    await api.post('/favorite/remove', { userId: user.id, propertyId: propertyId });
                    /* filter 过滤掉被删除项，实现无刷新更新 */
                    favorites.value = favorites.value.filter(p => p.id !== propertyId);
                    showToastMsg('已取消收藏');
                };

                /* Toast 辅助函数 */
                const showToastMsg = (msg) => {
                    toastMessage.value = msg;
                    showToast.value = true;
                    setTimeout(() => { showToast.value = false; }, 3000);
                };

                /* 用到的唯一的钩子函数：onMounted：页面加载时获取收藏数据 */
                onMounted(() => { loadFavorites(); });

                /* 暴露给模板 */
                return { user, favorites, showToast, toastMessage, showDetail, selected,
                    getFirstChar, normalizeAvatar, removeFavorite, goBack, goToProfile,
                    openDetail, closeDetail, showToastMsg };
            }
        }).mount('#app');
    </script>
</body>
</html>
