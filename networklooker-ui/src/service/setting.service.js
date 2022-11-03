import {fetch} from "./base.service";

export const querySetting = () => {
    return fetch("api/setting", "GET", {})
}

export const saveSetting = (params) => {
    return fetch("api/setting", "POST",params)
}