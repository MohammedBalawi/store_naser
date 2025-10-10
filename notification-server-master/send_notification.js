const { google } = require("googleapis");
const axios = require("axios");
const serviceAccount = require("./serviceAccountKey.json");

const SCOPES = ["https://www.googleapis.com/auth/firebase.messaging"];
const auth = new google.auth.GoogleAuth({
  credentials: serviceAccount,
  scopes: SCOPES,
});

const projectId = serviceAccount.project_id;
const messagingUrl = `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`;


async function sendNotification(title, body) {
  const client = await auth.getClient();
  const accessToken = await client.getAccessToken();

  const message = {
    message: {
      topic: "all_users", 
      notification: {
        title: title,
        body: body,
      },
      android: {
        priority: "high",
      },
      apns: {
        headers: {
          "apns-priority": "10",
        },
        payload: {
          aps: {
            sound: "default",
          },
        },
      },
    },
  };

  try {
    const res = await axios.post(messagingUrl, message, {
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken.token}`,
      },
    });
    console.log(" إشعار أرسل بنجاح:", res.data);
  } catch (err) {
    console.error(" فشل في الإرسال:", err.response?.data || err.message);
  }
}

