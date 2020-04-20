import { Request, Response } from 'express'

export const healthcheck = (req: Request, res: Response) => {
    res.status(200).send({
        message: 'HealthCheck intouch-backend OK',
    });
}
