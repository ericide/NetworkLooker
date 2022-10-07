import {Tree} from 'antd';
import React, {useEffect, useState} from 'react';
import {makePathsTree} from "./util/tree_helper";

export const RequestTree = ({dataSource, onClick}) => {

    const [treeData, setTreeData] = useState([]);

    useEffect(()=>{

        let dataList = []




        for (const item of dataSource) {

            const pathes = item.path.split("/").filter(entry => entry !== "");
            let pathes2 = [item.host]
            pathes2.push(...pathes)
            item.parts = pathes2
            dataList.push(item)




            // let array = [item.host, ]
            //
            //
            //
            // dataList.findIndex((value)=>{
            //
            // })
        }
        let node = makePathsTree(dataList)

        setTreeData(node.children)
        // console.log(node)
    },[dataSource])




    const [expandedKeys, setExpandedKeys] = useState(["api.latibac.com"]);

    const onExpand = (items)=>{
        // console.log("onExpand", item, expandedKeys)
        setExpandedKeys(items)
    }

    const autoExpandParent = true

    const onSelect = (selectedKeys, e) => {
        if (e.node.keyId !== null) {
            onClick(e.node.keyId)
        } else {
            let items = expandedKeys
            const i = items.indexOf(e.node.key)
            if (i < 0) {
                items.push(e.node.key)
            } else {
                items.splice(i, 1)
            }
            console.log(items)
            setExpandedKeys(items)
        }
    }

    return <>
        <Tree
            onExpand={onExpand}
            expandedKeys={expandedKeys}
            autoExpandParent={autoExpandParent}
            treeData={treeData}
            onSelect={onSelect}
        /></>
}