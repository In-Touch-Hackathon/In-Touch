import {Router} from "express";
import { urlencoded } from 'body-parser'

import { welcome, menu } from './controllers/twilio'
import { healthcheck } from './controllers/healthcheck'
import { register, verify, covid19, connect } from './controllers/api'

import { validate, auth } from "./middleware"
import { postRegister } from "./models"

const routes = (router: Router): Router => {

    // Twilio Incoming Call
    router.post('/ivr/welcome', urlencoded({ extended: false }), welcome)
    router.post('/ivr/menu', urlencoded({ extended: false }), menu)

    // HealthCheck
    router.get('/healthcheck', healthcheck)

    // Verify SMS
    router.post('/verify', auth, verify)

    router.post('/connect/:conferenceId', auth, connect)

    // Register - phone number + name only
    router.post('/register',auth, postRegister, validate, register)

    // Covid19 
    router.get('/covid19', covid19)

    return router
}

export { routes }