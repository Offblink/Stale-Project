<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PetShop</title>

    <%--使用CDN加载框架--%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <%--这里使用defer属性，是为了延迟加载JS脚本（在DOM解析完成之后），从而保证vue正确挂载--%>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.3.4/dist/vue.global.prod.js" defer></script>
    <script src="https://cdn.jsdelivr.net/npm/axios@1.4.0/dist/axios.min.js" defer></script>
    <script src="js/api.js" defer></script>
    <script src="js/app.js" defer></script>

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f5f5f5; }

        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .navbar-brand { font-weight: 700; font-size: 1.5rem; color: #fff !important; }
        .search-input { border-radius: 20px; padding: 8px 20px; border: none; width: 300px; }
        .btn-register { background: #fff; color: #667eea; border-radius: 20px; padding: 8px 25px; font-weight: 600; }

        .main-container { max-width: 1200px; margin: 20px auto; padding: 0 20px; }

        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; margin-top: 20px; }
        .product-card { background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.08); transition: all 0.3s; cursor: pointer; }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0,0,0,0.15); }
        .product-image { width: 100%; height: 200px; object-fit: cover; background: #f8f8f8; }
        .product-info { padding: 15px; }
        .product-name { font-size: 1rem; font-weight: 600; color: #333; margin-bottom: 8px; height: 44px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
        .product-price { color: #e63946; font-size: 1.25rem; font-weight: 700; }
        .product-stock { color: #888; font-size: 0.85rem; }

        .pagination-container { display: flex; justify-content: center; align-items: center; margin: 30px 0; gap: 10px; }
        .pagination-btn { padding: 8px 16px; border: 1px solid #ddd; background: #fff; border-radius: 6px; cursor: pointer; transition: all 0.2s; }
        .pagination-btn:hover:not(:disabled) { background: #667eea; color: #fff; border-color: #667eea; }
        .pagination-btn:disabled { opacity: 0.5; cursor: not-allowed; }
        .page-info { padding: 8px 15px; background: #f8f8f8; border-radius: 6px; font-size: 0.9rem; }
        .page-input { width: 60px; padding: 8px; border: 1px solid #ddd; border-radius: 6px; text-align: center; }

        .fixed-buttons { position: fixed; bottom: 30px; right: 30px; display: flex; flex-direction: column; gap: 10px; z-index: 999; }
        .fixed-btn { width: 60px; height: 60px; border-radius: 50%; border: none; color: #fff; font-size: 1.5rem; cursor: pointer; box-shadow: 0 4px 15px rgba(0,0,0,0.2); transition: all 0.3s; display: flex; align-items: center; justify-content: center; }
        .fixed-btn:hover { transform: scale(1.1); }
        .btn-cart { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .btn-orders { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .cart-badge { position: absolute; top: -5px; right: -5px; background: #e63946; color: #fff; border-radius: 50%; width: 22px; height: 22px; font-size: 0.75rem; display: flex; align-items: center; justify-content: center; }

        .overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; opacity: 0; visibility: hidden; transition: all 0.3s; }
        .overlay.active { opacity: 1; visibility: visible; }

        .modal-panel { position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%) scale(0.9); background: #fff; border-radius: 16px; width: 90%; max-width: 600px; max-height: 85vh; overflow-y: auto; z-index: 1001; opacity: 0; visibility: hidden; transition: all 0.3s; }
        .modal-panel.active { opacity: 1; visibility: visible; transform: translate(-50%, -50%) scale(1); }
        .modal-header { padding: 20px 25px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; background: #fff; z-index: 10; }
        .modal-title { font-size: 1.25rem; font-weight: 700; color: #333; }
        .modal-close { background: none; border: none; font-size: 1.5rem; color: #999; cursor: pointer; padding: 5px; }
        .modal-close:hover { color: #333; }
        .modal-body { padding: 25px; }

        .detail-image { width: 100%; max-height: 350px; object-fit: contain; border-radius: 12px; background: #f8f8f8; cursor: zoom-in; }
        .detail-name { font-size: 1.5rem; font-weight: 700; color: #333; margin: 15px 0; }
        .detail-price { font-size: 2rem; color: #e63946; font-weight: 700; }
        .detail-stock { color: #888; font-size: 0.9rem; margin-left: 15px; }
        .detail-desc { color: #666; line-height: 1.8; margin: 20px 0; }

        .quantity-control { display: flex; align-items: center; gap: 10px; margin: 20px 0; }
        .qty-btn { width: 36px; height: 36px; border: 1px solid #ddd; background: #fff; border-radius: 6px; font-size: 1.2rem; cursor: pointer; transition: all 0.2s; }
        .qty-btn:hover { background: #667eea; color: #fff; border-color: #667eea; }
        .qty-input { width: 70px; height: 36px; border: 1px solid #ddd; border-radius: 6px; text-align: center; font-size: 1rem; }

        .address-select { width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem; margin: 15px 0; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; border-radius: 8px; padding: 12px 30px; font-size: 1rem; font-weight: 600; }

        .form-group { margin-bottom: 15px; }
        .form-label { display: block; font-weight: 600; color: #333; margin-bottom: 5px; }
        .form-input { width: 100%; padding: 10px 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem; }
        .form-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }

        .address-card { background: #f8f9fa; border-radius: 10px; padding: 15px; margin-bottom: 10px; cursor: pointer; border: 2px solid transparent; transition: all 0.2s; position: relative; }
        .address-card:hover { border-color: #667eea; }
        .address-card.selected { border-color: #667eea; background: #f0f3ff; }
        .address-card.default { border-color: #4facfe; }
        .address-default-badge { position: absolute; top: 10px; right: 10px; background: #4facfe; color: #fff; padding: 2px 8px; border-radius: 10px; font-size: 0.75rem; }
        .address-info { margin-top: 8px; }
        .address-actions { display: flex; gap: 10px; margin-top: 10px; }
        .btn-edit, .btn-delete { padding: 5px 15px; border: none; border-radius: 5px; cursor: pointer; font-size: 0.85rem; }
        .btn-edit { background: #4facfe; color: #fff; }
        .btn-delete { background: #e63946; color: #fff; }

        .cart-item { display: flex; align-items: center; padding: 15px; border-bottom: 1px solid #eee; }
        .cart-item-image { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; }
        .cart-item-info { flex: 1; margin-left: 15px; }
        .cart-item-name { font-weight: 600; color: #333; margin-bottom: 5px; }
        .cart-item-price { color: #e63946; font-weight: 700; }
        .cart-item-total { text-align: right; font-weight: 700; color: #333; }
        .cart-total { padding: 20px; background: #f8f9fa; border-radius: 10px; margin-top: 15px; }
        .cart-total-price { font-size: 1.5rem; color: #e63946; font-weight: 700; }

        .order-item { background: #f8f9fa; border-radius: 10px; padding: 15px; margin-bottom: 15px; }
        .order-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; padding-bottom: 10px; border-bottom: 1px solid #eee; }
        .order-id { font-weight: 600; color: #333; }
        .order-status { padding: 3px 12px; border-radius: 15px; font-size: 0.85rem; }
        .order-status.pending { background: #fff3cd; color: #856404; }
        .order-status.paid { background: #d4edda; color: #155724; }
        .order-status.shipped { background: #cce5ff; color: #004085; }
        .order-status.completed { background: #d1e7dd; color: #0f5132; }
        .order-products { margin-top: 10px; }
        .order-product { display: flex; justify-content: space-between; padding: 8px 0; }
        .order-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 15px; padding-top: 15px; border-top: 1px solid #eee; }
        .order-total { font-size: 1.25rem; font-weight: 700; color: #e63946; }

        .user-info { display: flex; align-items: center; gap: 10px; color: #fff; }
        .user-phone { font-weight: 600; }
        .btn-logout { background: rgba(255,255,255,0.2); border: none; color: #fff; padding: 5px 15px; border-radius: 15px; cursor: pointer; }

        .empty-state { text-align: center; padding: 50px 20px; color: #999; }
        .empty-state i { font-size: 4rem; margin-bottom: 20px; color: #ddd; }

        .loading { display: flex; justify-content: center; align-items: center; padding: 50px; }
        .spinner { width: 40px; height: 40px; border: 4px solid #f3f3f3; border-top: 4px solid #667eea; border-radius: 50%; animation: spin 1s linear infinite; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

        .toast-container { position: fixed !important; top: 80px !important; right: 20px !important; z-index: 9999 !important; max-width: 350px !important; pointer-events: none !important; }
        .toast { background: #fff !important; border-radius: 8px !important; padding: 15px 20px !important; margin-bottom: 10px !important; box-shadow: 0 4px 20px rgba(0,0,0,0.2) !important; display: flex !important; align-items: center !important; gap: 10px !important; animation: slideIn 0.3s ease !important; border-left: 4px solid #28a745 !important; pointer-events: auto !important; min-width: 200px !important; color: #333 !important; font-size: 14px !important; }
        .toast.success { border-left-color: #28a745 !important; background: #f0fff4 !important; }
        .toast.error { border-left-color: #dc3545 !important; background: #fff5f5 !important; color: #dc3545 !important; }
        @keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>

</head>
<body>
    <div id="app">

        <%--导航栏 Navigation--%>
        <nav class="navbar navbar-expand-lg navbar-dark">

            <div class="container">

                <%--链接指向当前页面顶部，点击不跳转--%>
                <a class="navbar-brand" href="#">

                    <%--i指icon，常用于显示图标--%>
                    <i class="fas fa-shopping-bag me-2"></i>PetShop

                </a>
                <div class="ms-auto">

                    <%--这里涉及到vue.js的条件渲染语句，意思是当用户未注册时才显示注册按钮--%>
                    <button v-if="!currentUser" class="btn btn-register" @click="showRegisterModal = true">

                        <i class="fas fa-user-plus me-2"></i>注册
                    </button>

                    <%--与之相对应的，是这里：注册后，使用双花括号（类似于EL表达式）显示用户电话号码，并作为唯一凭证--%>
                    <div v-else class="user-info">
                        <span class="user-phone">{{ currentUser.phone }}</span>
                        <button class="btn-logout" @click="logout">
                            <i class="fas fa-sign-out-alt"></i>
                        </button>
                    </div>

                </div>
            </div>
        </nav>

        <div class="main-container">
            <div class="product-grid" v-if="!loading">

                <%--这也是vue.js的for循环语句，表示将所有商品分页悉数渲染在页面上，点击后跳转到商品详情页--%>
                <div v-for="product in products" :key="product.id" class="product-card" @click="showProductDetail(product)">

                    <%--这里的alt表示alternate（替代），用于图片无法显示时的替代文字--%>
                    <img :src="product.imageUrl" :alt="product.name" class="product-image" @error="handleImageError">

                    <div class="product-info">
                        <div class="product-name">{{ product.name }}</div>
                        <div>
                            <span class="product-price">¥{{ product.price }}</span>
                            <span class="product-stock">库存: {{ product.stock }}</span>
                        </div>
                    </div>
                </div>
            </div>
            <div v-if="loading" class="loading">
                <div class="spinner"></div>
            </div>

            <%--当总页数大于0时，显示底部换页栏--%>
            <div class="pagination-container" v-if="!loading && totalPages > 0">

                <%--当前页数小于等于1时，“上一页”按钮不可用--%>
                <button class="pagination-btn" @click="prevPage" :disabled="currentPage <= 1">
                    <i class="fas fa-chevron-left"></i> 上一页
                </button>

                <span class="page-info">第 {{ currentPage }} / {{ totalPages }} 页</span>

                <%--这是跳转到指定页的输入框，当用户按下回车键时，自动跳转到指定页码--%>
                <input type="number" class="page-input" v-model.number="jumpPage" min="1" :max="totalPages" @keyup.enter="jumpToPage">

                <!--
                这里的v-model是一个很重要的概念：数据与视图之间的双向绑定
                当v-model中的变量发生改变，其他引用变量的地方会同步更新
                这样一来，也就实现了vue的响应式布局
                -->

                <button class="pagination-btn" @click="jumpToPage">跳转</button>
                <button class="pagination-btn" @click="nextPage" :disabled="currentPage >= totalPages">
                    下一页 <i class="fas fa-chevron-right"></i>
                </button>
            </div>
        </div>

        <div class="fixed-buttons">
            <button class="fixed-btn btn-cart" @click="showCartModal = true" style="position:relative;">
                <i class="fas fa-shopping-cart"></i>
                <span v-if="cartCount > 0" class="cart-badge">{{ cartCount }}</span>
            </button>
            <button class="fixed-btn btn-orders" @click="showOrdersModal = true">
                <i class="fas fa-receipt"></i>
            </button>
        </div>

        <!--
        这里涉及到覆盖层与遮罩的概念。
        简单来说，为了让页面更加美观好看，我在设计的时候，没有采用传统的对话框，
        而是使用了自定义的模态提示框。
        全页面分为五种模态框，分别是：商品详情、注册、地址、购物车以及订单
        这里将它们通过||连接起来，当其中任何一个布尔值（表示模态框的开启状态）为 true，
        就显示模态框，并通过具有一定透明度的遮罩将主页面遮住
        这样一来，也就避免了页面的跳转，实现了SPA（单页面应用）的布局
        -->
        <div class="overlay" :class="{ active: showProductDetailModal || showRegisterModal || showAddressModal || showCartModal || showOrdersModal }" @click="closeAllModals"></div>

        <%--当商品被选择时，显示商品详情模态框--%>
        <div class="modal-panel" :class="{ active: showProductDetailModal }" v-if="selectedProduct">
            <div class="modal-header">
                <h5 class="modal-title">商品详情</h5>
                <button class="modal-close" @click="closeAllModals">&times;</button>
            </div>
            <div class="modal-body">
                <img :src="selectedProduct.imageUrl" class="detail-image">
                <h3 class="detail-name">{{ selectedProduct.name }}</h3>
                <div>
                    <span class="detail-price">¥{{ selectedProduct.price }}</span>
                    <span class="detail-stock">库存: {{ selectedProduct.stock }}</span>
                </div>
                <p class="detail-desc">{{ selectedProduct.description }}</p>

                <%--当用户注册时，与下面用户未注册相互照应--%>
                <div v-if="currentUser">
                    <div class="form-group">
                        <label class="form-label">选择收货地址</label>
                        <select class="address-select" v-model="selectedAddressId">
                            <option value="">请选择地址</option>
                            <option v-for="addr in addresses" :key="addr.id" :value="addr.id">
                                {{ addr.receiverName }} - {{ addr.province }}{{ addr.city }}{{ addr.district }}{{ addr.detailAddress }}
                                <span v-if="addr.isDefault === 1">(默认)</span>
                            </option>
                        </select>
                        <button class="btn btn-link p-0" @click="showAddressModal = true; showProductDetailModal = false">
                            <i class="fas fa-plus"></i> 管理地址
                        </button>
                    </div>

                    <div class="quantity-control">
                        <span class="form-label mb-0">购买数量:</span>

                        <%--这是“-”按钮，用于减少购买数量。且当购买数量减少到1时，不再减少--%>
                        <button class="qty-btn" @click="buyQuantity = Math.max(1, buyQuantity - 1)">-</button>

                        <%--购买数量，最少1个，最多不超过库存数量--%>
                        <input type="number" class="qty-input" v-model.number="buyQuantity" min="1" :max="selectedProduct.stock">

                        <button class="qty-btn" @click="buyQuantity = Math.min(selectedProduct.stock, buyQuantity + 1)">+</button>
                    </div>

                    <button class="btn btn-primary w-100" @click="directBuy">
                        <i class="fas fa-bolt me-2"></i>立即购买
                    </button>
                    <button class="btn btn-outline-primary w-100 mt-2" @click="addToCart">
                        <i class="fas fa-cart-plus me-2"></i>加入购物车
                    </button>
                </div>

                <%--与上面的 v-if遥相呼应：当用户未注册时，仅显示提示按钮，点击后跳转到注册模态框--%>
                <div v-else class="text-center py-4">
                    <p class="text-muted">登录后可购买商品</p>

                    <%--跳转前将商品详情页关闭，防止多个遮罩相互覆盖，影响观感--%>
                    <button class="btn btn-primary" @click="showRegisterModal = true; showProductDetailModal = false">
                        <i class="fas fa-user-plus me-2"></i>登录 / 注册
                    </button>

                </div>
            </div>
        </div>

        <%--注册模态框--%>
        <div class="modal-panel" :class="{ active: showRegisterModal }">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-user-plus me-2"></i>用户注册
                </h5>
                <button class="modal-close" @click="closeAllModals">&times;</button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">手机号</label>

                    <%--tel是专门用于输入电话号码的类型。在移动端浏览器中，会仅弹出数字输入框--%>
                    <input type="tel" class="form-input" v-model="registerPhone" placeholder="请输入手机号" maxlength="11">

                </div>
                <button class="btn btn-primary w-100 mt-3" @click="register">
                    <i class="fas fa-check me-2"></i>确认注册
                </button>
            </div>
        </div>

        <%--地址模态框--%>
        <div class="modal-panel" :class="{ active: showAddressModal }">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-map-marker-alt me-2"></i>地址管理
                </h5>
                <button class="modal-close" @click="closeAllModals">&times;</button>
            </div>
            <div class="modal-body">

                <div v-if="!showAddressForm">
                    <button class="btn btn-primary mb-3" @click="startAddAddress">
                        <i class="fas fa-plus me-2"></i>新增地址
                    </button>
                    <div v-for="addr in addresses" :key="addr.id" class="address-card" :class="{ selected: selectedAddressId === addr.id, default: addr.isDefault === 1 }" @click="selectAddress(addr.id)">
                        <div v-if="addr.isDefault === 1" class="address-default-badge">默认</div>
                        <strong>{{ addr.receiverName }}</strong> {{ addr.phone }}<br>

                        <%--text-muted样式通常用于显示小字--%>
                        <small class="text-muted">{{ addr.province }} {{ addr.city }} {{ addr.district }} {{ addr.detailAddress }}</small>

                        <div class="address-actions">
                            <button class="btn-edit" @click="editAddress(addr)">编辑</button>
                            <button class="btn-delete" @click="deleteAddress(addr.id)">删除</button>
                        </div>
                    </div>

                    <%--这里的addresses是一个地址数组，当addresses长度严格等于0时，判断为暂无地址，需要添加--%>
                    <div v-if="addresses.length === 0" class="empty-state">
                        <i class="fas fa-map-marker-alt"></i>
                        <p>暂无地址，请添加</p>
                    </div>

                </div>
                <div v-else>
                    <div class="form-group">
                        <label class="form-label">收件人姓名</label>

                        <input type="text" class="form-input" v-model="addressForm.receiverName" placeholder="请输入收件人姓名">

                    </div>
                    <div class="form-group">
                        <label class="form-label">联系电话</label>
                        <input type="tel" class="form-input" v-model="addressForm.phone" placeholder="请输入联系电话">
                    </div>
                    <div class="form-group">
                        <label class="form-label">省市区</label>
                        <div class="form-row">
                            <input type="text" class="form-input" v-model="addressForm.province" placeholder="省">
                            <input type="text" class="form-input" v-model="addressForm.city" placeholder="市">
                            <input type="text" class="form-input" v-model="addressForm.district" placeholder="区">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">详细地址</label>
                        <input type="text" class="form-input" v-model="addressForm.detailAddress" placeholder="请输入详细地址">
                    </div>
                    <div class="form-group">
                        <label class="form-label">
                            <input type="checkbox" v-model="addressForm.isDefault"> 设为默认地址
                        </label>
                    </div>

                    <div class="d-flex gap-2">
                        <button class="btn btn-primary flex-grow-1" @click="saveAddress">
                            <i class="fas fa-check me-2"></i>保存
                        </button>
                        <button class="btn btn-outline-secondary flex-grow-1" @click="cancelAddressForm">
                            <i class="fas fa-arrow-left me-2"></i>返回
                        </button>
                    </div>

                </div>
            </div>
        </div>

        <%--购物车模态框--%>
        <div class="modal-panel" :class="{ active: showCartModal }" style="max-width: 800px;">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-shopping-cart me-2"></i>购物车
                </h5>
                <button class="modal-close" @click="closeAllModals">&times;</button>
            </div>
            <div class="modal-body">
                <div v-if="currentUser">
                    <div v-if="cartItems.length > 0">
                        <div v-for="item in cartItems" :key="item.id" class="cart-item">
                            <img :src="item.product.imageUrl" class="cart-item-image" @error="handleImageError">
                            <div class="cart-item-info">
                                <div class="cart-item-name">{{ item.product.name }}</div>
                                <div class="cart-item-price">¥{{ item.product.price }}</div>
                            </div>
                            <div class="quantity-control">
                                <button class="qty-btn" @click="updateCartQuantity(item.id, item.quantity - 1)">-</button>

                                <%--当仅当商品数量发生变化，且失去焦点（用户未选中）时更新--%>
                                <input type="number" class="qty-input" v-model.number="item.quantity" min="1" @change="updateCartQuantity(item.id, item.quantity)">

                                <button class="qty-btn" @click="updateCartQuantity(item.id, item.quantity + 1)">+</button>
                            </div>
                            <div class="cart-item-total">

                                <%--toFixed(2)表示保留两位小数--%>
                                <div>¥{{ (item.product.price * item.quantity).toFixed(2) }}</div>

                                <button class="btn btn-link text-danger p-0" @click="removeFromCart(item.id)">删除</button>
                            </div>
                        </div>
                        <div class="cart-total">
                            <div class="d-flex justify-content-between align-items-center">
                                <span>合计:</span>
                                <span class="cart-total-price">¥{{ cartTotal.toFixed(2) }}</span>
                            </div>
                        </div>
                        <button class="btn btn-primary w-100 mt-3" @click="checkout">
                            <i class="fas fa-credit-card me-2"></i>结算
                        </button>
                    </div>
                    <div v-else class="empty-state">
                        <i class="fas fa-shopping-cart"></i>
                        <p>购物车为空</p>
                    </div>
                </div>
                <div v-else class="text-center py-4">
                    <p class="text-muted">请先登录</p>
                    <button class="btn btn-primary" @click="showRegisterModal = true; showCartModal = false">
                        <i class="fas fa-user-plus me-2"></i>登录 / 注册
                    </button>
                </div>
            </div>
        </div>

        <div class="modal-panel" :class="{ active: showOrdersModal }" style="max-width: 800px;">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-receipt me-2"></i>我的订单
                </h5>
                <button class="modal-close" @click="closeAllModals">&times;</button>
            </div>
            <div class="modal-body">
                <div v-if="currentUser">
                    <div v-if="orders.length > 0">
                        <div v-for="order in orders" :key="order.id" class="order-item">
                            <div class="order-header">
                                <span class="order-id">订单号: {{ order.id }}</span>
                                <span class="order-status" :class="order.status">{{ order.statusText }}</span>
                            </div>
                            <div class="order-products">
                                <div v-for="item in order.items" :key="item.id" class="order-product">
                                    <span>{{ item.productName }} x {{ item.quantity }}</span>
                                    <span>¥{{ item.price }} x {{ item.quantity }}</span>
                                </div>
                            </div>
                            <div class="order-footer">
                                <small class="text-muted">{{ formatDate(order.createdAt) }}</small>
                                <span class="order-total">¥{{ order.totalPrice }}</span>
                            </div>
                        </div>
                    </div>
                    <div v-else class="empty-state">
                        <i class="fas fa-receipt"></i>
                        <p>暂无订单</p>
                    </div>
                </div>
                <div v-else class="text-center py-4">
                    <p class="text-muted">请先登录</p>
                    <button class="btn btn-primary" @click="showRegisterModal = true; showOrdersModal = false">
                        <i class="fas fa-user-plus me-2"></i>登录 / 注册
                    </button>
                </div>
            </div>
        </div>

        <!-- 自定义模态对话框 -->
        <div id="customModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999;">
            <div style="position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); background:#fff; border-radius:12px; padding:30px; min-width:320px; max-width:90%; text-align:center; box-shadow:0 10px 40px rgba(0,0,0,0.3);">
                <div id="modalIcon" style="font-size:48px; margin-bottom:15px;"></div>
                <div id="modalTitle" style="font-size:18px; font-weight:bold; margin-bottom:10px; color:#333;"></div>
                <div id="modalMessage" style="font-size:14px; color:#666; margin-bottom:25px; line-height:1.5;"></div>
                <div style="display:flex; gap:15px; justify-content:center;">
                    <button id="modalCancelBtn" onclick="closeCustomModal()" style="display:none; background:linear-gradient(135deg,#6c757d,#5a6268); color:#fff; border:none; padding:12px 30px; border-radius:25px; font-size:16px; cursor:pointer;">取消</button>
                    <button id="modalOkBtn" onclick="closeCustomModal()" style="background:linear-gradient(135deg,#667eea,#764ba2); color:#fff; border:none; padding:12px 40px; border-radius:25px; font-size:16px; cursor:pointer;">确定</button>
                </div>
            </div>
        </div>

        <div class="toast-container">
            <div v-for="toast in toasts" :key="toast.id" class="toast" :class="toast.type">
                {{ toast.message }}
            </div>
        </div>
    </div>
</body>
