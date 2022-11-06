import React, { useEffect, useState } from "react";
import { allLinks, linkDetail } from "../../service/links.service";
import { RequestTree } from "../../view/monitor/request_tree";
import {DetailView} from "./detail";

export const MonitorPage = () => {
  const [tick, setTick] = useState(0);
  const [requestList, setRequestList] = useState([]);

  const [curReqId, setCurReqId] = useState(null)

  useEffect(() => {
    loadRequests();
  }, [tick]);

  async function loadRequests() {

    allLinks({ start: requestList.length }).then((res) => {
      console.log(res);
      setRequestList((c)=>([...c, ...res.data.data]));
      setTick((c)=>c+1)
    }).catch((e)=>{
      console.log(e)
      setTimeout(function(){
        setTick((c)=>c+1)
      }, 2000)
    });
  }

  const onClick = (e) => {
    setCurReqId(e)
  };

  const renderBootButton = (isOn) => {
    if (isOn === true) {
      return <button onClick={onStopClick}>stop</button>;
    } else if (isOn === false) {
      return <button onClick={onStartClick}>start</button>;
    } else {
      return <button>-</button>;
    }
  };

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "row",
        height: "100%"
      }}
    >
      <div style={{ width: "300px", flexShrink: 0, overflowY: "auto" }}>
        {/*<Button type="primary" onClick={html_Methods}>hahahah</Button>*/}
        <RequestTree
          onClick={onClick}
          dataSource={requestList}
        />
      </div>

      <div style={{ display: "flex", flexDirection: "column" }}>
        <DetailView id={curReqId}/>
      </div>
    </div>
  );
};
