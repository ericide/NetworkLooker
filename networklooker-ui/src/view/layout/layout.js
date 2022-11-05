import React, { useEffect, useState } from "react";
import {
  getEngineStatus,
  startEngine,
  stopEngine,
} from "../../service/app.service";
import {SettingPage} from "../setting";
import {MonitorPage} from "../monitor";

export const MainLayout = () => {
  const [contentMode, setContentMode] = useState("monitor");
  const [engineStatus, setEngineStatus] = useState(null);

  useEffect(() => {
    // html_Methods();
    const i = setInterval(function () {
      // html_Methods()
    }, 1000);
    return () => {
      clearInterval(i);
    };
  }, []);

  useEffect(() => {
    refreshStatus();
  }, []);

  async function refreshStatus() {
    const res = await getEngineStatus();
    console.log(res.data.data.running);
    setEngineStatus(res.data.data.running);
  }

  async function onStartClick(e) {
    await startEngine();
    refreshStatus();
  }

  async function onStopClick(e) {
    await stopEngine();
    refreshStatus();
  }

  function onSettingClick(e) {
    if (contentMode === "monitor") {
      setContentMode("setting")
    } else {
      setContentMode("monitor")
    }
  }

  const renderBootButton = (isOn) => {
    if (isOn === true) {
      return <button onClick={onStopClick}>stop</button>;
    } else if (isOn === false) {
      return <button onClick={onStartClick}>start</button>;
    } else {
      return <button>-</button>;
    }
  };

  function renderContent() {
    if (contentMode === "monitor") {
      return <MonitorPage/>
    } else {
      return <SettingPage/>
    }
  }

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        position: "fixed",
        left: "0",
        right: "0",
        top: "0",
        bottom: "0",
      }}
    >
      <div style={{
            display: "flex",
            flexDirection: "row",}}>
        <div style={{marginRight: "8px"}}>{renderBootButton(engineStatus)}</div>
        <button onClick={onSettingClick}>setting</button>
      </div>
      <div
        style={{
          flex: 1,
          overflow: "auto"
        }}
      >
        {renderContent()}

      </div>
    </div>
  );
};
