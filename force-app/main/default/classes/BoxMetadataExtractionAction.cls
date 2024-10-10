public class BoxMetadataExtractionAction {
    public static final String METHOD_POST = 'POST';
    public static final String CONTENT_TYPE_HEADER = 'Content-Type';
    public static final String APPLICATION_JSON_HEADER = 'application/json';
    public static final String MD_EXTRACT_URL_STRING = 'https://api.box.com/2.0/ai/extract_structured';

    public class BoxRequest {
        @InvocableVariable(label='Box Item Collection')
        public List<BoxItem> boxItemCollection;
    
        @InvocableVariable(label='Box Metadata Template')
        public BoxMetadataTemplate boxMetadataTemplate;

    }
    
    public class BoxResult {
        @InvocableVariable(label='HTTP Status Code')
        public Integer httpStatusCode;
    
        @InvocableVariable(label='HTTP Status')
        public String httpStatus;
    
        @InvocableVariable(label='HTTP Response Body')
        public String httpResponseBody;

    }
    
    
    @InvocableMethod(label='Extract Metadata' category='Box AI' callout=true)
    public static List<BoxResult> extractMetadata(List<BoxRequest> boxRequestList) {
        List<BoxResult> boxResultList = new List<BoxResult>();

        for(BoxRequest boxRequest: boxRequestList) {
            BoxResult boxResult = extractMetadataCallout(boxRequest.boxItemCollection, boxRequest.boxMetadataTemplate); 
            boxResultList.add(boxResult);
        }
        return boxResultList;
    }

    private static BoxResult extractMetadataCallout(List<BoxItem> boxItemCollection, BoxMetadataTemplate boxMetadataTemplate) {
        BoxResult boxResult = new BoxResult();
        box.Toolkit boxToolkit = new box.Toolkit();

        BoxMetadataExtractionRequest mdExtractRequest = new BoxMetadataExtractionRequest();
        List<BoxMetadataExtractionRequest.Item> boxItemList = new List<BoxMetadataExtractionRequest.Item>();
        for(BoxItem boxItemInReq: boxItemCollection) {
            BoxMetadataExtractionRequest.Item boxItem = new BoxMetadataExtractionRequest.Item();
            boxItem.id = boxItemInReq.id;
            boxItem.type = boxItemInReq.type;
            boxItemList.add(boxItem);
        }
        BoxMetadataExtractionRequest.MetadataTemplate mdTemplate = new BoxMetadataExtractionRequest.MetadataTemplate();
        mdTemplate.template_key = boxMetadataTemplate.templateKey;
        mdTemplate.type = 'metadata_template';
        mdTemplate.scope = boxMetadataTemplate.scope;

        mdExtractRequest.items = boxItemList;
        mdExtractRequest.metadata_template = mdTemplate;
        
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod(METHOD_POST);
        httpRequest.setEndpoint(MD_EXTRACT_URL_STRING);
        httpRequest.setHeader(CONTENT_TYPE_HEADER, APPLICATION_JSON_HEADER);
        httpRequest.setTimeout(60000);
        httpRequest.setBody(JSON.serialize(mdExtractRequest));

        HttpResponse mdExtractionHttpResponse = boxToolkit.sendRequest(httpRequest);
        String mdExtractionResBody = mdExtractionHttpResponse.getBody();
        System.debug('Found response: ' + mdExtractionResBody);
        
        boxResult.httpStatusCode = mdExtractionHttpResponse.getStatusCode();
        boxResult.httpStatus = mdExtractionHttpResponse.getStatus();
        boxResult.httpResponseBody = mdExtractionHttpResponse.getBody();
        return boxResult;
    }
}