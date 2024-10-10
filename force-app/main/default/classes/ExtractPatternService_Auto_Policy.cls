public with sharing class ExtractPatternService_Auto_Policy {
        public class Request {
            @InvocableVariable(required=true)
            public String inputText;
        }
    
        public class Response {
            @InvocableVariable
            public String policyNumber;
            @InvocableVariable
            public String policyHolderName;
            @InvocableVariable
            public Date policyEffectiveStartDate1;
            @InvocableVariable
            public Date policyEffectiveEndDate1;
            @InvocableVariable
            public String agencyProvidingCoverage;
            @InvocableVariable
            public String policyType;
            @InvocableVariable
            public String coverageForStatePropertyAndCasualtyInsuranceGuaranty;
            @InvocableVariable
            public String bodilyInjuryLiability;
            @InvocableVariable
            public String lossOfClothingPayment;
            @InvocableVariable
            public String rightToAppraisal;
            @InvocableVariable
            public String autoComprehensiveInsurance;
            @InvocableVariable
            public String whatIsThisDocumentAbout;
        }
    
        @InvocableMethod
        public static List<Response> extractPatterns(List<Request> requests) {
            List<Response> responses = new List<Response>();
            
            for (Request req : requests) {
                String inputText = req.inputText;
                Response res = new Response();
    
                // Extract Policy Number
                Pattern policyNumberPattern = Pattern.compile('policyNumber\': (\\d+)');
                Matcher policyNumberMatcher = policyNumberPattern.matcher(inputText);
                if (policyNumberMatcher.find()) {
                    res.policyNumber = policyNumberMatcher.group(1);
                }
    
                // Extract Policy Holder Name
                Pattern policyHolderNamePattern = Pattern.compile('policyHolderName\': \'([^\']+)\'');
                Matcher policyHolderNameMatcher = policyHolderNamePattern.matcher(inputText);
                if (policyHolderNameMatcher.find()) {
                    res.policyHolderName = policyHolderNameMatcher.group(1);
                }
    
                // Extract Policy Effective Start Date
                Pattern policyStartDatePattern = Pattern.compile('policyEffectiveStartDate1\': \'([^\']+)\'');
                Matcher policyStartDateMatcher = policyStartDatePattern.matcher(inputText);
                if (policyStartDateMatcher.find()) {
                    res.policyEffectiveStartDate1 = parseDate(policyStartDateMatcher.group(1));
                }
    
                // Extract Policy Effective End Date
                Pattern policyEndDatePattern = Pattern.compile('policyEffectiveEndDate1\': \'([^\']+)\'');
                Matcher policyEndDateMatcher = policyEndDatePattern.matcher(inputText);
                if (policyEndDateMatcher.find()) {
                    res.policyEffectiveEndDate1 = parseDate(policyEndDateMatcher.group(1));
                }
    
                // Extract Agency Providing Coverage
                Pattern agencyProvidingCoveragePattern = Pattern.compile('agencyProvidingCoverage\': \'([^\']+)\'');
                Matcher agencyProvidingCoverageMatcher = agencyProvidingCoveragePattern.matcher(inputText);
                if (agencyProvidingCoverageMatcher.find()) {
                    res.agencyProvidingCoverage = agencyProvidingCoverageMatcher.group(1);
                }
    
                // Extract Policy Type
                Pattern policyTypePattern = Pattern.compile('policyType\': \'([^\']+)\'');
                Matcher policyTypeMatcher = policyTypePattern.matcher(inputText);
                if (policyTypeMatcher.find()) {
                    res.policyType = policyTypeMatcher.group(1);
                }
    
                // Extract Coverage For State Property And Casualty Insurance Guaranty
                Pattern coveragePattern = Pattern.compile('coverageForStatePropertyAndCasualtyInsuranceGuaranty\': \'([^\']+)\'');
                Matcher coverageMatcher = coveragePattern.matcher(inputText);
                if (coverageMatcher.find()) {
                    res.coverageForStatePropertyAndCasualtyInsuranceGuaranty = coverageMatcher.group(1);
                }
    
                // Extract Bodily Injury Liability
                Pattern bodilyInjuryPattern = Pattern.compile('bodilyInjuryLiability\': \'([^\']+)\'');
                Matcher bodilyInjuryMatcher = bodilyInjuryPattern.matcher(inputText);
                if (bodilyInjuryMatcher.find()) {
                    res.bodilyInjuryLiability = bodilyInjuryMatcher.group(1);
                }
    
                // Extract Loss Of Clothing Payment
                Pattern lossOfClothingPattern = Pattern.compile('lossOfClothingPayment\': \'([^\']+)\'');
                Matcher lossOfClothingMatcher = lossOfClothingPattern.matcher(inputText);
                if (lossOfClothingMatcher.find()) {
                    res.lossOfClothingPayment = lossOfClothingMatcher.group(1);
                }
    
                // Extract Right To Appraisal
                Pattern rightToAppraisalPattern = Pattern.compile('rightToAppraisal\': \'([^\']+)\'');
                Matcher rightToAppraisalMatcher = rightToAppraisalPattern.matcher(inputText);
                if (rightToAppraisalMatcher.find()) {
                    res.rightToAppraisal = rightToAppraisalMatcher.group(1);
                }
    
                // Extract Auto Comprehensive Insurance
                Pattern autoComprehensivePattern = Pattern.compile('autoComprehensiveInsurance\': \'([^\']+)\'');
                Matcher autoComprehensiveMatcher = autoComprehensivePattern.matcher(inputText);
                if (autoComprehensiveMatcher.find()) {
                    res.autoComprehensiveInsurance = autoComprehensiveMatcher.group(1);
                }
    
                // Extract What Is This Document About
                Pattern documentAboutPattern = Pattern.compile('whatIsThisDocumentAbout\': \'([^\']+)\'');
                Matcher documentAboutMatcher = documentAboutPattern.matcher(inputText);
                if (documentAboutMatcher.find()) {
                    res.whatIsThisDocumentAbout = documentAboutMatcher.group(1);
                }
    
                responses.add(res);
            }
            return responses;
        }
    
        // Helper method to parse date strings
        public static Date parseDate(String dateString) {
            Map<String, String> months = new Map<String, String>{
                'January' => '01', 'February' => '02', 'March' => '03',
                'April' => '04', 'May' => '05', 'June' => '06',
                'July' => '07', 'August' => '08', 'September' => '09',
                'October' => '10', 'November' => '11', 'December' => '12',
                'Jan' => '01', 'Feb' => '02', 'Mar' => '03',
                'Apr' => '04', 'Jun' => '06', 'Jul' => '07',
                'Aug' => '08', 'Sep' => '09', 'Oct' => '10',
                'Nov' => '11', 'Dec' => '12'
            };
    
            List<String> dateParts = dateString.split(' ');
            if (dateParts.size() == 3) {
                String day = dateParts[1].replaceAll(',', '');
                String month = months.get(dateParts[0]);
                String year = dateParts[2];
                String formattedDate = year + '-' + month + '-' + day;
                return Date.valueOf(formattedDate);
            } else {
                System.debug('Invalid date format: ' + dateString);
                return null;
            }
        }
    
        // Custom logging method to display date without time
        public static void logDateWithoutTime(String label, Date dateValue) {
            if (dateValue != null) {
                System.debug(label + ': ' + dateValue.format());
            } else {
                System.debug(label + ': null');
            }
        }
    
        // Test method to run in anonymous window
        public static void testExtractPatterns() {
            String inputText = 'policyNumber: 1234567890, policyHolderName: Nick Read, policyEffectiveStartDate1: Jan 1, 2024, policyEffectiveEndDate1: Jan 1, 2025, agencyProvidingCoverage: Bobs Insurance, policyType: Auto, coverageForStatePropertyAndCasualtyInsuranceGuaranty: Missouri law requires us to inform you that the Missouri Property and Casualty Insurance Guaranty Association does not cover policyholder claims of insolvent insurers exceeding $300,000., bodilyInjuryLiability: If a premium is shown on the Policy Declarations for Bodily Injury Liability Coverage and Property Damage Liability Coverage, Allstate will pay damages which an insured person is legally obligated to pay because of:n1. bodily injury sustained by any person, andn2. damage to, or destruction of, property, including loss of use., lossOfClothingPayment: Allstate will pay up to $200 for loss of clothing and personal luggage, including its contents, belonging to you or a resident relative while it is in or upon your insured auto., rightToAppraisal: Both you and Allstate have a right to demand an appraisal of the loss. Each will appoint and pay a qualified appraiser., autoComprehensiveInsurance: If a premium is shown on the Policy Declarations for Auto Comprehensive Insurance, Allstate will pay for direct and accidental loss to an insured auto not caused by collision.nLoss caused by missiles, falling objects, fire, theft or larceny, explosion, earthquake, windstorm, hail, water, flood, malicious mischief or vandalism, and riot or civil commotion is covered. Glass breakage, whether or not caused by collision, and collision with a bird or animal is covered. Plastic or other materials used by the manufacturer as substitutes for glass will also be considered glass., whatIsThisDocumentAbout: This document is an Allstate Auto Policy. It outlines the terms and conditions of the policy, including coverage details, exclusions, and procedures for filing claims. The policy covers various aspects of automobile insurance, such as liability, medical payments, uninsured and underinsured motorists, and protection against loss to the auto.';
            
            List<Request> requests = new List<Request>();
            Request req = new Request();
            req.inputText = inputText;
            requests.add(req);
            
            List<Response> responses = extractPatterns(requests);
    
            System.debug('Extracted Policy Number: ' + responses[0].policyNumber);
            System.debug('Extracted Policy Holder Name: ' + responses[0].policyHolderName);
            logDateWithoutTime('Extracted Policy Effective Start Date', responses[0].policyEffectiveStartDate1);
            logDateWithoutTime('Extracted Policy Effective End Date', responses[0].policyEffectiveEndDate1);
            System.debug('Extracted Agency Providing Coverage: ' + responses[0].agencyProvidingCoverage);
            System.debug('Extracted Policy Type: ' + responses[0].policyType);
            System.debug('Extracted Coverage For State Property And Casualty Insurance Guaranty: ' + responses[0].coverageForStatePropertyAndCasualtyInsuranceGuaranty);
            System.debug('Extracted Bodily Injury Liability: ' + responses[0].bodilyInjuryLiability);
            System.debug('Extracted Loss Of Clothing Payment: ' + responses[0].lossOfClothingPayment);
            System.debug('Extracted Right To Appraisal: ' + responses[0].rightToAppraisal);
            System.debug('Extracted Auto Comprehensive Insurance: ' + responses[0].autoComprehensiveInsurance);
            System.debug('Extracted What Is This Document About: ' + responses[0].whatIsThisDocumentAbout);
        }
    }
    