import React, { useEffect, useState } from "react";

export const WatchingListSettingComponent = ({ setting, setSetting }) => {
  const [monitoringList, setMonitoringList] = useState([]);

  useEffect(() => {
    setMonitoringList(setting.monitoring ?? []);
  }, [setting]);

  const onValueChanged = (index) => (e) => {
    setMonitoringList((state) => {
      state[index] = e.target.value;
      console.log(state);
      return [...state];
    });
  };

  const saveClick = (e) => {
    setSetting((state) => ({
      ...state,
      monitoring: monitoringList,
    }));
  };

  const addClick = (e) => {
    setMonitoringList((state) => [...state, ""]);
  };

  function renderMonitoringItem(item, index) {
    console.log(item, index);
    return (
      <div key={index}>
        <input value={item} onChange={onValueChanged(index)}></input>
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
      {monitoringList.map((item, index) => renderMonitoringItem(item, index))}
      <button onClick={addClick}>Add</button>
      <button onClick={saveClick}>save</button>
    </div>
  );
};
