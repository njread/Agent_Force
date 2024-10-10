public with sharing class MyEinsteinAction {

    @InvocableMethod(
        label = 'Process Record and Invoke Box AI', 
        description = 'This method collects a record ID, checks for an associated FRUP record, retrieves folder items from Box, and passes file IDs to the Box AI service for processing.'
    )
    public static void execute(List<Request> requests) {
        for (Request request : requests) {
            // Step 1: Check for associated FRUP record
            box__FRUP__c frupRecord = [SELECT Id, box__Folder_ID__c 
                                  FROM box__FRUP__c 
                                  WHERE box__Record_ID__c = :request.recordId 
                                  LIMIT 1];
            
            if (frupRecord != null) {
                // Step 2: Retrieve the Folder ID from the FRUP record
                String folderId = frupRecord.box__Folder_ID__c;
                
                // Step 3: Pass the Folder ID to the BoxGetFolderItemsAction class
                List<BoxGetFolderItemsAction.BoxRequest> boxRequests = new List<BoxGetFolderItemsAction.BoxRequest>();
                BoxGetFolderItemsAction.BoxRequest boxRequest = new BoxGetFolderItemsAction.BoxRequest();
                boxRequest.folderId = folderId;
                boxRequests.add(boxRequest);
                
                // Invoke the helper class method to get folder items
                List<BoxGetFolderItemsAction.BoxResult> boxResults = BoxGetFolderItemsAction.getFolderItems(boxRequests);

                // Step 4: Extract file IDs from the folder items and pass them to Box AI
                if (!boxResults.isEmpty()) {
                    for (BoxGetFolderItemsAction.BoxResult boxResult : boxResults) {
                        List<String> fileIds = new List<String>();
                        for (BoxGetFolderItemsAction.BoxItem boxItem : boxResult.folderItemsCollection) {
                            fileIds.add(boxItem.id);
                        }

                        // Prepare the AI request
                        List<BoxAIAction.BoxRequest> aiRequests = new List<BoxAIAction.BoxRequest>();
                        BoxAIAction.BoxRequest aiRequest = new BoxAIAction.BoxRequest();
                        aiRequest.boxAIMode = 'Summarization'; // Example mode, customize as needed
                        aiRequest.boxAIPrompt = 'Summarize the contents of these files'; // Example prompt, customize as needed
                        aiRequest.boxFileIDs = String.join(fileIds, ',');
                        aiRequests.add(aiRequest);

                        // Invoke the AI action
                        List<BoxAIAction.BoxResult> aiResults = BoxAIAction.sendAIRequest(aiRequests);

                        // Handle the AI results as needed
                        System.debug('Box AI Results: ' + aiResults);
                    }
                } else {
                    System.debug('No folder items found for Folder ID: ' + folderId);
                }
            } else {
                System.debug('No associated FRUP record found for Record ID: ' + request.recordId);
            }
        }
    }

    // The request class used to capture input parameters
    public class Request {
        @InvocableVariable(
            label = 'Record ID', 
            description = 'The ID of the record for which to process folder items and invoke Box AI.'
        )
        public Id recordId;  // ID of the record that the action applies to
    }
}
