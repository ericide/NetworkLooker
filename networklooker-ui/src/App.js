import React, {useEffect, useState} from 'react';
import {allLinks, linkDetail} from "./service/links.service";
import {getEngineStatus, startEngine, stopEngine} from "./service/app.service";
import {HeaderView} from "./view/monitor/header";
import { RequestTree} from "./view/monitor/request_tree";

const App = () => {

    const [data, setData] = useState([])

    const [engineStatus, setEngineStatus] = useState(null)

    const [requestHeader, setRequestHeader] = useState([])
    const [responseHeader, setResponseHeader] = useState([])

    const [requestBody, setRequestBody] = useState("")
    const [responseBody, setResponseBody] = useState("")

    useEffect(() => {
        html_Methods()
        const i = setInterval(function (){
            // html_Methods()
        },1000)
        return () => {
            clearInterval(i)
        }
    },[])

    useEffect(() => {
        refreshStatus()
    },[])

    async function refreshStatus()  {
        const res = await getEngineStatus()
        console.log(res.data.data.running)
        setEngineStatus(res.data.data.running)
    }

    function html_Methods() {
        // allLinks({start: 100}).then((res) => {
        //
        //     console.log(res)
        //     setData(res)
        //
        // })
    }

    async function onStartClick(e) {
        await startEngine()
        refreshStatus()
    }
    async function onStopClick(e) {
        await stopEngine()
        refreshStatus()
    }

    const onClick = (e) => {
        linkDetail({id: e}).then((res) => {
            console.log(res)

            // let list11 = Object.keys(res.request_header).map(item => {
            //
            //     return {
            //         name: item,
            //         value: res.request_header[item]
            //     }
            // })
            //
            // list1.push(...list11)
            //
            //
            // let list22 = Object.keys(res.response_header).map(item => {
            //
            //     return {
            //         name: item,
            //         value: res.response_header[item]
            //     }
            // })
            //
            // let list2 = [{
            //     name: "status",
            //     value: res.status_code
            // }]
            // list2.push(...list22)

            setRequestHeader(res.request_header)
            setResponseHeader(res.response_header)

            // const decodedString1 = decodeURIComponent(escape(atob(res.request_body)));
            // setRequestBody(decodedString1)
            //
            // const decodedString = decodeURIComponent(escape(atob(res.response_body)));
            // setResponseBody(decodedString)
        })
    }

    const renderBootButton = (isOn) => {
        if (isOn === true) {
            return <button onClick={onStopClick}>stop</button>
        } else if (isOn === false) {
            return <button onClick={onStartClick}>start</button>
        } else {
            return <button>-</button>
        }
    }

    return (
        <div style={{display: "flex", flexDirection: "row", position: "fixed", left: 0, right: 0, top: 0, bottom: 0}}>

            {renderBootButton(engineStatus)}
            <div style={{width: "250px", flexShrink: 0, overflowY: "auto"}}>
                {/*<Button type="primary" onClick={html_Methods}>hahahah</Button>*/}
                <RequestTree onClick={onClick}
                    style={{height: "100%"}}
                    dataSource={data}
                />
            </div>

            <div style={{display: "flex", flexDirection: "column"}}>


                <div style={{flex: 1, flexShrink: 0, overflow: "auto"}}>
                    <HeaderView headers={requestHeader}/>
                    {requestBody}
                </div>
                <div style={{backgroundColor: "black", height: "2px"}}></div>
                <div style={{flex: 1, flexShrink: 0, overflow: "auto"}}>
                    <HeaderView headers={responseHeader}/>
                    {responseBody}
                </div>
            </div>
        </div>
    )

};

export default App;