import { body } from "express-validator";

const postRegister = [
    body("displayName").isString(),
    body("phoneNumber").isString(),
]

const postCode = [
    body("code").isString(),
]

export { postRegister, postCode }