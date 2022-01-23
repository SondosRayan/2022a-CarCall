/* eslint no-var: 0 */
import * as functions from "firebase-functions";
import {messaging} from "firebase-admin";


export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

var admin = require("firebase-admin");
var serviceAccount = require("../service-account.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://carcall-91150.firebaseio.com",
});

const fcm = admin.messaging();
const db = admin.firestore().collection("versions").doc("v2");

export const SendAlertToDevice = functions.firestore
    .document("versions/v2/Users/{userId}/Alerts/{alertId}")
    .onCreate(async (snapshot, context) =>{
      const alert = snapshot.data();
      const querySnapshot = await db.collection("Users").doc(context.params.userId)
          .collection("tokens").get();
      const tokens = querySnapshot.docs.map((snap) => snap.id);

      var options = {
        priority: "high",
        timeToLive: 60 * 60 * 24,
      };

      const NotificationsMsg = "Hello, " + alert.sender_name + " sent you an alert: " + alert.type;

      console.log("alert type: ", alert.type);
      const payload = {
        notification: {
          title: "Alert",
          body: NotificationsMsg,
          alert: "true",
          channel_id: "206601031",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      db.collection("Notifications").add(alert);
      return fcm.sendToDevice(tokens, payload, options);
    });

export const SendMsgToDevice = functions.firestore
    .document("versions/v2/messages/{convId}/{id}/{msgId}")
    .onCreate(async (snapshot) =>{
      const msg = snapshot.data();
      const querySnapshot = await db.collection("Users").doc(msg.idTo)
          .collection("tokens").get();

      const tokens = querySnapshot.docs.map((snap) => snap.id);

      var options = {
        priority: "high",
        timeToLive: 60 * 60 * 24,
      };

      const NotificationsMsg = msg.content;
      const NotificationTitle = "New Message From " + msg.senderName;

      console.log("msg: ", msg.content, " sender name ", msg.senderName);
      const payload = {
        notification: {
          title: NotificationTitle,
          body: NotificationsMsg,
          alert: "true",
          channel_id: "206601031",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      return fcm.sendToDevice(tokens, payload, options);
    });


export const SendOfferToDevice = functions.firestore
    .document("versions/v2/Users/{userId}/Offers/{offerId}")
    .onCreate(async (snapshot, context) =>{
      const alert = snapshot.data();
      const querySnapshot = await db.collection("Users").doc(context.params.userId)
          .collection("tokens").get();
      const tokens = querySnapshot.docs.map((snap) => snap.id);
      const NotificationsMsg = "Hello, " + alert.sender_name + " sent you a help offer with: " + alert.type;
      const payload = {
        notification: {
          title: "Help Offer",
          body: NotificationsMsg,
          alert: "true",
          channel_id: "206601031",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      db.collection("Notifications").add(alert);
      return fcm.sendToDevice(tokens, payload);
    });

export const sendBroadcastNotification = functions.https
    .onRequest(async (req, res) =>{
      if (req.method !== "POST") {
        // Handle only POST requests
        return;
      }
      const title = req.body.title;
      const body = req.body.message;
      const tokens = req.body.tokens;
      const message = {
        notification: {
          title: title,
          body: body,
        },
        tokens: tokens,
      } as messaging.MulticastMessage;

      // Send a message to devices subscribed to the provided topic.
      try {
        const response = await admin.messaging().sendMulticast(message);
        // Response is a message ID string.
        console.log("Successfully sent message:", response);
        res.status(200).json(response);
      } catch (error) {
        console.log("Error sending message:", error);
        res.status(500).json({
          error: error,
        });
      }
    });
