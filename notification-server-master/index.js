const express = require("express");
const { google } = require("googleapis");
const axios = require("axios");
const bodyParser = require("body-parser");
const cors = require("cors");
const serviceAccount = require("./serviceAccountKey.json");

const app = express();
const port = 3000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());

const SCOPES = ["https://www.googleapis.com/auth/firebase.messaging"];
const auth = new google.auth.GoogleAuth({
  credentials: serviceAccount,
  scopes: SCOPES,
});

const projectId = serviceAccount.project_id;
const messagingUrl = `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`;

app.post("/send-notification", async (req, res) => {
  const { title, body } = req.body;

  if (!title || !body) {
    return res.status(400).json({ error: "العنوان والمحتوى مطلوبان" });
  }

  try {
    const client = await auth.getClient();
    const accessToken = await client.getAccessToken();

    const message = {
      message: {
        topic: "all_users",
        notification: { title, body },
        android: {
          priority: "high",
        },
        apns: {
          headers: { "apns-priority": "10" },
          payload: {
            aps: {
              sound: "default",
            },
          },
        },
      },
    };

    const response = await axios.post(messagingUrl, message, {
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken.token}`,
      },
    });

    console.log(" تم إرسال الإشعار:", response.data);
    res.status(200).json({ success: true, message: "تم إرسال الإشعار بنجاح" });

  } catch (error) {
    console.error(" فشل في الإرسال:", error.response?.data || error.message);
    res.status(500).json({ error: "فشل في إرسال الإشعار", details: error.message });
  }
});

app.listen(port, () => {
  console.log(` السيرفر يعمل على: http://localhost:${port}`);
});
