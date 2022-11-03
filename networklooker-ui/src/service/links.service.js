import {fetch} from "./base.service";

export const allLinks = (params) => {
    return fetch("api/links", "GET", params)
}

export const linkDetail = (params) => {
    return fetch("api/link", "GET",params)
}