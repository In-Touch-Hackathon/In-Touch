import React from 'react';
import { mdx } from 'mdx.macro';

export const Handlers = mdx`
# Handlers

This is the API Documentation for the REST API part of In Touch's backend.

## Routes
- POST **/ivr/welcome** - *Twilio IVR welcome*
- POST **/ivr/menu** - *Twilio IVR menu*
- POST **/connect/:id** - *Twilio conference*
- POST **/register** - *Register phone number and display name after registing with Firebase auth*
- POST **/verify** - *Send verification code through phone number*
- GET **/covid19** - *Get current Covid 19 status*
- GET **/healthcheck** - *Healthcheck of API*

#### POST **/ivr/welcome**
This is the Twilio IVR welcome. The Twilio Webhook will call this when a call comes in.

###### Parameters:
None

###### Response:
text/xml
<code>
&lt;Response&gt;<br/>
&emsp;&emsp;&lt;Gather action="/ivr/menu" numDigits="1" method="POST"&gt;<br/>
&emsp;&emsp;&emsp;&emsp;&lt;Say&gt;Thanks for calling the In Touch Hotline. <br/>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Please press 1 for current status of covid 19. <br/>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Press 2 to talk to a volunteer.&lt;/Say&gt;<br/>
&emsp;&emsp;&lt;/Gather&gt;<br/>
&lt;/Response&gt;<br/>
</code><br/>

#### POST **/ivr/menu**
This is the Twilio IVR menu.

###### Parameters:
<code>
Body: &#123;<br/>
&emsp;&emsp;Digits: 0 <br/>
&#125;<br/>
</code><br/>

###### Response:
text/xml
<code>
</code>
IF Digits == 1<br/>
<code>
&lt;Response&gt;<br/>
&emsp;&emsp;&lt;Say voice="alice"&gt;In New Zealand, as of 9.00 am, 18 April 2020, there has been 1422 cases, 867 have recovered, and 11 have died.&lt;/Say&gt;<br/>
&lt;/Response&gt;<br/> 
</code>
IF Digits == 2<br/>
<code>
&lt;Response&gt;<br/>
&emsp;&emsp;&lt;Say voice="alice"&gt;Putting you through to our network of volunteers.&lt;/Say&gt;<br/>
&emsp;&emsp;&lt;Dial&gt;<br/>
&emsp;&emsp;&emsp;&emsp;&lt;Conference&gt;Random Room&lt;/Conference&gt;<br/>
&emsp;&emsp;&lt;/Dial&gt;<br/>
&lt;/Response&gt;<br/>
</code>
ELSE<br/>
<code>
&lt;Response&gt;<br/>
&emsp;&emsp;&lt;Say voice="alice"&gt;Returning to the main menu&lt;/Say&gt;<br/>
&emsp;&emsp;&lt;Redirect&gt;/ivr/welcome&lt;Redirect&gt;<br/>
&lt;/Response&gt;<br/>

</code><br/>

#### POST **/connect/:id**
This calls the user into the conference room.
- Require Auth

###### Parameters:
:id - conference room id

###### Response:
application/json
<code>
&#123;<br/>
&emsp;&emsp;message: 'Call send successfully'<br/>
&#125;<br/>
</code><br/>

#### POST **/register**
This registers phone number and display name on the Flutter app after registing with Firebase Auth.

###### Parameters:
<code>
Body: &#123;<br/>
&emsp;&emsp;displayName: string <br/>
&emsp;&emsp;phoneNumber: string <br/>
&#125;<br/>
</code><br/>

###### Response:
application/json
<code>
&#123;<br/>
&emsp;&emsp;message: 'Created User'<br/>
&#125;<br/>
</code><br/>

#### POST **/verify**
This calls the logged-in user's phone number on the Flutter app and tells the user their verification code, which expires in 5 minutes of the call being made.
- Require Auth

###### Response:
application/json
<code>
&#123;<br/>
&emsp;&emsp;message: 'Call send successfully'<br/>
&#125;<br/>
</code><br/>

#### GET **/covid19** 
This gets the current Covid 19 status for the Flutter app.

###### Response:
application/json
<code>
&#123;<br/>
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

#### GET **/healthcheck**
This returns a health check on the API.

###### Response
application/json
<code>
&#123;<br/>
&emsp;&emsp;message: 'HealthCheck intouch-backend OK'<br/>
&#125;<br/>
</code><br/>

`