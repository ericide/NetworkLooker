import {fetch} from "./base.service";

export const allLinks = (params) => {
    return fetch("api/connection/requests", "GET", params)
}

export const linkDetail = (params) => {
    return fetch("api/connection/request", "GET",params)
}