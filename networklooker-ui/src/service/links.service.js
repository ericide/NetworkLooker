import {fetch} from "./base.service";

export const allLinks = (params) => {
    return fetch("links", params)
}

export const linkDetail = (params) => {
    return fetch("link", params)
}