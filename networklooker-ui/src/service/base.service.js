import axios from "axios";




let GIndex = 0
let GResolve = {}

window.fetchCallback = (content, index, status) => {
    const handler = GResolve[index]

    if (status === 200) {
        handler.resolve({data: content})
    } else {
        handler.reject(content)
    }

    delete GResolve[index]
}

const serialize = function(obj) {
    var str = [];
    for (var p in obj)
        if (obj.hasOwnProperty(p)) {
            str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
        }
    return str.join("&");
}

const appFetch = (path, method, params) => {

    return new Promise((resolve, reject) => {
        const index = GIndex++

        if (method === "GET") {
            path = `${path}?${serialize(params)}`
            params = {}
        }

        window.webkit.messageHandlers.htmlMethods.postMessage({
            cmd: 'request',
            method: method,
            index: index,
            path,
            params
        });
        GResolve[index] = {resolve, reject}
    })
}

const netFetch = (path, method, params) => {
    if (method === "GET") {
        return axios
            .get(path,{params: params});
    } else if (method === "POST") {
        return axios
            .post(path,params);
    } else if (method === "PUT") {
        return axios
            .PUT(path,params);
    } else if (method === "DELETE") {
        return axios
            .delete(path,params);
    }
}
let useFetch = netFetch
if (window?.webkit?.messageHandlers?.htmlMethods !== null && window?.webkit?.messageHandlers?.htmlMethods !== undefined) {
    useFetch = appFetch
}



export const fetch = useFetch

// export const startService = () => {
//     window.webkit.messageHandlers.htmlMethods.postMessage({
//         cmd: 'start',
//     });
// }
