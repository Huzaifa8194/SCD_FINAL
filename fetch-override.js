const originalFetch = window.fetch;
window.fetch = function(url, options) {
  // Check if the URL is an API call to localhost:5000
  if (typeof url === "string" && url.startsWith("http://localhost:5000/api/")) {
    // Replace with the configured API URL
    const apiUrl = window.ENV?.API_URL || "http://localhost:5000";
    const newUrl = url.replace("http://localhost:5000", apiUrl);
    console.log(`Redirecting API call from ${url} to ${newUrl}`);
    return originalFetch(newUrl, options);
  }
  // Otherwise, use the original fetch
  return originalFetch(url, options);
}; 