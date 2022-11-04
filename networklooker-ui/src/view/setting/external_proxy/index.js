import React, { useEffect, useState } from "react";

export const ExternalProxySettingComponent = ({ setting, setSetting }) => {
  const [externalProxy, setExternalProxy] = useState("");

  useEffect(() => {
    setExternalProxy(setting.external_proxy);
  }, [setting]);

  const onValueChanged = (e) => {
    setExternalProxy(e.target.value);
  };

  const saveClick = (e) => {
    setSetting((state) => ({
      ...state,
      external_proxy: externalProxy,
    }));
  };

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "row",
      }}
    >
      <input value={externalProxy} onChange={onValueChanged}></input>
      <button onClick={saveClick}>save</button>
    </div>
  );
};
