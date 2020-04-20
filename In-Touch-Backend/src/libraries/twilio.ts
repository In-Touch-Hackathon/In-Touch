import * as twilio from 'twilio'

const accountSid = process.env.TWILIO_SID;
const authToken = process.env.TWILIO_SECRET;

const client = twilio(accountSid, authToken)

export {client as twilio}
