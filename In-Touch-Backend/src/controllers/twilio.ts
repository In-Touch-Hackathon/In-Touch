import { Request, Response } from 'express'
import { randomBytes } from 'crypto'
import { promisify } from 'util'
import { twiml } from 'twilio'
import {speakStatistics, statistics} from "../data";
import {sendNotification} from "../libraries";
const { VoiceResponse } = twiml
const randomBytesAsync = promisify(randomBytes)

const welcome = (req: Request, res: Response) => {
    console.log(req)
    const twiml = new VoiceResponse()
    const gather = twiml.gather({
        action: '/ivr/menu',
        numDigits: 1,
        method: 'POST',
    });

    gather.say(
        'Thanks for calling the In Touch Hotline. ' +
        'Please press 1 for current status of covid 19. ' +
        'Press 2 to talk to a volunteer.'
    );
    res.type('text/xml');
    res.send(twiml.toString());
}

const menu = async (req: Request, res: Response) => {
    const { Digits, From } = req.body

    const optionActions = {
        '1': covid19Update,
        '2': callVolunteer,
    };

    var twimlResponse = optionActions[Digits]?.(From) ?? returnWelcome()
    res.type('text/xml')
    return res.send(await twimlResponse)
}

const covid19Update = async () => {
    const twiml = new VoiceResponse()
    twiml.say({'voice': 'alice'}, speakStatistics(statistics));
    return twiml.toString()
}

const callVolunteer = async (from: string) => {
    const twiml = new VoiceResponse()

    const roomId = (await randomBytesAsync(20)).toString('hex')

    sendNotification(from, roomId);

    twiml.say({'voice': 'alice'}, `Putting you through to our network of volunteers.`)
    twiml.dial().conference({maxParticipants: 2, startConferenceOnEnter: false}, roomId);
    return twiml.toString()
}

const returnWelcome = async () => {
    const twiml = new VoiceResponse()
    twiml.say({'voice': 'alice'}, 'Returning to the main menu')
    twiml.redirect('/ivr/welcome')
    return twiml.toString()
}

export { welcome, menu }