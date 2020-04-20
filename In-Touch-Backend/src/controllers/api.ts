import { Request, Response } from 'express'
import {modifyUser, addCodeToFirebase, getUserPhone, sendNotification, twilio, verifyCode} from '../libraries'
import { randomCode } from '../util'
import { modifyUser, getUser, firebase } from '../libraries'
import { statistics } from '../data'

const register = async (req: Request, res: Response) => {
    try {
        const { auth, body } = req
        const { phoneNumber, displayName } = body
        const user = {
            phoneNumber: phoneNumber,
            displayName: displayName,
            verified: false,
            lastModifed: firebase.firestore.FieldValue.serverTimestamp()
        }
        await modifyUser(auth.uid, user)
        res.status(200).send({ message: 'Created User' });
    } catch (err) {
        console.log(err)
        res.status(500).send({ message: 'An error occurred' })
    }
}

const self = async (req: Request, res: Response) => {
    try {
        res.status(200).send(await getUser(req.auth.uid));
    } catch (err) {
        console.log(err)
        res.status(500).send({ message: 'An error occurred' })
    }
}

const verify = async (req: Request, res: Response) => {
    const { auth } = req

    const phoneNumber = await getUserPhone(auth.uid)
    const code = randomCode()

    await addCodeToFirebase(auth.uid, code)

    console.log("calling")
    try {
        let result =  await twilio.calls
        .create({
            twiml: `<Response><Say>Your In Touch verification code is ${[...code].join('. ')}</Say></Response>`,
            to: phoneNumber,
            from: process.env.TWILIO_PHONE,
        })
        console.log(result)
        res.status(200).send({ message: 'Call sent successfully' })
    } catch (err) {
        console.log(err)
        res.status(500).send({ message: 'An error occurred' })
    }
}

const codeVerify = async (req: Request, res: Response) => {
    const { auth, body } = req
    try {
        await verifyCode(auth.uid, body.code)
        res.status(200).send({ message: 'Phone Number has been verified' });
    } catch (err) {
        console.log(err)
        res.status(500).send({ message: 'An error occurred' })
    }
}

const covid19 = async  (req: Request, res: Response) => {
    res.status(200).send(statistics)
}

const connect = async (req: Request, res: Response) => {
    const uid = req.auth.uid
    const conferenceId = req.params.conferenceId

    const user = await getUser(uid)
    if (!conferenceId)
        return res.status(400).send({ message: 'No conference id' })
    if (!user.get('verified'))
        return res.status(400).send({ message: 'User not verified' })

    const phoneNumber = await getUserPhone(uid)

    try {
        await twilio.conferences(conferenceId).participants.create({
            from: process.env.TWILIO_PHONE,
            to: phoneNumber,
            startConferenceOnEnter: true,
            endConferenceOnExit: true
        })

        await firebase.firestore().collection(`users/${uid}/calls`).add({
            number: phoneNumber,
            time: new Date()
        })

        res.status(201).send({message: 'Call send successfully'})
    } catch (e) {
        console.log(e)
        res.status(500).send({ message: 'Something went wrong' })
    }
}

export { connect, self, register, verify, covid19 }
