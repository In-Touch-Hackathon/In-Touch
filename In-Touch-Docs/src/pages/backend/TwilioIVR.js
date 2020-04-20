import React from 'react';
import { mdx } from 'mdx.macro';

export const TwilioIVR = mdx`
# Twilio IVR

The Twilio Interactive Voice Response allows us to pair volunteers with calls from the elderly using automation.
Twilio's IVR also allows In Touch to create custom and engaging calls. 


[Twilio has their own guide on IVR.](https://www.twilio.com/docs/voice/tutorials/ivr-phone-tree-node-express)

## How does Twilio Twiml Work?

Twilio Twiml is [Twilio's Markup Language](https://www.twilio.com/docs/voice/twiml) of instructions for incoming calls.

In Touch's IVR has three major parts:

1. Welcome caller
2. Keypad menu for caller to choose from
3. Conference rooms  

#### Welcome - **POST /ivr/welcome**
Greets caller with:
*Thanks for calling the In Touch Hotline. 
Please press 1 for current status of covid 19.
Press 2 to talk to a volunteer*, waiting and then gathering the input from user.

XML Response:
<code>
&lt;Response&gt;<br/>
&emsp;&emsp;&lt;Gather action="/ivr/menu" numDigits="1" method="POST"&gt;<br/>
&emsp;&emsp;&emsp;&emsp;&lt;Say&gt;Thanks for calling the In Touch Hotline. <br/>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Please press 1 for current status of covid 19. <br/>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Press 2 to talk to a volunteer.&lt;/Say&gt;<br/>
&emsp;&emsp;&lt;/Gather&gt;<br/>
&lt;/Response&gt;<br/>
</code><br/>

Using Twiml we can gather a one digit input from the user using **POST /ivr/menu**
<code>
&lt;Gather action="/ivr/menu" numDigits="1" method="POST"&gt;<br/>
</code>

<br/>

#### Menu - **POST /ivr/menu**
Processes the gathered input from user.

XML Response:
<code>
</code>
If the user inputs 1, reply with current Covid 19 status from scraped websites:<br/>
<code>
&lt;Response&gt;<br/>
&emsp;&emsp;&lt;Say voice="alice"&gt;In New Zealand, as of 9.00 am, 18 April 2020, there has been 1422 cases, 867 have recovered, and 11 have died.&lt;/Say&gt;<br/>
&lt;/Response&gt;<br/><br/> 
</code>
If the user inputs 2, put user into a calling queue with volunteers:<br/>
<code>
&lt;Response&gt;<br/>
&emsp;&emsp;&lt;Say voice="alice"&gt;Putting you through to our network of volunteers.&lt;/Say&gt;<br/>
&emsp;&emsp;&lt;Dial&gt;<br/>
&emsp;&emsp;&emsp;&emsp;&lt;Conference&gt;Random Room&lt;/Conference&gt;<br/>
&emsp;&emsp;&lt;/Dial&gt;<br/>
&lt;/Response&gt;<br/><br/>
</code>
If there is no input from the user, return the user back to the welcome page:<br/>
<code>
&lt;Response&gt;<br/>
&emsp;&emsp;&lt;Say voice="alice"&gt;Returning to the main menu&lt;/Say&gt;<br/>
&emsp;&emsp;&lt;Redirect&gt;/ivr/welcome&lt;Redirect&gt;<br/>
&lt;/Response&gt;<br/>

</code><br/>

If a user is in the queue for volunteers, FCM will message volunteers to pick up the call.

#### Conference Rooms - **POST /connect/:conferenceId**

When a volunteer chooses to pick up a call. The frontend (volunteer interface) can call **POST /connect/:conferenceId** while 
logged in to Firebase and Twilio will place the volunteer and caller into a conference room by using the volunteer's phone number.

The parameter :conferenceId is the conference room the current caller is waiting in.
`