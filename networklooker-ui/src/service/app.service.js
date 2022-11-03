import {fetch} from "./base.service";

export const startEngine = () => {
    return fetch("engine/start", "POST", {})
}

export const stopEngine = (params) => {
    return fetch("engine/close", "POST", {})
}