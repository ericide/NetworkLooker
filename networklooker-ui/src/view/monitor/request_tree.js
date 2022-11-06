import React, { useEffect, useState } from "react";

export const RequestTree = ({ dataSource, onClick }) => {
  const [requests, setRequests] = useState([]);

  useEffect(() => {
    const l = dataSource.sort((a, b) => {
      return b.id - a.id;
    })
    setRequests(l)

  }, [dataSource]);

  return (
    <div style={{ width: "100%" }}>
      {requests.map((item) => {
        return (
          <div
            style={{
              backgroundColor: "green",
              margin: "8px",
              height: "60px",
              padding: "16px",
              overflow: "hidden",
            }}
            onClick={(e) => onClick(item.id)}
            key={item.id}
          >
            <div>
              <span
                style={{
                  color: "black",
                  fontSize: "10px",
                  display: "inline-block",
                  border: "1px solid gray",
                  marginRight: "8px",
                }}
              >
                {item.method}
              </span>
              {item.id}
              <a style={{ color: "black", fontSize: "10px" }}>{item.host}</a>
            </div>
            <div>
              <a style={{ color: "black", fontSize: "10px" }}>{item.uri}</a>
            </div>
          </div>
        );
      })}
    </div>
  );
};
