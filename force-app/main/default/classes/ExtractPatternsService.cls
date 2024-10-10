public class ExtractPatternsService {

    public class Request {
        @InvocableVariable(required=true)
        public String inputText;
    }

    public class Response {
        @InvocableVariable
        public Double compensation;
        @InvocableVariable
        public Double commissionOnPlayersSignatureProducts;
        @InvocableVariable
        public String paymentTerms;
        @InvocableVariable
        public Date contractDate;
        @InvocableVariable
        public String athleteName;
        @InvocableVariable
        public Integer numberOfYears;
        @InvocableVariable
        public Date contractEndDate;
        @InvocableVariable
        public Date contractStartDate;
    }

    @InvocableMethod
    public static List<Response> extractPatterns(List<Request> requests) {
        List<Response> responses = new List<Response>();
        
        for (Request req : requests) {
            String inputText = req.inputText;
            Response res = new Response();

            // Extract Compensation
            Pattern compensationPattern = Pattern.compile('compensation: \\$(\\d{1,3}(,\\d{3})*(\\.\\d{2})?)');
            Matcher compensationMatcher = compensationPattern.matcher(inputText);
            if (compensationMatcher.find()) {
                String compensationStr = compensationMatcher.group(1).replace(',', '');
                res.compensation = Double.valueOf(compensationStr);
            } else {
                res.compensation = 0.0; // default value if not found
            }

            // Extract commissionOnPlayersSignatureProducts
            Pattern commissionPattern = Pattern.compile('commissionOnPlayersSignatureProducts: (\\d+(\\.\\d+)?)%');
            Matcher commissionMatcher = commissionPattern.matcher(inputText);
            if (commissionMatcher.find()) {
                String commissionStr = commissionMatcher.group(1);
                res.commissionOnPlayersSignatureProducts = Double.valueOf(commissionStr);
            } else {
                res.commissionOnPlayersSignatureProducts = 0.0; // default value if not found
            }

            // Extract paymentTerms
            Pattern paymentTermsPattern = Pattern.compile('paymentTerms: ([^,]+)');
            Matcher paymentTermsMatcher = paymentTermsPattern.matcher(inputText);
            if (paymentTermsMatcher.find()) {
                res.paymentTerms = paymentTermsMatcher.group(1);
            } else {
                res.paymentTerms = 'Unknown'; // default value if not found
            }

            // Extract contractDate
            Pattern contractDatePattern = Pattern.compile('contractDate: ([^,]+)');
            Matcher contractDateMatcher = contractDatePattern.matcher(inputText);
            if (contractDateMatcher.find()) {
                String dateString = contractDateMatcher.group(1);
                res.contractDate = parseDate(dateString);
            }

            // Extract athleteName
            Pattern athleteNamePattern = Pattern.compile('athleteName: ([^,]+)');
            Matcher athleteNameMatcher = athleteNamePattern.matcher(inputText);
            if (athleteNameMatcher.find()) {
                res.athleteName = athleteNameMatcher.group(1);
            }

            // Extract agreementTerms
            Pattern agreementTermsPattern = Pattern.compile('agreementTerms: (\\d+) years');
            Matcher agreementTermsMatcher = agreementTermsPattern.matcher(inputText);
            if (agreementTermsMatcher.find()) {
                res.numberOfYears = Integer.valueOf(agreementTermsMatcher.group(1));
            }

            // Extract contractStartDate
            Pattern contractStartDatePattern = Pattern.compile('contractStartDate: ([^,]+)');
            Matcher contractStartDateMatcher = contractStartDatePattern.matcher(inputText);
            if (contractStartDateMatcher.find()) {
                String startDateString = contractStartDateMatcher.group(1);
                res.contractStartDate = parseDate(startDateString);
            }

            // Extract contractEndDate
            Pattern contractEndDatePattern = Pattern.compile('contractEndDate: ([^,]+)');
            Matcher contractEndDateMatcher = contractEndDatePattern.matcher(inputText);
            if (contractEndDateMatcher.find()) {
                String endDateString = contractEndDateMatcher.group(1);
                res.contractEndDate = parseDate(endDateString);
            }

            responses.add(res);
        }
        return responses;
    }

    // Helper method to parse date strings
    public static Date parseDate(String dateString) {
        // Check if the date is in the ISO 8601 format 'YYYY-MM-DDTHH:MM:SS.SSSZ'
        Pattern isoDateTimePattern = Pattern.compile('^(\\d{4})-(\\d{2})-(\\d{2})T.*$');
        Matcher isoDateTimeMatcher = isoDateTimePattern.matcher(dateString);
        if (isoDateTimeMatcher.matches()) {
            String formattedDate = isoDateTimeMatcher.group(1) + '-' + isoDateTimeMatcher.group(2) + '-' + isoDateTimeMatcher.group(3);
            return Date.valueOf(formattedDate);
        }

        // Other formats handling (previously defined logic)
        Map<String, String> months = new Map<String, String>{
            'January' => '01', 'February' => '02', 'March' => '03',
            'April' => '04', 'May' => '05', 'June' => '06',
            'July' => '07', 'August' => '08', 'September' => '09',
            'October' => '10', 'November' => '11', 'December' => '12'
        };

        List<String> dateParts = dateString.split(' ');
        if (dateParts.size() == 3) {
            String day = dateParts[0].replaceAll(',', '');
            String month = months.get(dateParts[1]);
            String year = dateParts[2];
            String formattedDate = year + '-' + month + '-' + day;
            return Date.valueOf(formattedDate);
        } else if (dateParts.size() == 2) {
            String day = dateParts[1].replaceAll(',', '');
            String month = months.get(dateParts[0]);
            String year = String.valueOf(Date.today().year());
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
        String inputText = 'contractDate: 2024-06-17T00:00:00.000Z, athleteName: Nick Read, agreementTerms: 6 years, compensation: $6,000,000, commissionOnPlayersSignatureProducts: 8%, canUsePlayersNameAndLikeness: True, termination: Player breaches any material term of this Agreement.n· Player engages in conduct that in Nike\'s reasonable judgment reflects unfavorably on Nike or its products.n· Player is unable to perform the services due to injury or other incapacity., paymentTerms: quarterly installments, contractStartDate: 2024-07-01T00:00:00.000Z, contractEndDate: 2030-06-30T00:00:00.000Z';
        
        List<Request> requests = new List<Request>();
        Request req = new Request();
        req.inputText = inputText;
        requests.add(req);
        
        List<Response> responses = extractPatterns(requests);
        System.debug('Extracted Compensation: ' + responses[0].compensation);
        System.debug('Extracted Commission on Player\'s Signature Products: ' + responses[0].commissionOnPlayersSignatureProducts);
        System.debug('Extracted Payment Terms: ' + responses[0].paymentTerms);
        logDateWithoutTime('Extracted Contract Date', responses[0].contractDate);
        System.debug('Extracted Athlete Name: ' + responses[0].athleteName);
        System.debug('Extracted Number of Years: ' + responses[0].numberOfYears);
        logDateWithoutTime('Extracted Contract Start Date', responses[0].contractStartDate);
        logDateWithoutTime('Extracted Contract End Date', responses[0].contractEndDate);
    }
}