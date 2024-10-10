public class ExtractTotalServiceFees {
    public class Request {
        @InvocableVariable(required=true)
        public String inputText;
    }

    public class Response {
        @InvocableVariable
        public Double totalEstimatedServiceFees;
    }

    @InvocableMethod
    public static List<Response> extractTotalEstimatedServiceFees(List<Request> requests) {
        List<Response> responses = new List<Response>();
        
        for (Request req : requests) {
            String inputText = req.inputText;
            Response res = new Response();
            Pattern pattern = Pattern.compile('totalEstimatedServiceFees: \\$(\\d{1,3}(,\\d{3})*(\\.\\d{2})?)');
            Matcher matcher = pattern.matcher(inputText);
            if (matcher.find()) {
                String feeStr = matcher.group(1).replace(',', '');
                res.totalEstimatedServiceFees = Double.valueOf(feeStr);
            } else {
                res.totalEstimatedServiceFees = 0.0; // default value if not found
            }
            responses.add(res);
        }
        return responses;
    }

    // Test method to run in anonymous window
    public static void testExtractTotalEstimatedServiceFees() {
        String inputText = 'contractType: Contract for Professional Services, client: ABC Corporation, projectName: Salesforce Data Cloud Integration, assessmentAndPlanning: Initial meeting to understand client requirements and objectives.\\nDetailed assessment of current systems and infrastructure.\\nProject Plan Development:Creation of a project plan with timelines, milestones, and resource allocation.\\nApproval of the project plan by the client., configurationAndSetup: System Configuration:Setup and configuration of Salesforce Data Cloud environment.\\nIntegration with existing Box infrastructure.\\nCustom Development:Development of custom connectors and APIs.\\nConfiguration of Data Cloud objects and data flows., deliverables: Project Plan Document\\nDetailed project plan outlining all phases, tasks, and timelines.\\nSystem Configuration Report\\nDocumentation of all configurations made in the Salesforce Data Cloud and Box environments.\\nCustom Connectors and APIs\\nSource code and documentation for all custom development work.\\nUser Training Sessions\\nConduct training sessions for client\'s team on using the new system., clientspecificDependencies: Access to Systems:Client must provide necessary access to existing systems and infrastructure.\\nTimely Approvals:Client must review and approve project documents and deliverables in a timely manner.\\nResource Availability:Client must ensure the availability of key personnel for meetings and decision-making., projectPersonnel: Project Manager: Jane Doe\\nResponsible for overall project management and client communication.\\nLead Developer: John Smith\\nResponsible for custom development and system configuration.\\nBusiness Analyst: Emily White\\nResponsible for requirement gathering and documentation., totalEstimatedServiceFees: $70,000, milestoneOrDeliverables: Milestone 1: Project Kick-off\\nCompletion Date: July 1, 2024\\nDeliverables: Project Kick-off Meeting Minutes\\nMilestone 2: Project Plan Development\\nCompletion Date: July 15, 2024\\nDeliverables: Project Plan Document\\nMilestone 3: System Configuration\\nCompletion Date: August 15, 2024\\nDeliverables: System Configuration Report\\nMilestone 4: Custom Development\\nCompletion Date: September 15, 2024\\nDeliverables: Custom Connectors and APIs\\nMilestone 5: User Training\\nCompletion Date: September 30, 2024\\nDeliverables: User Training Sessions';
        
        List<Request> requests = new List<Request>();
        Request req = new Request();
        req.inputText = inputText;
        requests.add(req);
        
        List<Response> responses = extractTotalEstimatedServiceFees(requests);
        System.debug('Extracted Total Estimated Service Fees: ' + responses[0].totalEstimatedServiceFees);
    }
}