import React from 'react';
import { mdx } from 'mdx.macro';

export const Twilio = mdx`
# Signing up to Twilio

Get started with Twilio for free using a trial account.

## Create account

Create an account on [Twilio](https://www.twilio.com/try-twilio). 
A valid email and phone number is required to sign up for a Twilio trial account.

Create a new project with a customised name to get started with In Touch. Twilio 
provides free trial credit for every new project.

![](../../images/twiliosignup.png)

## Purchase Phone Number

A virtual phone number from twilio is required to receive calls using In Touch.

**Note: A "Regulatory Bundle" is required to purchase a number in New Zealand. 
This requires to give Twilio a proof of address.**

To create a Regulatory Bundle:

1. Go to [Twilio Console](https://www.twilio.com/console)

2. Click on the sidebar and goto All Project & Services > [Phone Numbers](https://www.twilio.com/console/phone-numbers)

3. Create a [Regulatory Bundle](https://www.twilio.com/console/phone-numbers/regulatory-compliance/bundles) ***(This requires a review that may take up to 3 days)***

![](../../images/twiliobundle.png)

4. Buy a new number in New Zealand

![](../../images/twilionumber.png)

*Note: New Zealand numbers do not support SMS. To get SMS to work a shortcode is required.*

5. Allow New Zealand Numbers to call this number. Programmable Voice > Geo Permissions > Tick New Zealand.

6. Enable [Agent Conferences](https://www.twilio.com/console/voice/conferences/settings).

## Account SID & Token

The account SID & token are stored in [Twilio's console Dashboard](https://www.twilio.com/console). These credentials are required to connect In Touch's backend to Twilio.

![](../../images/twiliohome.png)
`