<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MC Realtor - 用户首页</title>
    <link rel="icon" href="/realtor/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="/realtor/favicon.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/axios.min.js"></script>
    <script src="../js/api.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Microsoft YaHei', 'Segoe UI', sans-serif;
        }
        .navbar {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .property-card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .property-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .property-image {
            height: 180px;
            object-fit: cover;
        }
        .price-badge {
            background: linear-gradient(135deg, #6C63FF 0%, #8B84FF 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
        }
        .search-box {
            position: relative;
        }
        .search-box button {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: none;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
        <div class="container">
            <a class="navbar-brand" href="#" style="font-weight: 700; color: #6C63FF;">🏠 MC Realtor</a>
            <div class="d-flex align-items-center gap-3">
                <span class="text-muted">欢迎，用户</span>
            </div>
        </div>
    </nav>

    <div class="container mt-6" style="margin-top: 60px;">
        <div class="row mb-4">
            <div class="col-md-3">
                <select id="typeSelect" class="form-select rounded-pill px-4 py-2 border-0 bg-light">
                    <option value="">全部户型</option>
                </select>
            </div>
            <div class="col-md-3">
                <select id="regionSelect" class="form-select rounded-pill px-4 py-2 border-0 bg-light">
                    <option value="">全部区域</option>
                </select>
            </div>
            <div class="col-md-3">
                <input id="minPriceInput" type="number" class="form-control rounded-pill px-4 py-2 border-0 bg-light" placeholder="最低价格(💎)">
            </div>
            <div class="col-md-3">
                <input id="maxPriceInput" type="number" class="form-control rounded-pill px-4 py-2 border-0 bg-light" placeholder="最高价格(💎)">
            </div>
        </div>

        <div class="mb-4 search-box">
            <input id="searchInput" type="text" class="form-control rounded-pill px-4 py-3 border-0 bg-light" placeholder="搜索房源...">
            <button id="searchBtn">🔍</button>
        </div>

        <div class="row" id="propertiesContainer">
        </div>

        <div id="emptyState" class="text-center py-10" style="display: none;">
            <p style="color: #6B7280;">暂无房源数据</p>
        </div>
    </div>

    <script>
        const propertiesContainer = document.getElementById('propertiesContainer');
        const emptyState = document.getElementById('emptyState');
        const typeSelect = document.getElementById('typeSelect');
        const regionSelect = document.getElementById('regionSelect');
        const minPriceInput = document.getElementById('minPriceInput');
        const maxPriceInput = document.getElementById('maxPriceInput');
        const searchInput = document.getElementById('searchInput');
        const searchBtn = document.getElementById('searchBtn');

        async function loadProperties() {
            try {
                const data = await api.get('/property');
                if (data.status === 'success') {
                    renderProperties(data.data);
                }
            } catch (error) {
                console.error('加载房源失败');
                emptyState.style.display = 'block';
            }
        }

        async function loadTypes() {
            try {
                const data = await api.get('/property/types');
                if (data.status === 'success') {
                    data.data.forEach(type => {
                        const option = document.createElement('option');
                        option.value = type;
                        option.textContent = type;
                        typeSelect.appendChild(option);
                    });
                }
            } catch (error) {
                console.error('加载户型列表失败');
            }
        }

        async function loadRegions() {
            try {
                const data = await api.get('/property/regions');
                if (data.status === 'success') {
                    data.data.forEach(region => {
                        const option = document.createElement('option');
                        option.value = region;
                        option.textContent = region;
                        regionSelect.appendChild(option);
                    });
                }
            } catch (error) {
                console.error('加载区域列表失败');
            }
        }

        async function searchProperties() {
            const keyword = searchInput.value.trim();
            if (!keyword) {
                loadProperties();
                return;
            }
            try {
                const data = await api.get('/property/search', { keyword: keyword });
                if (data.status === 'success') {
                    renderProperties(data.data);
                }
            } catch (error) {
                console.error('搜索失败');
            }
        }

        async function applyFilters() {
            try {
                const params = {};
                if (typeSelect.value) params.type = typeSelect.value;
                if (regionSelect.value) params.region = regionSelect.value;
                if (minPriceInput.value) params.minPrice = minPriceInput.value;
                if (maxPriceInput.value) params.maxPrice = maxPriceInput.value;
                const data = await api.get('/property/filter', params);
                if (data.status === 'success') {
                    renderProperties(data.data);
                }
            } catch (error) {
                console.error('筛选失败');
            }
        }

        function renderProperties(properties) {
            if (!properties || properties.length === 0) {
                propertiesContainer.innerHTML = '';
                emptyState.style.display = 'block';
                return;
            }
            emptyState.style.display = 'none';
            propertiesContainer.innerHTML = properties.map(property => `
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="card property-card rounded-2xl overflow-hidden">
                        ${property.imageUrl ? 
                            `<img src="${property.imageUrl}" class="card-img-top property-image" alt="房源图片" onerror="this.style.display='none'; this.parentElement.innerHTML='<div class=\\'d-flex align-items-center justify-content-center h-45 bg-light\\'><span style=\\'font-size:40px;\\'>🏠</span></div>';">` : 
                            `<div class="d-flex align-items-center justify-content-center h-45 bg-light"><span style="font-size:40px;">🏠</span></div>`
                        }
                        <div class="card-body p-4">
                            <h5 class="card-title font-weight-bold">${property.title}</h5>
                            <p class="text-muted text-sm">${property.type} | ${property.area}㎡</p>
                            <p class="text-muted text-sm">📍 ${property.region} - ${property.address || ''}</p>
                            <p class="text-muted text-sm mt-2" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                ${property.description}
                            </p>
                            <div class="mt-3">
                                <span class="price-badge">${property.price}💎</span>
                            </div>
                        </div>
                    </div>
                </div>
            `).join('');
        }

        searchBtn.addEventListener('click', searchProperties);
        searchInput.addEventListener('keyup', (e) => {
            if (e.key === 'Enter') searchProperties();
        });
        typeSelect.addEventListener('change', applyFilters);
        regionSelect.addEventListener('change', applyFilters);
        minPriceInput.addEventListener('change', applyFilters);
        maxPriceInput.addEventListener('change', applyFilters);

        document.addEventListener('DOMContentLoaded', () => {
            loadProperties();
            loadTypes();
            loadRegions();
        });
    </script>
</body>
</html>