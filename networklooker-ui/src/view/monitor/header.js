import React from "react";

export const HeaderView = ({headers}) => {
  return (
      <table>
      {headers.map((item) => {
        return (
          <tr style={{ fontSize: "12px" }}>
              <td style={{textAlign: "right", whiteSpace: "nowrap", width: "1px"}} >
                  <a style={{ color: "#999999" }}>{item.k}</a>:
              </td>
              <td style={{paddingLeft: "4px"}}>
                  {item.v}
              </td>
          </tr>
        );
      })}
    </table>
  );
};
