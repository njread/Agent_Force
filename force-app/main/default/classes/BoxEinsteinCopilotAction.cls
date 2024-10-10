public with sharing class BoxEinsteinCopilotAction {

    // Inner classes for input and output structures
    public class BoxRequest {
        @InvocableVariable(label='Record ID')
        public String recordId;
        
        @InvocableVariable(label='Box AI Prompt')
        public String boxAIPrompt;
    }

    public class BoxResult {
        @InvocableVariable(label='Box AI Answer')
        public String boxAIAnswer;
    }

    // Main method that will be called by Einstein Copilot
    @InvocableMethod(label='Box - Einstein Copilot Action' category='Box')
    public static List<BoxResult> processRequest(List<BoxRequest> boxRequestList) {
        List<BoxResult> results = new List<BoxResult>();
        
        for (BoxRequest boxRequest : boxRequestList) {
            BoxResult result = new BoxResult();

            try {
                // Step 1: Query the box_FRUP__c object to get the folder ID
                box__FRUP__c frupRecord = getFRUPRecord(boxRequest.recordId);

                // Step 2: Get items from the folder using BoxGetFolderItemsAction
                List<String> fileIds = getFileIdsFromFolder(frupRecord.box__Folder_ID__c);

                // Step 3: Pass the file IDs and prompt to the Box AI Action
                if (!fileIds.isEmpty()) {
                    String csvFileIds = String.join(fileIds, ',');
                    result.boxAIAnswer = callBoxAI(csvFileIds, boxRequest.boxAIPrompt);
                } else {
                    result.boxAIAnswer = 'No files found in the folder.';
                }
                
            } catch (Exception e) {
                result.boxAIAnswer = 'Error processing request: ' + e.getMessage();
            }

            results.add(result);
        }
        
        return results;
    }

    // Helper method to query the box_FRUP__c object and return the folder ID
    private static box__FRUP__c getFRUPRecord(String recordId) {
        box__FRUP__c frupRecord = [
            SELECT box__Folder_ID__c 
            FROM box__FRUP__c 
            WHERE box__Record_ID__c = :recordId 
            LIMIT 1
        ];
        return frupRecord;
    }

    // Helper method to get file IDs from the folder using BoxGetFolderItemsAction
    private static List<String> getFileIdsFromFolder(String folderId) {
        List<String> fileIds = new List<String>();
    
        // Creating a request for folder items
        BoxGetFolderItemsAction.BoxRequest folderRequest = new BoxGetFolderItemsAction.BoxRequest();
        folderRequest.folderId = folderId;
    
        // Getting the folder items from Box
        List<BoxGetFolderItemsAction.BoxResult> folderResults = BoxGetFolderItemsAction.getFolderItems(new List<BoxGetFolderItemsAction.BoxRequest>{folderRequest});
    
        // If we have results, iterate over them
        if (!folderResults.isEmpty()) {
            // Loop through the folder items collection
            for (BoxGetFolderItemsAction.BoxResult result : folderResults) {
                if (result.folderItemsCollection != null) {
                    // Adjust this loop if BoxItem is nested inside another class
                    for (BoxItem item : result.folderItemsCollection) { 
                        // Check if the item is of type 'file'
                        if (item.type == 'file') {
                            fileIds.add(item.id);
                        }
                    }
                }
            }
        }
    
        return fileIds;
    }
    // Helper method to call the Box AI API using the BoxAIAction class
    private static String callBoxAI(String fileIds, String prompt) {
        BoxAIAction.BoxRequest aiRequest = new BoxAIAction.BoxRequest();
        aiRequest.boxFileIDs = fileIds;
        aiRequest.boxAIPrompt = prompt;
        aiRequest.boxAIMode = 'multiple_item_qa'; // You can change this mode as needed

        List<BoxAIAction.BoxResult> aiResults = BoxAIAction.sendAIRequest(new List<BoxAIAction.BoxRequest>{aiRequest});

        return aiResults.isEmpty() ? 'No response from Box AI.' : aiResults[0].boxAIAnswer;
    }
}
