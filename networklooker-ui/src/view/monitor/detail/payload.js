import React from "react";

export const PayloadView = ({ data }) => {
    if (data == null) {
        return <div></div>
    }
    return (
        <div>
            {data.request_body}
        </div>
    );
};
