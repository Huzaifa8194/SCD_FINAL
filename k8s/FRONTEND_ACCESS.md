# Frontend Access Instructions

## Accessing the Application

The frontend application has been configured to connect to the backend service. You can access it in two ways:

### 1. Using Port Forwarding

Port forwarding has been set up for both the frontend and backend services:
- Frontend: http://127.0.0.1:8080
- Backend: http://127.0.0.1:5000

### 2. Using NodePort

The frontend service is also exposed as a NodePort service on port 30080:
- Frontend: http://[minikube-ip]:30080

To get the minikube IP, run:
```
minikube ip
```

## Configuration Details

The frontend has been configured with:

1. An `env-config.js` file that sets the API URL to `http://backend:5000`
2. A `fetch-override.js` script that intercepts API calls to `http://localhost:5000/api/` and redirects them to the configured API URL

## Troubleshooting

If you're still having issues seeing data in the frontend:

1. **Check the backend API directly**
   ```
   curl http://127.0.0.1:5000/api/vehicles
   ```
   This should return JSON data of vehicles.

2. **Check browser console for errors**
   Open your browser's developer tools (F12) and look for any errors in the console.

3. **Verify the configuration files**
   ```
   kubectl exec [frontend-pod-name] -- cat /usr/share/nginx/html/env-config.js
   kubectl exec [frontend-pod-name] -- cat /usr/share/nginx/html/fetch-override.js
   ```

4. **Restart the frontend pod**
   ```
   kubectl rollout restart deployment/frontend
   ```

5. **Check if the modified index.html includes the scripts**
   ```
   kubectl exec [frontend-pod-name] -- cat /usr/share/nginx/html/index.html
   ```
   It should include references to both env-config.js and fetch-override.js. 