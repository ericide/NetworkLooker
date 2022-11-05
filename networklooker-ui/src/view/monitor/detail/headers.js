import React from "react";

export const HeadersView = ({ data }) => {
  if (data == null) {
    return <div></div>;
  }

  return (
    <table style={{ height: "1px" }}>
      <tbody>
        {data.request_header.map((item, index) => {
          return (
            <tr key={index} style={{ fontSize: "12px" }}>
              <td
                style={{
                  textAlign: "right",
                  whiteSpace: "nowrap",
                  width: "1px",
                }}
              >
                <a style={{ color: "#999999" }}>{item.k}</a>:
              </td>
              <td style={{ paddingLeft: "4px" }}>{item.v}</td>
            </tr>
          );
        })}
      </tbody>
    </table>
  );
};
