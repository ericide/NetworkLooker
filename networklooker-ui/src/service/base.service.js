



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

export const fetch = (path, params) => {

    return new Promise((resolve, reject) => {

        const index = GIndex++

        window.webkit.messageHandlers.htmlMethods.postMessage({
            cmd: 'request',
            index: index,
            path,
            params
        });
        GResolve[index] = {resolve, reject}
    })
}
