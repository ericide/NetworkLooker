import React from "react";

export const ResponseView = ({ data }) => {
    if (data == null) {
        return <div></div>
    }
    return (
        <div style={{wordBreak: "break-all"}}>
            {data.response_body}
        </div>
    );
};

