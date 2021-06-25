const functions = require("firebase-functions");
const Firestore = require("@google-cloud/firestore");
const PROJECTID = "cloud-functions-firestore";
const COLLECTION_NAME = "cloud-functions-firestore";
const firestore = new Firestore({
  projectId: PROJECTID,
  timestampsInSnapshots: true,
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});


//Want to grab all of the event IDs from the DB that have expiring event times
exports.removeEndedEvents = functions.pubsub.schedule("every 5 minutes").onRun((context) => {
  console.log("This will be run every 5 minutes!");
  admin.firestore()
    .collection('users')
    .where('cars', 'array-contains', carRef)
    .get().then(snapshot => {
      snapshot.forEach(doc => {
        console.log("TESTING found the user " + doc.data().email);
        const message = {
          notification: {
            body: 'Your vehicle (' + carReg + ') recieved a report. Tap here to see!',
          },
          token: doc.data().cloudMessagingToken
        };
        sendMessage(message);
      });
      return
    }).catch(error => {
      console.error("Error finding a user that has the car in their garage");
      console.error(error);
    });
});

//Want to remove any events that will have finished within the last 24 hours
//In the future, might be better to archive, but for now, this will help reduce the space requirements.
