
export function makePathsTree(paths) {
    const treeRoot = makeTree(paths)

    // Return tree
    return treeRoot;
}


function makeTree(paths) {
    const treeRoot = {isFolder: true, title: "*", key: "", children: []};

    for (const object of paths) {
        // Set current post as root
        let curPos = treeRoot;

        // For each part
        const parts = object.parts
        while (parts.length) {
            // Get cur
            const curPart = parts.shift();
            const isLastPart = (parts.length === 0)
            // console.log(parts)
            // Get child node, create if not exists
            let childNode = curPos.children.find((item)=>{
                return item.title === curPart
            });
            if (!childNode || isLastPart) {
                childNode = {
                    isFolder: !!parts.length,
                    title: curPart,
                    key: curPart + object.id,
                    keyId: isLastPart ? object.id : null,
                    children: []
                };
                curPos.children.push(childNode)
            }

            // Update cur post to child node
            curPos = childNode;
        }
    }

    // Return tree
    return treeRoot;
}

function merge_paths(paths){
    var d = {};
    var new_d = {}
    for (var [a, ...b] of paths){
        d[a] = (a in d) ? [...d[a], b] : [b]
    }
    for (var i of Object.keys(d)){
        if (d[i].every(x => x.length === 1)){
            new_d[i] = d[i].map(x => x[0]);
        }
        else{
            var k = merge_paths(d[i])
            if (Object.keys(k).length > 1){
                new_d[i] = k
            }
            else{
                new_d[`${i}/${Object.keys(k)[0]}`] = k[Object.keys(k)[0]]
            }
        }
    }
    return new_d;
}

