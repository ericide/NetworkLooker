import React, { useEffect, useState } from "react";
import { linkDetail } from "../../../service/links.service";
import { HeadersView } from "./headers";
import {PayloadView} from "./payload";
import {ResponseView} from "./response";

export const DetailView = ({ id }) => {
  const [detailData, setDetailData] = useState(null);
  const [showTab, setShowTab] = useState(0);

  useEffect(() => {
    if (id == null) {
      return;
    }
    linkDetail({ id }).then((res) => {
      setDetailData(res.data.data);
    });
  }, [id]);

  return (
    <div>
      <div>
        <button
          onClick={() => {
            setShowTab(0);
          }}
        >
          headers
        </button>
        <button
          onClick={() => {
            setShowTab(1);
          }}
        >
          payload
        </button>
        <button
          onClick={() => {
            setShowTab(2);
          }}
        >
          response
        </button>
      </div>
      {showTab == 0 && <HeadersView data={detailData}/>}
      {showTab == 1 && <PayloadView data={detailData}/>}
      {showTab == 2 && <ResponseView data={detailData}/>}
    </div>
  );
};
