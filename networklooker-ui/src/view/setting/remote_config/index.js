import React, { useEffect, useState } from "react";

export const RemoteConfigSettingComponent = ({ setting, setSetting }) => {
  const [remoteConfigList, setRemoteConfigList] = useState([]);

  useEffect(() => {
    setRemoteConfigList(setting.remote_config ?? []);
  }, [setting]);

  const onValueChanged = (index, point, item) => (e) => {
    setRemoteConfigList((state) => {
      state[index][point][item] = e.target.value;
      return [...state];
    });
  };

  const saveClick = (e) => {
    setSetting((state) => ({
      ...state,
      remote_config: remoteConfigList,
    }));
  };

  const addClick = (e) => {
    setRemoteConfigList((state) => [
      ...state,
      {
        source: { port: 0, host: "", path: "" },
        destination: { port: 0, host: "", path: "" },
      },
    ]);
  };

  function renderConfigItem(item, index) {
    console.log(item, index);
    return (
      <div key={index} style={{ border: "1px dashed gray", padding: "4px" }}>
        <div>
          <label>source:</label>
          <br />
          <input
            value={item.source.port}
            onChange={onValueChanged(index, "source", "port")}
          ></input>
          <input
            value={item.source.host}
            onChange={onValueChanged(index, "source", "host")}
          ></input>
          <input
            value={item.source.path}
            onChange={onValueChanged(index, "source", "path")}
          ></input>
        </div>
        <div>
          <label>destination:</label>
          <br />
          <input
            value={item.destination.port}
            onChange={onValueChanged(index, "destination", "port")}
          ></input>
          <input
            value={item.destination.host}
            onChange={onValueChanged(index, "destination", "host")}
          ></input>
          <input
            value={item.destination.path}
            onChange={onValueChanged(index, "destination", "path")}
          ></input>
        </div>
      </div>
    );
  }

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
      }}
    >
      {remoteConfigList.map((item, index) => renderConfigItem(item, index))}
      <button onClick={addClick}>Add</button>
      <button onClick={saveClick}>save</button>
    </div>
  );
};
