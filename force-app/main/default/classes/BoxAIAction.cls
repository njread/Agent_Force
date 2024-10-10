public with sharing class BoxAIAction {
    public static final String APPLICATION_ENCODED_HEADER = 'application/x-www-form-urlencoded';
    public static final String APPLICATION_JSON_HEADER = 'application/json';
    public static final String POST_METHOD = 'POST';
    public static final String AUTHORIZATION_HEADER = 'Authorization';
    public static final String CONTENT_TYPE_HEADER = 'Content-Type';
    public static final String AI_URL_STRING = 'https://api.box.com/2.0/ai/ask';
    public static final String TOKEN_URL_STRING = 'https://api.box.com/oauth2/token';

    public class BoxRequest {
        @InvocableVariable(label='Box AI Mode')
        public String boxAIMode;

        @InvocableVariable(label='Box AI Prompt')
        public String boxAIPrompt;

        @InvocableVariable(label='Box File IDs')
        public String boxFileIDs;
    }

    public class BoxResult {
        @InvocableVariable(label='Box AI Answer')
        public String boxAIAnswer;
    }

    @InvocableMethod(label='Box AI - Send Request' category='Box')
    public static List<BoxResult> sendAIRequest(List<BoxRequest> boxRequestList) {
        BoxClient boxClient = new BoxClient();
        List<BoxResult> boxResultList = new List<BoxResult>();

        for(BoxRequest boxRequest: boxRequestList) {
            BoxResult boxResult = new BoxResult();

            try {
                // Call the askQuestion method to get the AI-generated response
                String answer = askQuestion(
                    boxClient, 
                    boxClient.getAccessToken(), 
                    boxRequest.boxFileIDs, 
                    boxRequest.boxAIMode, 
                    boxRequest.boxAIPrompt
                );

                boxResult.boxAIAnswer = answer;
            } catch (Exception e) {
                // Log and handle the error
                System.debug('Error processing Box AI request: ' + e.getMessage());
                boxResult.boxAIAnswer = 'Error processing request: ' + e.getMessage();
            }

            boxResultList.add(boxResult);
        }
        return boxResultList;
    }

    private static String askQuestion(
        BoxClient boxClient, 
        String downscopedToken, 
        String fileIDs, 
        String boxAIMode,
        String boxAIPrompt) {

        // Set up the headers for the request
        Map<String, String> headers = new Map<String, String>();
        headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON_HEADER);
        headers.put(AUTHORIZATION_HEADER, 'Bearer ' + downscopedToken);

        // Create the Box AI request payload
        BoxAIQARequest aiRequest = new BoxAIQARequest();
        aiRequest.mode = boxAIMode;
        aiRequest.prompt = boxAIPrompt;

        // Set up the configuration for the AI request
        BoxAIQARequest.Config config = new BoxAIQARequest.Config();
        config.is_streamed = false;
        aiRequest.config = config;

        // Prepare the list of items (file IDs)
        List<String> fileIdList = fileIDs.split(',');
        List<BoxAIQARequest.Item> itemList = new List<BoxAIQARequest.Item>();
        for(String fileId: fileIdList) {  
            BoxAIQARequest.Item item = new BoxAIQARequest.Item();
            item.id = fileId;
            item.type = 'file';

            itemList.add(item);
        }

        aiRequest.items = itemList;

        // Serialize the request payload to JSON
        String requestBody = JSON.serialize(aiRequest, true);
        System.debug('Request Body: ' + requestBody);

        // Send the HTTP request to the Box AI endpoint
        HttpResponse response = boxClient.sendRequest(POST_METHOD, AI_URL_STRING, headers, requestBody);
        System.debug('Response Status: ' + response.getStatus());
        System.debug('Response Body: ' + response.getBody());

        // Process the response
        String answer;
        if(response.getStatusCode() == 200) {
            String body = response.getBody();
            BoxAIQAResponse aiResponse = BoxAIQAResponse.parse(body);
            answer = aiResponse.answer;
        } else {
            // Throw an exception if the request failed
            throw new BoxClientException(
                'BoxAIAction unable to execute Box AI request: ' + response.getBody()
            );  
        }

        return answer;
    }

    private static String getDownscopedToken(BoxClient boxClient) {
        String urlParameters = String.format(
            'grant_type={0}&subject_token={1}&subject_token_type={2}&scope={3}',
            new List<String>{
                'urn:ietf:params:oauth:grant-type:token-exchange',
                boxClient.getAccessToken(),
                'urn:ietf:params:oauth:token-type:access_token',
                'ai.readwrite'
            });

        Map<String, String> headers = new Map<String, String>();
        headers.put(CONTENT_TYPE_HEADER, APPLICATION_ENCODED_HEADER);

        // Get the downscoped token
        HttpResponse response = boxClient.sendRequest(POST_METHOD, TOKEN_URL_STRING, headers, urlParameters);
        System.debug('Found downscope token status: ' + response.getStatus());

        String downscopedToken;
        if(response.getStatusCode() == 200) {
            String body = response.getBody();
            AuthenticationResponse authResponse = AuthenticationResponse.parse(body);
            downscopedToken = authResponse.access_token;
        } else {
            throw new BoxClientException(
                'Failed to retrieve downscoped token: ' + response.getBody()
            );  
        }
       
        return downscopedToken;
    }

    public class BoxClientException extends Exception {
    }
}
