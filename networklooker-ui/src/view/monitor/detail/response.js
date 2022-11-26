import React, {useEffect, useState} from "react";
import { Base64 } from 'js-base64';

export const ResponseView = ({ data }) => {

    const [contentType, setContentType] = useState("")

    useEffect(()=>{
        let ct= ""
        data.response_header.forEach((item, index, arr) => {
            if (item.k === "content-type") {
                ct = item.v
            }
        })
        setContentType(ct)
    },[data])


    if (data == null) {
        return <div></div>
    }

    function render() {

        if (contentType.startsWith("image/")) {
            return <img src={`data:${contentType};base64,` + data.response_body} />
        }

        if (contentType.startsWith("text/")) {
            return <div>{Base64.decode(data.response_body)}</div>
        }

        if (contentType.startsWith("application/json")) {
            return <div>{Base64.decode(data.response_body)}</div>
        }

        return <></>
    }

    return (
        <div style={{wordBreak: "break-all"}}>
            {render()}
        </div>
    );
};

