/*
写在开头：

API就是我们平时提到的"接口"，这里的接口不同于Java中的被实现的接口，而是专门用于前后端交互
一般地，jsp->api->servlet
接口有许多种格式，我们平时写的url是最原始的一种（RPC风格），不过这里主要使用的是Restful API
但无论是什么样的API，核心的功能都是处理请求与响应
*/

const API_BASE = '/VibeShop/api';

// 核心的API请求接口，定义了API的基本请求方式以及参数格式
// 这里的data参数用于传递可能携带的信息
const apiRequest = async (method, url, data = null, params = {}) => {
    var fullUrl = API_BASE + url; // 直接拼接url，不使用'?参数=值&'的方式拼接，是Restful API的写法

    // 当然，为了应对传递多条参数的情况，我们还得请出RPC风格的API
    // 可以看见，这里使用了'?参数=值&'的拼接格式
    if (method === 'GET' && Object.keys(params).length > 0) {
        const query = new URLSearchParams(params).toString();
        fullUrl += '?' + query;
    }

    // API请求配置信息
    const config = {
        method: method,
        url: fullUrl,
        headers: { 'Content-Type': 'application/json' }
    };

    // 附加请求体信息
    if (data !== null) {
        config.data = data;
    }

    // 这里，以配置的参数格式以及传入的参数统一请求相应的servlet
    try {
        const response = await axios(config);
        return response.data;
    } catch (error) {
        console.error('API Error:', error);
        throw error;
    }
};

// 以下是四种请求方式
const apiGet = async (url, params = {}) => {
    return await apiRequest('GET', url, null, params);
};

const apiPost = async (url, data = {}) => {
    return await apiRequest('POST', url, data);
};

const apiPut = async (url, data = {}) => {
    return await apiRequest('PUT', url, data);
};

const apiDelete = async (url) => {
    return await apiRequest('DELETE', url);
};

// 这是连接app.js和api.js的关键
// 通过这样，api就成为了全局变量，在app.js中自然就可以调用了
const api = {
    get: apiGet,
    post: apiPost,
    put: apiPut,
    delete: apiDelete
};