// Debug script to log fetch requests
(function() {
  console.log("Debug script loaded");
  
  // Log all fetch requests
  const originalFetch = window.fetch;
  window.fetch = function(url, options) {
    console.log("Fetch request to:", url, options);
    
    // Check if this is an API request
    if (typeof url === "string" && url.includes("/api/")) {
      console.log("API request detected");
      console.log("ENV config:", window.ENV);
    }
    
    return originalFetch(url, options)
      .then(response => {
        console.log("Response from", url, "status:", response.status);
        return response;
      })
      .catch(error => {
        console.error("Fetch error for", url, ":", error);
        throw error;
      });
  };
  
  // Log when DOM is fully loaded
  document.addEventListener("DOMContentLoaded", function() {
    console.log("DOM fully loaded");
    console.log("ENV config:", window.ENV);
  });
  
  console.log("Current ENV config:", window.ENV);
})();
