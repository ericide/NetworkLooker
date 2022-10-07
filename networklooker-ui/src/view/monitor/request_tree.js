import {Tree} from 'antd';
import React, {useEffect, useState} from 'react';

export const Request_tree = ({dataSource}) => {

    useEffect(()=>{

        let dataList = []


        for (const item of dataSource) {

            const pathes = item.path.split("/").filter(entry => entry !== "");

            console.log(item.id, pathes)

            // let array = [item.host, ]
            //
            //
            //
            // dataList.findIndex((value)=>{
            //
            // })
        }

    },[dataSource])


    const treeData = [{
        title: "aaa",
        key: "aaa",
        children: []
    }];

    const expandedKeys = ["aaa"];

    const onExpand = ()=>{
        console.log("aaa")
    }

    const autoExpandParent = true

    const onSelect = (selectedKeys, e) => {
        console.log(selectedKeys, e.node)
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