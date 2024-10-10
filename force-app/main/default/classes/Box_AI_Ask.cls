public with sharing class Box_AI_Ask {
    // ...

    public void asyncMethod() {
        box.Toolkit boxToolkit = new box.Toolkit();
        System.debug('toolkit started');
        String ASKBoxAI = 'https://api.box.com/2.0/metadata_instances/suggestions?item=file_1517874692924&scope=enterprise_964447513&template_key=aitest&confidence=experimental';

        // set the HTTP Request
        HttpRequest BoxAIRequest = new HttpRequest();
        String accessToken = 'mDgZ9L1mVqy7kM8vtDGzKXL0V3EMz6nk';
        BoxAIRequest.setMethod('GET');
        BoxAIRequest.setEndpoint(ASKBoxAI);
        BoxAIRequest.setHeader('Content-Type', 'application/json;version=1');
        BoxAIRequest.setHeader('Authorization', 'Bearer ' + accessToken);
        System.debug('Response build: '+BoxAIRequest);
        // Make the HTTP callout
        HttpResponse response = new Http().send(BoxAIRequest);
        
        System.debug('RESPONSE CODE: '+response);
        // Process the response or handle any errors here
        boxtoolkit.commitChanges();
    }
}