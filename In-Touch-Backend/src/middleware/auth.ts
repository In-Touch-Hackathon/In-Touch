import { Request, Response } from 'express';
import { firebase } from '../libraries';
import DecodedIdToken = firebase.auth.DecodedIdToken;

declare module 'express' {
    interface Request {
        auth: DecodedIdToken
    }
}

export const auth = async (req: Request, res: Response, next: Function) => {
    try {
        const [type, token] = req.headers.authorization.split(' ')

        if (type !== 'Bearer') {
            return res.status(401).send({ message: 'Unauthorized' })
        }

        req.auth = await firebase.auth().verifyIdToken(token)
    } catch (e) {
        return res.status(401).send({ message: 'Unauthorized' })
    }
    next()
}
