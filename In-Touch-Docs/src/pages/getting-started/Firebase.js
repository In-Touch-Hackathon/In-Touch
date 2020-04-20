import React from 'react';
import { mdx } from 'mdx.macro';

export const Firebase = mdx`
# Setting up Google Firebase

In Touch is built using [Firebase's](https://firebase.google.com/) authenication and database.
Firebase allows In Touch to be easily setup and maintained. 
In Touch stores all its data on the cloud and can be easily accessed and backed up.

## Create a Project in Firebase

Go to the [Firebase Console](https://console.firebase.google.com/) and click "Add Project".

![](../../images/googlecreateproject.png)

## Create a Firestore database

1. Go to "Database" inside your newly created project

![](../../images/googlefirestore.png)

2. Start in production mode

3. Select a Cloud Firestore location close to New Zealand e.g australia-southeast1

## Setup Firebase Authentication 

1. Go to "Authentication" inside your newly created project

2. Enable the sign-in methods that you want to implement in your frontend (In Touch's Flutter app support Email/Password and Google Sign-In)

*Note: a third party token may be required for some sign-in providers.*

![](../../images/googleauth.png)

## Download Google Credentials

A Google service account is required to authenicate In Touch with your Firebase project.

#### Backend

1. Create a service acount for the Firebase admin SDK
2. Download the service account JSON (required for setting up backend)

#### Flutter App

1. Create an Android app
2. Enter in your customised package name for Android e.g com.company.intouch
3. Download google-services.json (required for setting up flutter)

`