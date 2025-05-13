import React, { useEffect, useState } from "react";

function App() {
  const [vehicles, setVehicles] = useState([]);
  const [ocrData, setOcrData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        // Fetch data from the backend API
        const vehiclesResponse = await fetch("http://localhost:5000/api/vehicles");
        if (!vehiclesResponse.ok) {
          throw new Error(`Error fetching vehicles: ${vehiclesResponse.statusText}`);
        }
        const vehiclesData = await vehiclesResponse.json();

        const ocrResponse = await fetch("http://localhost:5000/api/ocr");
        if (!ocrResponse.ok) {
          throw new Error(`Error fetching OCR data: ${ocrResponse.statusText}`);
        }
        const ocrData = await ocrResponse.json();

        setVehicles(vehiclesData);
        setOcrData(ocrData);
      } catch (error) {
        console.error("Error fetching data:", error);
        setError(error.message);
        
        // Fallback to local JSON files if API is not available
        try {
          const resultResponse = await fetch("/data/result.json");
          const resultJson = await resultResponse.json();

          const ocrResponse = await fetch("/data/ocrresult.json");
          const ocrJson = await ocrResponse.json();

          setVehicles(resultJson);
          setOcrData(ocrJson);
          setError("Using local data (API unavailable)");
        } catch (fallbackError) {
          console.error("Error fetching local JSON data:", fallbackError);
          setError("Failed to load data from API and local files");
        }
      }
      setLoading(false);
    };

    fetchData();
  }, []);

  const safeDisplay = (value) => value || "Not available";

  return (
    <div style={{ backgroundColor: "#1a1a1a", color: "#e0e0e0", minHeight: "100vh", padding: "20px" }}>
      {loading ? (
        <div style={{ display: "flex", justifyContent: "center", alignItems: "center", height: "100vh", fontSize: "18px" }}>
          <div style={{
            width: "50px",
            height: "50px",
            border: "5px solid #ffcc00",
            borderTop: "5px solid transparent",
            borderRadius: "50%",
            animation: "spin 1s linear infinite"
          }}></div>
        </div>
      ) : (
        <>
          <h1 style={{ fontSize: "28px", fontWeight: "bold", marginBottom: "20px", color: "#ffcc00" }}>Vehicle Listings</h1>
          {error && (
            <div style={{ backgroundColor: "#442222", color: "#ffaaaa", padding: "10px", borderRadius: "5px", marginBottom: "20px" }}>
              {error}
            </div>
          )}
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))", gap: "20px" }}>
            {vehicles.map((vehicle) => {
              const matchingOcr = ocrData.find((ocr) => ocr.stock_number === vehicle.stock_number);
              const ocrVin = matchingOcr ? safeDisplay(matchingOcr.vinnumber) : "Not available";

              const maxImages = 5;
              const imageElements = [];
              for (let i = 1; i <= maxImages; i++) {
                const imageUrl = `/data/downloaded_images/${vehicle.stock_number}_${i}.jpg`;
                imageElements.push(
                  <img
                    key={i}
                    src={imageUrl}
                    alt={`Vehicle ${i}`}
                    style={{ width: "100px", height: "100px", objectFit: "cover", borderRadius: "8px", border: "1px solid #555" }}
                    onError={(e) => e.target.style.display = "none"}
                  />
                );
              }

              return (
                <div key={vehicle.stock_number} style={{ backgroundColor: "#2a2a2a", borderRadius: "10px", padding: "15px", boxShadow: "3px 3px 10px rgba(0, 0, 0, 0.5)", border: "1px solid #444" }}>
                  <h2 style={{ fontSize: "20px", fontWeight: "bold", marginBottom: "5px", color: "#ffcc00" }}>Stock #{safeDisplay(vehicle.stock_number)}</h2>
                  <p><strong>Timestamp:</strong> {safeDisplay(vehicle.timestamp)}</p>
                  <p><strong>Final Bid:</strong> {safeDisplay(vehicle.Final_Bid)}</p>

                  <div>
                    <strong>Details:</strong>
                    {vehicle.Details && Object.keys(vehicle.Details).length > 0 ? (
                      <ul style={{ paddingLeft: "20px" }}>
                        {Object.entries(vehicle.Details).map(([key, value]) => (
                          <li key={key}><strong>{key}:</strong> {safeDisplay(value)}</li>
                        ))}
                      </ul>
                    ) : (
                      <p>Not available</p>
                    )}
                  </div>

                  <div>
                    <strong>VIN Display:</strong>
                    <div dangerouslySetInnerHTML={{ __html: vehicle.VINDisplay || "Not available" }}></div>
                  </div>

                  <div>
                    <strong>OCR VIN:</strong> <span>{ocrVin}</span>
                  </div>

                  <div>
                    <strong>Images:</strong>
                    <div style={{ display: "flex", flexWrap: "wrap", gap: "10px", marginTop: "10px" }}>{imageElements}</div>
                  </div>

                  <a href={vehicle.stock_number_href || "#"} target="_blank" rel="noopener noreferrer"
                    style={{ display: "block", textAlign: "center", backgroundColor: "#ffcc00", color: "#222", fontWeight: "bold", padding: "10px", marginTop: "10px", borderRadius: "5px", textDecoration: "none" }}>
                    View More
                  </a>
                </div>
              );
            })}
          </div>
        </>
      )}
    </div>
  );
}

export default App;
