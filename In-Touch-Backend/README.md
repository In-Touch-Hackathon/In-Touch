# In Touch Backend

In Touch Backend is written in Typescript Node JS ES6. This project is designed to be easily
build on. The following docs will teach you how to use and build on this template.

Main frameworks:
- [Express](https://expressjs.com/)
- [Twilio](https://www.twilio.com/docs/voice/quickstart/node)
- [Firebase Authenication](https://firebase.google.com/docs/auth)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Nodemon](https://nodemon.io/)

***Go to [docs.intouch.tk](https://docs.intouch.tk/) for more info***

## Installation

In Touch backend requires [Twilio credentials](https://docs.intouch.tk/getting-started/twilio) and [Firebase credentials](https://docs.intouch.tk/getting-started/firebase).

Please ensure Node version is v12.15.0 or newer
```node -v```

If you see the following error please update node.
```--insecure-http-parser is not allowed in NODE_OPTIONS```

#### Install dependencies

Install project dependencies using [yarn](https://classic.yarnpkg.com/en/docs/install/)
```
cd In-Touch-Backend
yarn install
```

#### Setup .env

Rename [.env-example](https://github.com/In-Touch-Hackathon/In-Touch-Backend/blob/master/.env-example) to .env and setup variables

```
## .env
# general
PORT=3000
# twilio
TWILIO_SID=AC0000000000000000000000
TWILIO_SECRET=0000000000000000000000
TWILIO_PHONE=+640000000
# firebase
GOOGLE_APPLICATION_CREDENTIALS="/file/location/in-touch-firebase-adminsdk.json"
```

| Variables                              | Value         |
| -------------------------------------- | ------------- |
| PORT                                   | REST API Port |
| TWILIO_SID                             | [Twilio SID](https://docs.intouch.tk/getting-started/twilio)      |
| TWILIO_SECRET                          | [Twilio Secret](https://docs.intouch.tk/getting-started/twilio)     |
| TWILIO_PHONE                           | [Purchased phone number](https://docs.intouch.tk/getting-started/twilio) |
| GOOGLE_APPLICATION_CREDENTIALS &emsp;&emsp; | [JSON file from service account](https://docs.intouch.tk/getting-started/firebase) |

#### Run Backend

In Touch Backend is setup with Nodemon with hot reload

```yarn start```

Build project into JS

```yarn build```

#### Twilio Web Hook

To get In Touch to handle incoming calls, set the end point of your Twilio phone number to point to the backend API.

For example my backend is routed to https://intouch.tk/. 
***Please ensure your API is accessible publicly.***
Set the default Web hook into http://YOUR_IP:3000/ivr/welcome. /ivr/welcome is the default handler for incoming calls in this project

![](https://docs.intouch.tk//images/twiliowebhook.png)

You can also use Ngrok shown by twilio. [Allow Twilio to talk to your application](https://www.twilio.com/docs/voice/quickstart/node#allow-twilio-to-talk-to-your-application)

## License

    Copyright (c) 2020 In Touch

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.