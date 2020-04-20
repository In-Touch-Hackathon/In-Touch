import {load} from 'cheerio'
import fetch from 'node-fetch'

const DATA_SOURCE = 'https://www.health.govt.nz/our-work/diseases-and-conditions/covid-19-novel-coronavirus/covid-19-current-situation/covid-19-current-cases'
const LEVEL = 'https://covid19.govt.nz/alert-system/current-covid-19-alert-level/'

export let statistics: Statistics = null

export interface Statistics {
    level: number
    cases: number // confirmed and probable
    confirmed_cases: number
    probable_cases: number
    cases_in_hospital: number
    recovered: number
    deaths: number
    timestamp: string
}

export const speakStatistics = (stats: Statistics) => {
    return `In New Zealand, as of ${stats.timestamp}, there has been ${stats.cases} cases`
        + `, ${stats.recovered} have recovered, and ${stats.deaths} have died.`
}

export const fetchData = async () => {
    let response = await fetch(DATA_SOURCE)
    let body = await response.text()
    let parser = load(body)
    let timestamp = parser('table caption').first().text().replace('As at ', '')
    let stats: Statistics = {
        level: null,
        cases: null,
        confirmed_cases: null,
        probable_cases: null,
        cases_in_hospital: null,
        recovered: null,
        deaths: null,
        timestamp: timestamp,
    };
    parser('tbody tr').each((_, e) => {
        let header = parser('th', e).text()
        if (header.startsWith('Number of confirmed cases')) {
            stats.confirmed_cases = parseRow(parser, e)
        } else if (header.startsWith('Number of probable')) {
            stats.probable_cases = parseRow(parser, e)
        } else if (header.startsWith('Number of confirmed and probable')) {
            stats.cases = parseRow(parser, e)
        } else if (header.startsWith('Number of cases currently in hospital')) {
            stats.cases_in_hospital = parseRow(parser, e)
        } else if (header.startsWith('Number of recovered')) {
            stats.recovered = parseRow(parser, e)
        } else if (header.startsWith('Number of deaths')) {
            stats.deaths = parseRow(parser, e)
        }
    })
    let levelparser = load(await (await fetch(LEVEL)).text())
    stats.level = Number(levelparser('div h3').first().text().replace('Level ', ''))
    return stats;
}

export const scheduleDataFetch = async () => {
    statistics = await fetchData()
    setInterval(async () => {
        statistics = await fetchData()
    }, 12 * 60 * 60 * 1_000) // Updates every 12 hours (half a day)
}

const parseRow = (parser, element): number => {
    return parseInt(parser('td', element).first().text().replace(',', ''))
}
