import React from 'react';
import { mdx } from 'mdx.macro';

export const Covid19 = mdx`
# Get COVID-19 Status

In Touch's COVID-19 status is scraped directly from www.health.govt.nz and covid19.govt.nz for the latest active information.

The scraping script is located in [./src/data.ts](https://github.com/In-Touch-Hackathon/In-Touch-Backend/blob/master/src/data.ts).

This script is designed to be easily altered to support different websites.

***Note: *** **--insecure-http-parser** *** is used to ensure no errors will happen if scraped site gives an invalid header***
<code>Warning: Using insecure HTTP parsing</code>
<br/><br/>

## How we get COVID-19's current status

In Touch scrapes COVID-19's status using [health.govt.nz](https://www.health.govt.nz/our-work/diseases-and-conditions/covid-19-novel-coronavirus/covid-19-current-situation/covid-19-current-cases). 

![](../../images/covid19status.png)

We alse scrape the current Alert Level from [covid19.govt.nz](https://covid19.govt.nz/alert-system/current-covid-19-alert-level/).

![](../../images/covid19level.png)

We fetch the URL page every 12 hrs for updates.
<code>
load(fetch("Website_URL").text()) // Load HTML<br/>
load(fetch("Website_URL").text())('h3').text() // Extract content from &lt;h3&gt;Content&lt;/h3&gt; in html
</code><br/><br/>

## Customising Scraper

We can customise the scraper by changing the URL and elements in data.ts to scrape any website required.
The current fields in the Statistics interface can be easily changed and would be supported by the GET COVID-19 handler.
<code>
export interface Statistics &#123;<br/>
&emsp;&emsp;level: 0<br/>
&emsp;&emsp;cases: 0 // confirmed and probable<br/>
&emsp;&emsp;confirmed_cases: 0<br/>
&emsp;&emsp;probable_cases: 0<br/>
&emsp;&emsp;cases_in_hospital: 0<br/>
&emsp;&emsp;recovered: 0<br/>
&emsp;&emsp;deaths: 0<br/>
&emsp;&emsp;timestamp: string<br/>
&#125;<br/>
</code><br/>

`