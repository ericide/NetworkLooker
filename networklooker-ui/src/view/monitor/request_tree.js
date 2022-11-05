import React, { useState } from "react";

export const RequestTree = ({ dataSource, onClick }) => {
  const [treeData, setTreeData] = useState([]);

  const [expandedKeys, setExpandedKeys] = useState(["api.latibac.com"]);

  const onExpand = (items) => {
    // console.log("onExpand", item, expandedKeys)
    setExpandedKeys(items);
  };

  const autoExpandParent = true;

  const onSelect = (selectedKeys, e) => {
    if (e.node.keyId !== null) {
      onClick(e.node.keyId);
    } else {
      let items = expandedKeys;
      const i = items.indexOf(e.node.key);
      if (i < 0) {
        items.push(e.node.key);
      } else {
        items.splice(i, 1);
      }
      console.log(items);
      setExpandedKeys(items);
    }
  };

  return (
    <div style={{ width: "100%" }}>
      {dataSource.map((item) => {
        return (
          <div
            style={{ backgroundColor: "green", margin: "8px" }}
            onClick={(e) => onClick(item.id)}
            key={item.id}
          >
            <a style={{ color: "black" }}>{item.host + item.uri}</a>
          </div>
        );
      })}
    </div>
  );
};
