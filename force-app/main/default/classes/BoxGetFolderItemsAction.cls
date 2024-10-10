public with sharing class BoxGetFolderItemsAction {
    public static final String METHOD_GET = 'GET';
    public static final String CONTENT_TYPE_HEADER = 'Content-Type';
    public static final String APPLICATION_JSON_HEADER = 'application/json';
    public static final String FOLDER_ITEMS_URL_STRING = 'https://api.box.com/2.0/folders/{0}/items';

    public class BoxRequest {
        @InvocableVariable(label='Folder Id')
        public String folderId;
    }

    public class BoxResult {
        @InvocableVariable(label='Folder Items Collection')
        public List<BoxItem> folderItemsCollection;

        @InvocableVariable(label='Folder Items JSON')
        public String folderItemsJson;
    }


    @InvocableMethod(label='Get Folder Items' category='Box' callout=true)
    public static List<BoxResult> getFolderItems(List<BoxRequest> boxRequestList) {

        List<BoxResult> boxResultList = new List<BoxResult>();
        for(BoxRequest boxRequest: boxRequestList) {
            BoxResult boxResult = new BoxResult();
            box.Toolkit boxToolkit = new box.Toolkit();

            String folderItemsEndpoint = String.format(FOLDER_ITEMS_URL_STRING, 
            new List<String> {boxRequest.folderId});            
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setMethod(METHOD_GET);
            httpRequest.setEndpoint(folderItemsEndpoint);
            httpRequest.setHeader(CONTENT_TYPE_HEADER, APPLICATION_JSON_HEADER);

            HttpResponse folderItemsHttpResponse = boxToolkit.sendRequest(httpRequest);
            String folderItemResponseBody = folderItemsHttpResponse.getBody();
            System.debug('Found response: ' + folderItemResponseBody);

            List<BoxItem> boxItemList = new List<BoxItem>();
            if (folderItemsHttpResponse.getStatus() == 'OK') {
                BoxFolderItemsResponse folderItemsResponse = BoxFolderItemsResponse.parse(folderItemResponseBody);
                System.debug('Found list size: ' + folderItemsResponse.entries.size());

                //Loop through children
                for(BoxFolderItemsResponse.BoxItem boxItemRes: folderItemsResponse.entries){
                    System.debug('Found item with id: ' + boxItemRes.id + ', type: ' + boxItemRes.type + ', name: ' + boxItemRes.name);

                    BoxItem boxItem = new BoxItem();
                    boxItem.id = boxItemRes.id;
                    boxItem.name = boxItemRes.name;
                    boxItem.sha1 = boxItemRes.sha1;
                    boxItem.type = boxItemRes.type;
                    boxItemList.add(boxItem);
                }
            }
            boxResult.folderItemsJson = folderItemResponseBody;
            boxResult.folderItemsCollection = boxItemList;
            boxResultList.add(boxResult);
        }
        return boxResultList;
    }
}