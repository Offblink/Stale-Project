<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人主页</title>
    <link rel="icon" href="/realtor/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="/realtor/favicon.ico" type="image/x-icon">
    <script src="../js/vue.global.js"></script>
    <script src="../js/axios.min.js"></script>
    <script src="../js/api.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #E0E5EC; min-height: 100vh; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .container { padding-top: 40px; max-width: 600px; margin: 0 auto; }
        .btn-back { font-size: 28px; cursor: pointer; color: #6B7280; transition: color 0.2s; margin-bottom: 20px; border:none; background:none; }
        .btn-back:hover { color: #3D4852; }
        .card {
            background: #E0E5EC; border-radius: 32px;
            box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
            padding: 40px;
        }
        .avatar-wrapper {
            width: 130px; height: 130px; border-radius: 50%; overflow: hidden;
            background: linear-gradient(135deg, #6C63FF 0%, #8B84FF 100%);
            cursor: pointer; border: 4px solid #E0E5EC;
            box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
            display: flex; align-items: center; justify-content: center;
            color: white; font-size: 50px; font-weight: 700;
            transition: all 0.3s ease; margin: 0 auto; position: relative;
        }
        .avatar-wrapper img { width: 100%; height: 100%; object-fit: cover; }
        .avatar-wrapper:hover { transform: scale(1.03); box-shadow: 12px 12px 20px rgb(163,177,198,0.7), -12px -12px 20px rgba(255,255,255,0.6); }
        .avatar-wrapper .edit-hint {
            position: absolute; inset: 0; border-radius: 50%;
            background: rgba(0,0,0,0.35); display: flex; align-items: center; justify-content: center;
            opacity: 0; transition: opacity 0.3s; font-size: 14px; font-weight: 400;
        }
        .avatar-wrapper:hover .edit-hint { opacity: 1; }
        .section-title { font-size: 14px; color: #6B7280; margin-top: 25px; margin-bottom: 8px; font-weight: 600; }
        .form-control {
            border: none; border-radius: 16px; padding: 12px 15px; font-size: 15px;
            transition: all 0.3s; width: 100%;
            background: #E0E5EC; color: #3D4852;
            box-shadow: inset 6px 6px 10px rgb(163,177,198,0.6), inset -6px -6px 10px rgba(255,255,255,0.5);
        }
        .form-control:focus { outline: none; box-shadow: inset 10px 10px 20px rgb(163,177,198,0.7), inset -10px -10px 20px rgba(255,255,255,0.6); }
        .btn-primary {
            width: 100%; padding: 14px; background: #6C63FF; border: none; border-radius: 16px;
            color: white; font-size: 16px; font-weight: 600; transition: all 0.3s; cursor: pointer; margin-bottom: 10px;
            box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 12px 12px 20px rgb(163,177,198,0.7), -12px -12px 20px rgba(255,255,255,0.6); }
        .btn-primary:active { transform: translateY(1px); box-shadow: inset 6px 6px 10px rgba(0,0,0,0.15), inset -6px -6px 10px rgba(255,255,255,0.1); }
        .btn-secondary {
            width: 100%; padding: 14px; background: #E0E5EC; border: none; border-radius: 16px;
            color: #6B7280; font-size: 16px; font-weight: 500; cursor: pointer; margin-bottom: 10px;
            box-shadow: 5px 5px 10px rgb(163,177,198,0.6), -5px -5px 10px rgba(255,255,255,0.5);
            transition: all 0.3s;
        }
        .btn-secondary:hover { color: #3D4852; transform: translateY(-1px); box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5); }
        .btn-danger {
            width: 100%; padding: 14px; background: #E53E3E; border: none; border-radius: 16px;
            color: white; font-size: 16px; font-weight: 600; cursor: pointer;
            box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
            transition: all 0.3s;
        }
        .btn-danger:hover { transform: translateY(-2px); box-shadow: 12px 12px 20px rgb(163,177,198,0.7), -12px -12px 20px rgba(255,255,255,0.6); }
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); justify-content: center; align-items: center; z-index: 1000; }
        .modal-overlay.show { display: flex; }
        .modal-content {
            background: #E0E5EC; border-radius: 32px; padding: 30px;
            max-width: 500px; width: 90%; position: relative;
            box-shadow: 12px 12px 24px rgb(163,177,198,0.7), -12px -12px 24px rgba(255,255,255,0.7);
        }
        .close-btn {
            position: absolute; top: 15px; right: 15px; font-size: 28px;
            cursor: pointer; color: #6B7280; width: 40px; height: 40px;
            display: flex; align-items: center; justify-content: center;
            border-radius: 50%; transition: all 0.2s; border:none; background: #E0E5EC;
            box-shadow: 3px 3px 6px rgb(163,177,198,0.6), -3px -3px 6px rgba(255,255,255,0.5);
        }
        .close-btn:hover { color: #3D4852; box-shadow: inset 3px 3px 6px rgb(163,177,198,0.6), inset -3px -3px 6px rgba(255,255,255,0.5); }
        .neumorphic-toast {
            position: fixed; bottom: 50px; left: 50%; transform: translateX(-50%) translateY(100px);
            padding: 15px 25px; background: #3D4852; color: white;
            border-radius: 16px; z-index: 2000; opacity: 0; transition: all 0.3s ease;
            font-size: 14px; box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
        }
        .neumorphic-toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
        .alert { padding: 15px; border-radius: 16px; margin-top: 20px; font-size: 14px; border: none; }
        .alert-success { background: #38B2AC; color: white; box-shadow: inset 4px 4px 8px rgba(0,0,0,0.15), inset -4px -4px 8px rgba(255,255,255,0.1); }
        .alert-danger { background: #E53E3E; color: white; box-shadow: inset 4px 4px 8px rgba(0,0,0,0.15), inset -4px -4px 8px rgba(255,255,255,0.1); }
        .text-center { text-align: center; }
        .form-label { display: block; margin-bottom: 5px; font-weight: 600; color: #3D4852; }

        /* Crop modal */
        .crop-area { width: 280px; height: 280px; margin: 0 auto 20px; position: relative; cursor: grab; }
        .crop-area:active { cursor: grabbing; }
        .crop-area canvas { border-radius: 50%; display: block; }
        .crop-clip {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            border-radius: 50%; box-shadow: 0 0 0 2000px rgba(0,0,0,0.5);
            pointer-events: none;
        }
        .slider-wrapper { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; }
        .slider-wrapper span { color: #6B7280; font-size: 13px; font-weight: 600; }
        .slider-wrapper input[type=range] { flex: 1; accent-color: #6C63FF; }
        .crop-actions { display: flex; gap: 12px; }
        .crop-actions button { flex: 1; }
    </style>
</head>
<body>
    <!-- ========== Vue 根元素 ========== -->
    <div id="app" class="container">
        <!-- Toast 通知 -->
        <div class="neumorphic-toast" :class="{show: showToast}">{{ toastMessage }}</div>
        <button class="btn-back" @click="goBack">⬅️ 返回</button>

        <div class="card">
            <div class="text-center">
                <!-- 头像点击触发文件选择，v-if/v-else 显示头像或首字母 -->
                <div class="avatar-wrapper" @click="triggerFileInput">
                    <img v-if="user.avatar" :src="avatarUrl" :key="avatarKey">
                    <span v-else>{{ getFirstChar(user.username) }}</span>
                    <div class="edit-hint">📷 编辑</div>
                </div>

                <%-- 这实质上是一个隐藏的文件输入框，当鼠标悬停在上面时显示提示信息，点击后直接打开“选择文件”窗口--%>
                <input type="file" ref="fileInput" accept="image/*" style="display:none" @change="onFileSelected">

            </div>
            <!-- v-model 双向绑定表单 -->
            <div class="section-title">用户名</div>
            <input type="text" v-model="editForm.username" class="form-control">
            <div class="section-title">邮箱</div>
            <input type="email" v-model="editForm.email" class="form-control">
            <div style="margin-top: 30px;">
                <button class="btn-primary" @click="updateProfile">保存修改</button>
                <button class="btn-secondary" @click="openPasswordModal">修改密码</button>
                <button class="btn-danger" @click="logout">切换用户</button>
            </div>
        </div>

        <!-- ========== 头像裁剪模态框 ========== -->

        <!--
        .self 修饰符：只有点击遮罩层本身才关闭，点击内容区不关闭
        类似的修饰符还有许多，之前见到的.stop（阻止事件冒泡）就是一类
        还有下面的.prevent，用来阻止默认行为
        -->
        <div class="modal-overlay" :class="{show: showCropModal}">
            <div class="modal-content">
                <button class="close-btn" @click="closeCropModal">×</button>

                <!-- 裁剪画布：绑定拖拽和触摸事件 -->
                <div class="crop-area"
                    @mousedown="startDrag" @mousemove="onDrag" @mouseup="endDrag" @mouseleave="endDrag"
                    @touchstart.prevent="startDrag" @touchmove.prevent="onDrag" @touchend="endDrag">

                    <!-- ref="cropCanvas" 获取 Canvas DOM 元素用于绘制 -->
                    <canvas ref="cropCanvas" width="280" height="280" style="border-radius:50%;"></canvas>

                </div>

                <!-- 缩放滑块：:value 单向绑定，@input 监听变化 -->
                <div class="slider-wrapper">
                    <span>🔍</span>
                    <input type="range" min="50" max="300" :value="cropScale" @input="setScale">
                    <span>🔍+</span>
                </div>

                <div class="crop-actions">
                    <button class="btn-secondary" @click="closeCropModal">取消</button>
                    <button class="btn-primary" style="margin-bottom:0;" @click="confirmCrop" :disabled="cropLoading">
                        {{ cropLoading ? '上传中...' : '确认' }}
                    </button>
                </div>
            </div>
        </div>

        <!-- ========== 修改密码模态框 ========== -->
        <div class="modal-overlay" :class="{show: showPasswordModal}" @click.self="closePasswordModal">
            <div class="modal-content">
                <button class="close-btn" @click="closePasswordModal">×</button>
                <h4 style="margin-bottom: 20px; color: #3D4852;">修改密码</h4>
                <div style="margin-bottom:15px;">
                    <label class="form-label">原密码</label>
                    <input type="password" v-model="passwordForm.oldPassword" class="form-control">
                </div>
                <div style="margin-bottom:15px;">
                    <label class="form-label">新密码</label>
                    <input type="password" v-model="passwordForm.newPassword" class="form-control">
                </div>
                <div style="margin-bottom:15px;">
                    <label class="form-label">确认新密码</label>
                    <input type="password" v-model="passwordForm.confirmPassword" class="form-control">
                </div>
                <button class="btn-primary" @click="updatePassword">确认修改</button>
            </div>
        </div>
    </div>

    <script>
        const { createApp, ref, reactive, onMounted, nextTick, computed } = Vue;
        createApp({
            setup() {
                const user = reactive(JSON.parse(localStorage.getItem('user') || '{}'));
                const editForm = reactive({ username: '', email: '' });
                const passwordForm = reactive({ oldPassword: '', newPassword: '', confirmPassword: '' });
                const showPasswordModal = ref(false);
                const showToast = ref(false);
                const toastMessage = ref('');
                const avatarKey = ref(0);

                /* 头像裁剪属性 */
                const fileInput = ref(null);
                const cropCanvas = ref(null);
                const showCropModal = ref(false);
                const cropLoading = ref(false);
                const cropScale = ref(100);
                let cropImage = null;
                let cropX = 0, cropY = 0;
                let dragStartX = 0, dragStartY = 0;
                let dragOrigX = 0, dragOrigY = 0;
                let isDragging = false;

                const getFirstChar = (str) => str ? str.charAt(0) : '?';
                const normalizeAvatar = (avatar) => {
                    if (!avatar) return '';
                    if (avatar.startsWith('/realtor')) return avatar;
                    if (avatar.startsWith('/')) return '/realtor' + avatar;
                    return avatar;
                };
                const avatarUrl = computed(() => user.avatar ? (normalizeAvatar(user.avatar) + '?k=' + avatarKey.value) : '');

                const loadUserInfo = async () => {
                    try {
                        const data = await api.get('/user/info/' + user.id);
                        if (data.status === 'success') {
                            const d = data.data;
                            user.username = d.username;
                            user.email = d.email;
                            user.avatar = d.avatar || '';
                            editForm.username = d.username;
                            editForm.email = d.email;
                            localStorage.setItem('user', JSON.stringify(user));
                            avatarKey.value++;
                        }
                    } catch (e) {}
                };

                const triggerFileInput = () => {
                    fileInput.value.value = '';
                    fileInput.value.click();
                };

                const onFileSelected = async (e) => {
                    const file = e.target.files[0];
                    if (!file) return;
                    const reader = new FileReader();
                    reader.onload = (ev) => {
                        cropImage = new Image();
                        cropImage.onload = () => {
                            cropScale.value = 100;
                            cropX = 0; cropY = 0;
                            showCropModal.value = true;
                            nextTick(() => drawCrop());
                        };
                        cropImage.src = ev.target.result;
                    };
                    reader.readAsDataURL(file);
                };

                const drawCrop = () => {
                    const canvas = cropCanvas.value;
                    if (!canvas || !cropImage) return;
                    const ctx = canvas.getContext('2d');
                    const size = 280;
                    const scale = cropScale.value / 100;
                    ctx.clearRect(0, 0, size, size);
                    ctx.save();
                    ctx.beginPath();
                    ctx.arc(size / 2, size / 2, size / 2, 0, Math.PI * 2);
                    ctx.clip();
                    const iw = cropImage.width * scale;
                    const ih = cropImage.height * scale;
                    const dx = (size - iw) / 2 + cropX;
                    const dy = (size - ih) / 2 + cropY;
                    ctx.drawImage(cropImage, dx, dy, iw, ih);
                    ctx.restore();
                };

                const setScale = (e) => {
                    cropScale.value = parseInt(e.target.value);
                    drawCrop();
                };

                const startDrag = (e) => {
                    isDragging = true;
                    const pt = e.touches ? e.touches[0] : e;
                    dragStartX = pt.clientX;
                    dragStartY = pt.clientY;
                    dragOrigX = cropX;
                    dragOrigY = cropY;
                };

                const onDrag = (e) => {
                    if (!isDragging) return;
                    const pt = e.touches ? e.touches[0] : e;
                    cropX = dragOrigX + (pt.clientX - dragStartX);
                    cropY = dragOrigY + (pt.clientY - dragStartY);
                    drawCrop();
                };

                const endDrag = () => { isDragging = false; };

                const confirmCrop = async () => {
                    if (cropLoading.value) return;
                    cropLoading.value = true;
                    try {
                        const canvas = cropCanvas.value;
                        const outCanvas = document.createElement('canvas');
                        outCanvas.width = 280; outCanvas.height = 280;
                        const octx = outCanvas.getContext('2d');
                        octx.beginPath();
                        octx.arc(140, 140, 140, 0, Math.PI * 2);
                        octx.clip();
                        octx.drawImage(canvas, 0, 0);

                        const blob = await new Promise(res => outCanvas.toBlob(res, 'image/png'));
                        const formData = new FormData();
                        formData.append('avatar', blob, 'avatar.png');
                        formData.append('userId', user.id);

                        const resp = await api.post('/user/updateAvatar', formData);
                        if (resp && resp.status === 'success') {
                            const newAvatar = resp.avatar;
                            user.avatar = newAvatar;
                            avatarKey.value++;

                            localStorage.setItem('user', JSON.stringify({
                                id: user.id, username: user.username, email: user.email,
                                avatar: newAvatar, role: user.role
                            }));
                            toast('头像更新成功');
                            showCropModal.value = false;
                        } else {
                            toast((resp && resp.message) || '上传失败');
                        }
                    } catch (e) {
                        console.error('头像上传失败', e);
                        toast('上传失败');
                    } finally {
                        cropLoading.value = false;
                    }
                };

                const closeCropModal = () => {
                    showCropModal.value = false;
                    cropImage = null;
                };

                const updateProfile = async () => {
                    // 邮箱格式验证
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(editForm.email)) {
                        toast('请输入正确的邮箱格式');
                        return;
                    }
                    try {
                        const resp = await api.post('/user/update', {
                            id: user.id, username: editForm.username, email: editForm.email
                        });
                        if (resp.status === 'success') {
                            user.username = editForm.username;
                            user.email = editForm.email;
                            localStorage.setItem('user', JSON.stringify(user));
                            toast('更新成功');
                        } else toast(resp.message);
                    } catch (e) { toast('更新失败'); }
                };

                const updatePassword = async () => {
                    if (passwordForm.newPassword !== passwordForm.confirmPassword) { toast('两次密码不一致'); return; }
                    try {
                        const resp = await api.post('/user/updatePassword', {
                            id: user.id, oldPassword: passwordForm.oldPassword, newPassword: passwordForm.newPassword
                        });
                        if (resp.status === 'success') {
                            showPasswordModal.value = false;
                            passwordForm.oldPassword = ''; passwordForm.newPassword = ''; passwordForm.confirmPassword = '';
                            toast('密码修改成功');
                        } else toast(resp.message);
                    } catch (e) { toast('修改失败'); }
                };

                const toast = (msg) => {
                    toastMessage.value = msg;
                    showToast.value = true;
                    setTimeout(() => showToast.value = false, 3000);
                };

                const logout = () => { localStorage.removeItem('user'); window.location.href = '../index.jsp'; };
                const goBack = () => { window.location.href = 'home.jsp'; };
                const openPasswordModal = () => { showPasswordModal.value = true; };
                const closePasswordModal = () => { showPasswordModal.value = false; };

                onMounted(() => { loadUserInfo(); });

                return {
                    user, editForm, passwordForm, showPasswordModal, showToast, toastMessage, avatarKey, avatarUrl,
                    fileInput, cropCanvas, showCropModal, cropLoading, cropScale,
                    getFirstChar, triggerFileInput, onFileSelected, setScale,
                    startDrag, onDrag, endDrag, confirmCrop, closeCropModal,
                    updateProfile, updatePassword,
                    logout, goBack, openPasswordModal, closePasswordModal
                };
            }
        }).mount('#app');
    </script>
</body>
</html>
