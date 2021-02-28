import firebase from "firebase/app";
import "firebase/auth";

const app = firebase.initializeApp({
  apiKey: "AIzaSyCp-rGmyQAdVC580A9dYqKNZ3SP-PJs6aM",
  authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.REACT_APP_FIREBASE_MSG_SENDER_ID,
  appId: process.env.REACT_APP_FIREBASE_APP_ID,
  measurementId: process.env.REACT_APP_FIREBASE_MEASUREMENT_ID,
});

export const auth = app.auth();
export default app;
