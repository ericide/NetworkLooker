import React, { useEffect, useState } from "react";

export const ListeningPortSettingComponent = ({ setting, setSetting }) => {
  const [sock5Port, setSock5Port] = useState(0);

  useEffect(() => {
    setSock5Port(setting.port);
  }, [setting]);

  const onValueChanged = (e) => {
    setSock5Port(e.target.value);
  };

  const saveClick = (e) => {
    setSetting((state) => ({
      ...state,
      port: sock5Port,
    }));
  };

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "row",
      }}
    >
      <input value={sock5Port} onChange={onValueChanged}></input>
      <button onClick={saveClick}>save</button>
    </div>
  );
};
