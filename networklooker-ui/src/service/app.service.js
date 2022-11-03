import {fetch} from "./base.service";

export const startEngine = () => {
    return fetch("api/engine/start", "POST", {})
}

export const stopEngine = () => {
    return fetch("api/engine/close", "POST", {})
}

export const getEngineStatus = () => {
    return fetch("api/engine/status", "GET", {})
}