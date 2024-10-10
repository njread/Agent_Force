public with sharing class Nicks_test_BOX_AI_Class{
    public static void executeFlow(String recordId, String boxAIPrompt) {
        // Default values for Box AI Mode and Prompt if not provided
        String boxAIMode = 'multiple_item_qa';
        if (String.isBlank(boxAIPrompt)) {
            boxAIPrompt = 'What is the total contract value?';
        }

        // Step 1: Retrieve the box__FRUP__c record based on Record ID
        box__FRUP__c frupRecord = [SELECT box__Folder_ID__c FROM box__FRUP__c WHERE box__Record_ID__c = :recordId LIMIT 1];
        if (frupRecord == null || String.isBlank(frupRecord.box__Folder_ID__c)) {
            System.debug('No FRUP record found or Folder ID is blank.');
            return;
        }

        // Step 2: Call the BoxGetFolderItems action to retrieve folder items
        String folderId = frupRecord.box__Folder_ID__c;
        BoxGetFolderItems boxFolderItems = new BoxGetFolderItems();
        BoxGetFolderItems.BoxRequest folderRequest = new BoxGetFolderItems.BoxRequest();
        folderRequest.recordId = recordId;

        List<BoxGetFolderItems.BoxRequest> folderRequestList = new List<BoxGetFolderItems.BoxRequest>{ folderRequest };
        List<BoxGetFolderItems.BoxResult> folderResults = boxFolderItems.getFolderItems(folderRequestList);

        if (folderResults.isEmpty() || folderResults[0].folderItemsCollection.isEmpty()) {
            System.debug('No folder items found.');
            return;
        }

        // Step 3: Loop through folder items, concatenate file IDs
        String fileIDs = '';
        for (BoxGetFolderItems.BoxItem item : folderResults[0].folderItemsCollection) {
            if (item.type == 'file') {
                fileIDs += item.id + ',';
            }
        }
        fileIDs = fileIDs.removeEnd(','); // Remove the trailing comma

        // Step 4: Call the Box AI Action to get the AI response
        BoxAIAction boxAIAction = new BoxAIAction();
        BoxAIAction.BoxRequest aiRequest = new BoxAIAction.BoxRequest();
        aiRequest.boxAIMode = boxAIMode;
        aiRequest.boxAIPrompt = boxAIPrompt;
        aiRequest.boxFileIDs = fileIDs;

        List<BoxAIAction.BoxRequest> aiRequestList = new List<BoxAIAction.BoxRequest>{ aiRequest };
        List<BoxAIAction.BoxResult> aiResults = boxAIAction.sendAIRequest(aiRequestList);

        // Step 5: Store the AI Response
        if (!aiResults.isEmpty()) {
            String boxAIResponseText = aiResults[0].boxAIAnswer;
            System.debug('AI Response: ' + boxAIResponseText);
            // Store the response in a field, or perform further actions as needed
        }
    }
}