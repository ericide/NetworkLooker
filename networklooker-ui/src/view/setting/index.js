import React, { useEffect, useState } from "react";
import {
  querySetting,
  saveSetting,
} from "../../service/setting.service";
import {ExternalProxySettingComponent} from "./external_proxy";
import {WatchingListSettingComponent} from "./watching_list";

export const SettingPage = () => {
  const [content, setContent] = useState(<div/>);

  const [setting, setSetting] = useState(null);


  useEffect(() => {
    refreshData();
  }, []);


  useEffect(() => {
    if (setting === null) {
      return
    }
    saveSetting(setting).then((e) => {
      console.log(e)
    })

  }, [setting]);

  async function refreshData() {
    const res = await querySetting();
    setSetting(res.data.data)
  }

  const settingMenuMap =  [
    {
      "Name": "Listening Port",
      "Page": <div/>,
    },
    {
      "Name": "Watching List",
      "Page": <WatchingListSettingComponent setting={setting} setSetting={setSetting}/>,
    },
    {
      "Name": "Remote Config",
      "Page": <div/>,
    },
    {
      "Name": "External Proxy",
      "Page": <ExternalProxySettingComponent setting={setting} setSetting={setSetting}/>,
    },
  ];

  function menuListDidClick(menuItem){
    return (e) => {
      setContent(menuItem.Page)
    }
  }

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "row",
      }}
    >
      <div style={{ width: "250px", flexShrink: 0, overflowY: "auto" }}>
        {/*<Button type="primary" onClick={html_Methods}>hahahah</Button>*/}
        <ul>
          {settingMenuMap.map((item)=>{
            return <li onClick={menuListDidClick(item)} key={item.Name}>{item.Name}</li>
          })}
        </ul>
      </div>

      <div style={{ flex: 1 }}>
        {content}
      </div>
    </div>
  );
};
