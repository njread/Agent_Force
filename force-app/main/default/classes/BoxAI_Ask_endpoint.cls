public with sharing class BoxAI_Ask_endpoint {
    private static final String BOX_AI_ENDPOINT = 'https://api.box.com/2.0/ai/ask';
    private static final String ACCESS_TOKEN = '4AiKtPU9gQ4DXpC86FzPLIP0E0DQkgkq';

    public BoxAI_Ask_endpoint() {

    }

    public class BoxAIResponse {
        public String id;
        public String text;
        // Add more fields based on the expected response
    }

    public BoxAIResponse askBoxAI(String fileId, String prompt) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BOX_AI_ENDPOINT);
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + ACCESS_TOKEN);
        request.setHeader('Content-Type', 'application/json');

        String body = '{"mode": "question_answering", "prompt": "' + prompt + '", "file_id": "' + fileId + '"}';
        request.setBody(body);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            return (BoxAIResponse) JSON.deserialize(response.getBody(), BoxAIResponse.class);
        } else {
            throw new CalloutException('Error in Box AI callout: ' + response.getBody());
        }
    }
}
