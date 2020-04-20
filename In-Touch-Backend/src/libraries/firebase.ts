import * as firebase from 'firebase-admin'

firebase.initializeApp({
    credential: firebase.credential.applicationDefault()
})

const db = firebase.firestore();
const fcm = firebase.messaging();

const modifyUser = async (uid: string, user: any) =>
    db.doc(`users/${uid}`).set(user)

const getUser = async (uid: string) =>
    db.doc(`users/${uid}`).get()

const getUserPhone = async (uid: string) =>
    getUser(uid).then(doc => doc.get('phoneNumber'))

const addCodeToFirebase = async (uid: string, code: string) => {
    const doc = db.doc(`codes/${uid}`)
    await doc.set({ code })

    return setTimeout(async doc => {
        console.log('deleting')
        await doc.delete()
    }, 5*60*1000, doc)
}

const verifyCode = async (uid: string, code: string) => {
    const doc = await db.doc(`codes/${uid}`).get()
    if (!doc.exists) {
        throw new Error('User does not exist')
    }
    console.log(doc.data())
    if (code !== doc.data().code) {
        throw new Error('Code does not match')
    }
    await db.doc(`users/${uid}`).set({verified: true}, { merge: true })
}

const sendNotification = async (from: string, id: string) => {
    const collection = await db.collection('users').get()
    for await (let user of collection.docs) {
        console.log(user.id)
        if (!user.get('fcmtokens')?.length) continue
        await fcm.sendMulticast({
            notification: {
                title: `${from} is requesting help...`,
                body: 'If you hear hold music, the other hand has hung up'
            },
            android: {
                ttl: 0,
                priority: 'high',
                notification: {
                    priority: 'max',
                    channelId: 'IncomingCalls'
                }
            },
            data: {
                id,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            },
            tokens: user.get('fcmtokens')
        })
    }
}

export { sendNotification, firebase, addCodeToFirebase, getUser, getUserPhone, modifyUser, verifyCode }