import {fetch} from "./base.service";

export const allLinks = (params) => {
    return fetch("links", "GET", params)
}

export const linkDetail = (params) => {
    return fetch("link", "GET",params)
}