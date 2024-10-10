public class HttpRequestExample {
    public HttpResponse makeHttpRequest(String url, String accessToken) {
        // Create a new HTTP request and set the endpoint URL
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.box.com/2.0/metadata_instances/suggestions?item=file_1517874692924&scope=enterprise_964447513&template_key=aitest&confidence=experimental');
        request.setMethod('GET'); // You can change this to 'POST', 'PUT', etc. as needed

        // Set headers for the request
        request.setHeader('Content-Type', 'application/json;version=1');
        request.setHeader('Authorization', 'Bearer ' + accessToken); // Add Authorization header

        // Create a new HTTP instance to send the request
        Http http = new Http();
        HttpResponse response;
        String suggestionsVar = 'suggestions';
        try {
            // Send the request and receive the response
            response = http.send(request);
            
            // Log the status code and body for debugging
            System.debug('*****Response Code: ' + response.getStatusCode() + '*****');
            if (response.getStatusCode() == 200) {
                // Process the response body
                String responseBody = response.getBody();
                Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                System.debug(data);
                
                // Check if 'suggestions' exists and is a map
                if (data.containsKey(suggestionsVar) && data.get(suggestionsVar) instanceof Map<String, Object>) {
                    Map<String, Object> suggestions = (Map<String, Object>) data.get(suggestionsVar);
                    
                    // Extract metadata attributes from the Map
                    String orderNumber = (String) suggestions.get('orderNumber');
                    String invoiceNumber = (String) suggestions.get('invoiceNumber');
                    
                    // Debug output to verify the values
                    System.debug('Order Number: ' + orderNumber);
                    System.debug('Invoice Number: ' + invoiceNumber);
                    
                    // Prepare the HTTP request for updating metadata
                    HttpRequest metadataRequest = new HttpRequest();
                    metadataRequest.setEndpoint('https://api.box.com/2.0/files/1517874692924/metadata/enterprise_964447513/aitest');
                    metadataRequest.setMethod('PUT');
                    metadataRequest.setHeader('Content-Type', 'application/json-patch+json');
                    metadataRequest.setHeader('Authorization', 'Bearer ' + accessToken);
                
                    // Create JSON body dynamically
                    String jsonBody = '[{"op":"replace","path":"/orderNumber","value":"'+orderNumber+'"},{"op":"replace","path":"/invoiceNumber","value":"'+invoiceNumber+'"}]';
                    metadataRequest.setBody(jsonBody);
                    
                    // Send the HTTP request and capture the response
                    Http http2 = new Http();
                    HttpResponse metadataResponse = http2.send(metadataRequest);
                    
                    // Log response details
                    System.debug('*****Metadata Response Code: ' + metadataResponse.getStatusCode() + '*****');
                    System.debug('*****Metadata Response Body: ' + metadataResponse.getBody() + '*****');
                


                    // Optionally, you can use 'orderNumber' and 'invoiceNumber' as needed in your code
                } else {
                    System.debug('The key \'suggestions\' is missing or is not a Map');
                }
            } else {
                // Handle non-200 status codes
                System.debug('HTTP Request failed with status: ' + response.getStatusCode());
            }
        } catch(System.CalloutException e) {
            // Handle the exception in case of a connection error
            System.debug('Callout error: ' + e.getMessage());
            response = new HttpResponse();
            response.setStatusCode(500);
            response.setBody('Callout error: ' + e.getMessage());
        }

        // Return the response object and commit the box toolkit changes
        return response;
    }
}