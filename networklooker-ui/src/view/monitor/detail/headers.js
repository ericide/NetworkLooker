import React from "react";

export const HeadersView = ({ data }) => {
  if (data == null) {
    return <div></div>;
  }

  function buildRow(key, k, v) {
    return (
      <tr key={key} style={{ fontSize: "12px" }}>
        <td
          style={{
            textAlign: "right",
            whiteSpace: "nowrap",
            width: "1px",
          }}
        >
          <a style={{ color: "#999999" }}>{k}</a>:
        </td>
        <td style={{ paddingLeft: "4px" }}>{v}</td>
      </tr>
    );
  }

  return (
    <table style={{ height: "1px" }}>
      <tbody>
        <p>request</p>
        {buildRow("req_proto", "proto", data.request_proto)}
        {buildRow("req_method", "method", data.method)}
        {buildRow("req_uri", "uri", data.uri)}
        {data.request_header.map((item, index) => {
          return buildRow(index, item.k, item.v);
        })}
        <p>response</p>

        <tr>
          <td>response</td>
          <td></td>
        </tr>
        {buildRow("resp_proto", "proto", data.response_proto)}
        {buildRow("resp_status", "status", data.response_status)}
        {data.response_header.map((item, index) => {
          return buildRow(index, item.k, item.v);
        })}
      </tbody>
    </table>
  );
};
