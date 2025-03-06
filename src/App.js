import React, { useEffect, useState } from "react";
import { getFirestore, collection, getDocs } from "firebase/firestore";
import app from "./firebase"; // Ensure Firebase is initialized

const db = getFirestore(app);

function App() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const querySnapshot = await getDocs(collection(db, "newdata"));
        const fetchedData = querySnapshot.docs.map((doc) => ({
          id: doc.id,
          ...doc.data(),
        }));
        setData(fetchedData);
      } catch (error) {
        console.error("Error fetching data:", error);
      }
      setLoading(false);
    };
    fetchData();
  }, []);

  if (loading) {
    return (
      <div style={{
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        height: "100vh",
        backgroundColor: "#1a1a1a",
        color: "#ccc",
        fontSize: "18px"
      }}>
        <div style={{
          width: "50px",
          height: "50px",
          border: "5px solid #ffcc00",
          borderTop: "5px solid transparent",
          borderRadius: "50%",
          animation: "spin 1s linear infinite"
        }}></div>
      </div>
    );
  }

  return (
    <div style={{
      backgroundColor: "#1a1a1a",
      color: "#e0e0e0",
      minHeight: "100vh",
      padding: "20px"
    }}>
      <h1 style={{
        fontSize: "28px",
        fontWeight: "bold",
        marginBottom: "20px",
        color: "#ffcc00"
      }}>
        Vehicle Listings
      </h1>

      <div style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))",
        gap: "20px"
      }}>
        {data.map((vehicle) => {
          const details = vehicle.Details || {}; // Ensure Details exist

          return (
            <div key={vehicle.id} style={{
              backgroundColor: "#2a2a2a",
              borderRadius: "10px",
              padding: "15px",
              boxShadow: "3px 3px 10px rgba(0, 0, 0, 0.5)",
              border: "1px solid #444"
            }}>
              <h2 style={{
                fontSize: "20px",
                fontWeight: "bold",
                marginBottom: "5px",
                color: "#ffcc00"
              }}>
                Stock #{vehicle.stock_number}
              </h2>

              {/* Displaying details from Firestore */}
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>ACV:</strong> {details.ACV || "N/A"}</p>
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>Airbags:</strong> {details.Airbags || "N/A"}</p>
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>Cylinders:</strong> {details.Cylinders || "N/A"}</p>
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>Est. Repairs:</strong> {details["Est. Repairs"] || "N/A"}</p>
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>Keys:</strong> {details.Keys || "N/A"}</p>
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>Loss Type:</strong> {details["Loss Type"] || "N/A"}</p>
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>ODO:</strong> {details.ODO || "N/A"}</p>
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>Primary Damage:</strong> {details["Primary Damage"] || "N/A"}</p>
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>Secondary Damage:</strong> {details["Secondary Damage"] || "N/A"}</p>
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>Start Code:</strong> {details["Start Code"] || "N/A"}</p>
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>Transmission:</strong> {details.Transmission || "N/A"}</p>
              <p style={{ margin: "5px 0", fontSize: "14px" }}><strong>Final Bid:</strong> {vehicle.Final_Bid || "N/A"}</p>

              {/* Display all images */}
              {vehicle.Images && vehicle.Images.length > 0 && (
                <div style={{
                  display: "flex",
                  flexWrap: "wrap",
                  gap: "10px",
                  marginTop: "10px"
                }}>
                  {vehicle.Images.map((image, index) => (
                    <img
                      key={index}
                      src={image}
                      alt={`Vehicle ${index + 1}`}
                      style={{
                        width: "100px",
                        height: "100px",
                        objectFit: "cover",
                        borderRadius: "8px",
                        border: "1px solid #555"
                      }}
                    />
                  ))}
                </div>
              )}

              <a
                href={vehicle.stock_number_href}
                target="_blank"
                rel="noopener noreferrer"
                style={{
                  display: "block",
                  textAlign: "center",
                  backgroundColor: "#ffcc00",
                  color: "#222",
                  fontWeight: "bold",
                  padding: "10px",
                  marginTop: "10px",
                  borderRadius: "5px",
                  textDecoration: "none"
                }}
              >
                View More
              </a>
            </div>
          );
        })}
      </div>
    </div>
  );
}

export default App;
