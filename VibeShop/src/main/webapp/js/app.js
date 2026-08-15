// 模态框函数初始化
const { createApp, ref, computed, onMounted } = Vue;

// 关闭模态框
function closeCustomModal() {
    document.getElementById('customModal').style.display = 'none';
}

// 确认对话框
function showConfirm(message, onConfirm) {
    var modal = document.getElementById('customModal');
    var modalIcon = document.getElementById('modalIcon');
    var modalTitle = document.getElementById('modalTitle');
    var modalMessage = document.getElementById('modalMessage');
    var modalOkBtn = document.getElementById('modalOkBtn');
    var modalCancelBtn = document.getElementById('modalCancelBtn');

    modalIcon.innerHTML = '<i class="fas fa-question-circle" style="color:#667eea;"></i>';
    modalTitle.textContent = '确认操作';
    modalMessage.textContent = message;

    // 显示取消按钮
    modalCancelBtn.style.display = 'inline-block';
    modalOkBtn.textContent = '确定';
    modalOkBtn.style.background = 'linear-gradient(135deg,#667eea,#764ba2)';

    // 保存确认回调
    window._confirmCallback = onConfirm;

    // 确定按钮点击执行回调并关闭
    modalOkBtn.onclick = function() {
        closeCustomModal();
        modalCancelBtn.style.display = 'none';
        if (window._confirmCallback) {
            window._confirmCallback();
            window._confirmCallback = null;
        }
    };

    // 取消按钮直接关闭
    modalCancelBtn.onclick = function() {
        closeCustomModal();
        modalCancelBtn.style.display = 'none';
        window._confirmCallback = null;
    };

    modal.style.display = 'block';
}

const app = createApp({
    setup() {
        // 响应式数据
        const products = ref([]);
        const currentPage = ref(1);
        const totalPages = ref(0);
        const pageSize = ref(12);
        const loading = ref(false);
        const jumpPage = ref(1);

        const currentUser = ref(null);
        const addresses = ref([]);
        const selectedAddressId = ref('');
        const cartItems = ref([]);
        const orders = ref([]);

        const showProductDetailModal = ref(false);
        const showRegisterModal = ref(false);
        const showAddressModal = ref(false);
        const showCartModal = ref(false);
        const showOrdersModal = ref(false);
        const showAddressForm = ref(false);
        const imageZoomed = ref(false);

        const selectedProduct = ref(null);
        const buyQuantity = ref(1);
        const registerPhone = ref('');

        const addressForm = ref({
            id: null,
            receiverName: '',
            phone: '',
            province: '',
            city: '',
            district: '',
            detailAddress: '',
            isDefault: false
        });

        const toasts = ref([]);
        let toastId = 0;

        // Toast显示（使用模态框）
        const showToast = (message, type = 'success') => {
            // 使用模态框显示消息
            var modal = document.getElementById('customModal');
            var modalIcon = document.getElementById('modalIcon');
            var modalTitle = document.getElementById('modalTitle');
            var modalMessage = document.getElementById('modalMessage');
            var modalOkBtn = document.getElementById('modalOkBtn');
            var modalCancelBtn = document.getElementById('modalCancelBtn');

            // 根据类型设置图标和样式
            if (type === 'error') {
                modalIcon.innerHTML = '<i class="fas fa-exclamation-circle" style="color:#dc3545;"></i>';
                modalTitle.textContent = '提示';
                modalOkBtn.style.background = 'linear-gradient(135deg,#dc3545,#c82333)';
            } else {
                modalIcon.innerHTML = '<i class="fas fa-check-circle" style="color:#28a745;"></i>';
                modalTitle.textContent = '提示';
                modalOkBtn.style.background = 'linear-gradient(135deg,#28a745,#20c997)';
            }
            
            modalMessage.textContent = message;
            modalCancelBtn.style.display = 'none';  // 隐藏取消按钮
            modalOkBtn.textContent = '确定';
            
            // 确定按钮点击关闭
            modalOkBtn.onclick = function() {
                closeCustomModal();
            };
            
            modal.style.display = 'block';
        };

        // 计算购物车中商品数量
        const cartCount = computed(() => cartItems.value.length);

        // 商品总价
        const cartTotal = computed(() => {
            //reduce 表示将两个值"缩减"为单个值
            return cartItems.value.reduce((sum, item) => {
                return sum + (item.product.price * item.quantity);
            }, 0);
        });

        // 商品加载（这里异步调用了api，api也通过axios返回异步消息）
        const loadProducts = async (page = 1) => {
            loading.value = true; // 开始加载
            try {
                // 等待接口响应，当状态码200表示返回成功，加载商品信息
                const response = await api.get('/products', { page, size: 12 });
                if (response.code === 200) {
                    products.value = response.data.products;
                    currentPage.value = response.data.currentPage;
                    totalPages.value = response.data.totalPages;
                    jumpPage.value = currentPage.value;
                } else {
                    showToast(response.message || '加载商品失败', 'error');
                }
            } catch (error) {
                console.error('加载商品失败:', error);
                showToast('加载商品失败', 'error');
            } finally {
                loading.value = false; // 最后结束加载（无论有没有加载成功）
            }
        };

        // 用户数据加载
        const loadUserData = async () => {
            // localStorage是一种老师没有提到过的存储机制
            // 从生命周期的角度上来说，LS > App(PageContext) > Session、Cookie > Request > Page
            // 这是因为LS中的数据保存在本地，只要应用或用户不主动清理，就算关闭服务器也不会被清除
            // 我们输入表单的时候，自动补全功能的数据就来自LS
            const userId = localStorage.getItem('userId');

            if (userId) {
                try {
                    // 这里也调了api
                    const response = await api.get('/user/' + userId);
                    // 如果请求成功，并行加载（Promise.all）所有数据
                    if (response.code === 200) {
                        currentUser.value = response.data;
                        await Promise.all([loadAddresses(), loadCart(), loadOrders()]);
                        // 否则说明userId无效，清除
                    } else {
                        localStorage.removeItem('userId');
                    }
                } catch (error) {
                    console.error('获取用户信息失败:', error);
                    localStorage.removeItem('userId');
                }
            }
        };

        // 地址管理
        const loadAddresses = async () => {
            if (!currentUser.value) return;
            try {
                const response = await api.get('/user/address/' + currentUser.value.id);
                if (response.code === 200) {
                    addresses.value = response.data;
                    // 这里的find()方法，不仅用于查找满足条件的的地址，而且只查找第一个
                    const defaultAddr = addresses.value.find(a => a.isDefault === 1);
                    if (defaultAddr) {
                        selectedAddressId.value = defaultAddr.id;
                    }
                }
            } catch (error) {
                console.error('加载地址失败:', error);
            }
        };

        // 购物车管理
        const loadCart = async () => {
            if (!currentUser.value) return;
            try {
                const response = await api.get('/cart/' + currentUser.value.id);
                if (response.code === 200) {
                    cartItems.value = response.data;
                }
            } catch (error) {
                console.error('加载购物车失败:', error);
            }
        };

        // 订单管理
        const loadOrders = async () => {
            if (!currentUser.value) return;
            try {
                const response = await api.get('/orders/' + currentUser.value.id);
                if (response.code === 200) {
                    orders.value = response.data;
                }
            } catch (error) {
                console.error('加载订单失败:', error);
            }
        };

        // 分页（上/下一页）
        const prevPage = () => {
            if (currentPage.value > 1) {
                loadProducts(currentPage.value - 1);
            }
        };
        const nextPage = () => {
            if (currentPage.value < totalPages.value) {
                loadProducts(currentPage.value + 1);
            }
        };

        const jumpToPage = () => {
            const page = jumpPage.value;
            if (page >= 1 && page <= totalPages.value) {
                loadProducts(page);
            }
        };

        // 商品详情
        const showProductDetail = (product) => {
            selectedProduct.value = product;
            buyQuantity.value = 1;
            showProductDetailModal.value = true;
        };

        const toggleImageZoom = () => {
            imageZoomed.value = !imageZoomed.value;
        };

        // 模态框控制
        const closeAllModals = () => {
            showProductDetailModal.value = false;
            showRegisterModal.value = false;
            showAddressModal.value = false;
            showCartModal.value = false;
            showOrdersModal.value = false;
            showAddressForm.value = false;
            imageZoomed.value = false;
        };

        // 用户认证
        const register = async () => {
            if (!registerPhone.value) {
                showToast('请输入手机号', 'error');
                return;
            }

            const phoneRegex = /^1[3-9]\d{9}$/;

            // 使用正则表达式验证电话号码格式，如不符合返回错误信息
            if (!phoneRegex.test(registerPhone.value)) {
                showToast('请输入有效的11位手机号', 'error');
                return;
            }

            try {
                const response = await api.post('/user/register', {
                    phone: registerPhone.value
                });
                if (response.code === 200) {
                    currentUser.value = response.data;
                    localStorage.setItem('userId', response.data.id);
                    showToast('注册成功');
                    showRegisterModal.value = false;
                    registerPhone.value = '';
                    await Promise.all([loadAddresses(), loadCart(), loadOrders()]);
                } else {
                    showToast(response.message || '注册失败', 'error');
                }
            } catch (error) {
                console.error('注册失败:', error);
                const errorMsg = error.response?.data?.message || '注册失败，请稍后重试';
                showToast(errorMsg, 'error');
            }
        };

        const logout = () => {
            showConfirm('确定要退出登录吗？', () => {
                currentUser.value = null;
                localStorage.removeItem('userId');
                addresses.value = [];
                cartItems.value = [];
                orders.value = [];
                selectedAddressId.value = '';
                showToast('已退出登录');
            });
        };

        const startAddAddress = () => {
            addressForm.value = {
                id: null,
                receiverName: '',
                phone: '',
                province: '',
                city: '',
                district: '',
                detailAddress: '',
                isDefault: false
            };
            showAddressForm.value = true;
        };

        const editAddress = (addr) => {
            addressForm.value = {
                id: addr.id,
                receiverName: addr.receiverName,
                phone: addr.phone,
                province: addr.province,
                city: addr.city,
                district: addr.district,
                detailAddress: addr.detailAddress,
                isDefault: addr.isDefault === 1
            };
            showAddressForm.value = true;
        };

        // 在地址管理表单，从上往下检测缺省。一旦检测到留空，则返回错误信息
        const saveAddress = async () => {
            console.log('[VibeShop] saveAddress called');
            console.log('[VibeShop] addressForm:', addressForm.value);
            console.log('[VibeShop] showToast function:', showToast);
            console.log('[VibeShop] toasts array:', toasts.value);
            
            if (!addressForm.value.receiverName) {
                console.log('[VibeShop] receiverName is empty');
                showToast('请输入收件人姓名', 'error');
                console.log('[VibeShop] toasts after showToast:', toasts.value);
                return;
            }
            if (!addressForm.value.phone) {
                console.log('[VibeShop] phone is empty');
                showToast('请输入联系电话', 'error');
                return;
            }

            // 正则表达式，乍一看很复杂，其实和我们在数据库中学到的模糊匹配很相像：
            // ^表示开头，$表示结尾，[]表示可取的范围，\d表示数字（digital）
            // 这部分内容在我们学习欧拉操作系统的时候，何老师也提到过
            const phoneRegex = /^1[3-9]\d{9}$/;

            //如格式不匹配，弹出错误信息
            if (!phoneRegex.test(addressForm.value.phone)) {
                console.log('[VibeShop] phone format error:', addressForm.value.phone);
                showToast('请输入有效的11位手机号', 'error');
                console.log('[VibeShop] toasts after phone error:', toasts.value);
                return;
            }

            if (!addressForm.value.province) {
                showToast('请选择省份', 'error');
                return;
            }
            if (!addressForm.value.city) {
                showToast('请选择城市', 'error');
                return;
            }
            if (!addressForm.value.district) {
                showToast('请选择区县', 'error');
                return;
            }
            if (!addressForm.value.detailAddress) {
                showToast('请输入详细地址', 'error');
                return;
            }
            try {
                const data = {
                    userId: currentUser.value.id,
                    receiverName: addressForm.value.receiverName,
                    phone: addressForm.value.phone,
                    province: addressForm.value.province,
                    city: addressForm.value.city,
                    district: addressForm.value.district,
                    detailAddress: addressForm.value.detailAddress,
                    isDefault: addressForm.value.isDefault ? 1 : 0
                };

                // 更新地址，将信息传给api，让api通过servlet一步一步保存到数据库
                let response;
                if (addressForm.value.id) {
                    response = await api.put('/user/address/' + addressForm.value.id, data);
                } else {
                    response = await api.post('/user/address', data);
                }
                if (response.code === 200) {
                    showToast('保存成功');
                    showAddressForm.value = false;
                    await loadAddresses();
                } else {
                    showToast(response.message, 'error');
                }
            } catch (error) {
                console.error('保存地址失败:', error);
                showToast('保存地址失败', 'error');
            }
        };

        const deleteAddress = async (id) => {
            showConfirm('确定要删除该地址吗？', async () => {
                try {
                    const response = await api.delete('/user/address/' + id);
                    if (response.code === 200) {
                        showToast('删除成功');
                        await loadAddresses();

                        // 这里，如果当前选中的id等于被点击的地址的Id，则取消选中
                        // 这和selectAddress()是相互对应的
                        if (selectedAddressId.value === id) {
                            selectedAddressId.value = '';
                        }

                    } else {
                        showToast(response.message, 'error');
                    }
                } catch (error) {
                    console.error('删除地址失败:', error);
                    // 响应、数据、信息一一尝试返回，如都不存在显示默认错误信息
                    const errorMsg = error.response?.data?.message || '删除失败，请稍后重试';
                    showToast(errorMsg, 'error');
                }
            });
        };

        // selectAddress方法
        const selectAddress = (id) => {
            selectedAddressId.value = id;
        };

        const cancelAddressForm = () => {
            showAddressForm.value = false;
        };

        const addToCart = async () => {
            if (!currentUser.value) {
                showRegisterModal.value = true;
                return;
            }
            if (!selectedAddressId.value) {
                showToast('请先选择收货地址', 'error');
                showProductDetailModal.value = false;
                showAddressModal.value = true;
                return;
            }
            try {
                const response = await api.post('/cart', {
                    userId: currentUser.value.id,
                    productId: selectedProduct.value.id,
                    quantity: buyQuantity.value
                });
                if (response.code === 200) {
                    showToast('已加入购物车');
                    await loadCart();
                    showProductDetailModal.value = false;
                } else {
                    showToast(response.message, 'error');
                }
            } catch (error) {
                console.error('加入购物车失败:', error);
                showToast('加入购物车失败', 'error');
            }
        };

        // 更新购物车中商品数量
        const updateCartQuantity = async (cartId, quantity) => {
            //当所选商品数量小于1（减到0）时，直接移除该商品
            if (quantity < 1) {
                await removeFromCart(cartId);
                return;
            }
            try {
                console.log('[VibeShop] updateCartQuantity url:', '/cart/' + cartId);
                const response = await api.put('/cart/' + cartId, { quantity });
                if (response.code === 200) {
                    await loadCart();
                } else {
                    showToast(response.message, 'error');
                }
            } catch (error) {
                console.error('更新数量失败:', error);
                showToast('更新数量失败', 'error');
            }
        };

        const removeFromCart = async (cartId) => {
            try {
                const response = await api.delete('/cart/' + cartId);

                // 注意一个点：当我们手动将商品数量减为0时，也会弹出这条信息
                if (response.code === 200) {
                    showToast('已从购物车移除');
                    await loadCart();
                } else {
                    showToast(response.message, 'error');
                }

            } catch (error) {
                console.error('移除失败:', error);
                const errorMsg = error.response?.data?.message || '移除失败，请稍后重试';
                showToast(errorMsg, 'error');
            }
        };

        // 购物车结算
        const checkout = async () => {
            if (!selectedAddressId.value) {
                showToast('请选择收货地址', 'error');
                showAddressModal.value = true;
                showCartModal.value = false;
                return;
            }
            try {
                const cartData = cartItems.value.map(item => ({
                    productId: item.productId,
                    quantity: item.quantity
                }));
                const response = await api.post('/orders', {
                    userId: currentUser.value.id,
                    addressId: selectedAddressId.value,
                    cartItems: cartData
                });
                if (response.code === 200) {
                    showToast('下单成功');
                    showCartModal.value = false;
                    await Promise.all([loadCart(), loadOrders()]);
                } else {
                    showToast(response.message, 'error');
                }
            } catch (error) {
                console.error('结算失败:', error);
                showToast('结算失败', 'error');
            }
        };

        // 直接购买，不加入购物车
        const directBuy = async () => {
            if (!currentUser.value) {
                showRegisterModal.value = true;
                return;
            }
            if (!selectedAddressId.value) {
                showToast('请选择收货地址', 'error');
                return;
            }
            if (buyQuantity.value < 1 || buyQuantity.value > selectedProduct.value.stock) {
                showToast('数量无效，请检查库存', 'error');
                return;
            }
            try {
                const response = await api.post('/orders/direct', {
                    userId: currentUser.value.id,
                    addressId: selectedAddressId.value,
                    productId: selectedProduct.value.id,
                    quantity: buyQuantity.value
                });
                if (response.code === 200) {
                    showToast('下单成功');
                    closeAllModals();
                    await loadOrders();
                } else {
                    showToast(response.message, 'error');
                }
            } catch (error) {
                console.error('下单失败:', error);
                showToast('下单失败', 'error');
            }
        };

        // 当找不到图片资源时，显示默认贴图（这也是15号商品图片的实现方式）
        const handleImageError = (e) => {
            e.target.src = '/VibeShop/images/products/No_Image.png';
        };

        const formatDate = (dateStr) => {
            if (!dateStr) return '';
            const date = new Date(dateStr);
            return date.toLocaleString('zh-CN');
        };

        // 初始化
        onMounted(() => {
            loadProducts();
            loadUserData();
        });

        return {
            products,
            currentPage,
            totalPages,
            loading,
            jumpPage,
            currentUser,
            addresses,
            selectedAddressId,
            cartItems,
            orders,
            showProductDetailModal,
            showRegisterModal,
            showAddressModal,
            showCartModal,
            showOrdersModal,
            showAddressForm,
            imageZoomed,
            selectedProduct,
            buyQuantity,
            registerPhone,
            addressForm,
            toasts,
            cartCount,
            cartTotal,
            showToast,
            prevPage,
            nextPage,
            jumpToPage,
            showProductDetail,
            toggleImageZoom,
            closeAllModals,
            register,
            logout,
            startAddAddress,
            editAddress,
            saveAddress,
            deleteAddress,
            selectAddress,
            cancelAddressForm,
            addToCart,
            updateCartQuantity,
            removeFromCart,
            checkout,
            directBuy,
            handleImageError,
            formatDate
        };
    }
});

app.mount('#app');