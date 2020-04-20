import React from 'react';
import { mdx } from 'mdx.macro';

export const ProjectNode = mdx`
# Project Struture

In Touch's Node.JS project is designed to be easily understood and configurable

Folder Structure:
<code>
./src  <br/>
&emsp;&emsp;&emsp;&emsp;/controllers<br/>
&emsp;&emsp;&emsp;&emsp;/libraries<br/>
&emsp;&emsp;&emsp;&emsp;/middleware<br/>
&emsp;&emsp;&emsp;&emsp;/models<br/>
</code><br/>

| Folder             | Usage        |
| --------------------- | ------------- |
| Controllers           | REST API handlers  |
| Libraries             | Handles Firebase and Twilio     |
| Middleware&emsp;&emsp;| REST API middlewares     |
| Models                | REST API validation models |
<br/>


#### Controllers

- Twilio Controller - handles Twilio web hook (required to handle incoming calls)
- API - handles general REST Api calls
- Heathcheck - handles healthcheck (required for k8s in the future)

#### Libraries

- Firebase - handles all Firestore and FCM
- Twilio - handles Twilio SDK

#### Middleware

- Auth - handles Firebase token check using bearer
- Validator - handles validating POST request in Express

#### Models

- Validation Models required for validating POST request in Express


![](../../images/backendstructure.png)
`

