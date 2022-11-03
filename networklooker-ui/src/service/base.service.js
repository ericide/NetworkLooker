import axios from "axios";




let GIndex = 0
let GResolve = {}

window.fetchCallback = (content, index, status) => {
    const handler = GResolve[index]

    if (status === 200) {
        handler.resolve(content)
    } else {
        handler.reject(content)
    }

    delete GResolve[index]
}

const appFetch = (path, method, params) => {

    return new Promise((resolve, reject) => {
        const index = GIndex++
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



export const fetch = netFetch

// export const startService = () => {
//     window.webkit.messageHandlers.htmlMethods.postMessage({
//         cmd: 'start',
//     });
// }
