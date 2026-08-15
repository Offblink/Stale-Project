// 和实验二基本一致，直接复用了大部分代码
const API_BASE = '/realtor/api';

const apiRequest = async (method, url, data = null, params = {}) => {
    let fullUrl = API_BASE + url;

    if (params && Object.keys(params).length > 0) {
        const query = new URLSearchParams(params).toString();
        fullUrl += '?' + query;
    }

    const config = {
        method: method,
        url: fullUrl
    };

    if (data !== null) {
        if (data instanceof FormData) {
            config.data = data;
        } else {
            config.data = new URLSearchParams(data);
            config.headers = { 'Content-Type': 'application/x-www-form-urlencoded' };
        }
    }

    try {
        // 总请求语句，使用axios异步请求
        const response = await axios(config);
        return response.data;
    } catch (error) {
        console.error('API Error [' + method + ' ' + url + ']:', error);
        throw error;
    }
};

const apiGet = async (url, params = {}) => {
    return await apiRequest('GET', url, null, params);
};

const apiPost = async (url, data = {}) => {
    return await apiRequest('POST', url, data);
};

const apiPut = async (url, data = {}) => {
    return await apiRequest('PUT', url, data);
};

const apiDelete = async (url, data = null) => {
    return await apiRequest('DELETE', url, data);
};

// 和app（vue根元素）类似，这里是将api也初始化到静态代码库中，方便全局调用
// 也就是说这样一来，app里的元素就可以自由调用api了
const api = {
    get: apiGet,
    post: apiPost,
    put: apiPut,
    delete: apiDelete
};
