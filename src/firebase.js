// Import Firebase SDK
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
// Your Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyBoR6NqnUwGgYrgM8G8ytxEMpy8pMQ9kuk",
  authDomain: "iaai-b2c68.firebaseapp.com",
  projectId: "iaai-b2c68",
  storageBucket: "iaai-b2c68.appspot.com", // Corrected storageBucket domain
  messagingSenderId: "225983680731",
  appId: "1:225983680731:web:3b081f88a535a73cddbcfe"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);

export default app;
