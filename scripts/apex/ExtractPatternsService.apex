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
        Map<String, String> months = new Map<String, String>{
            'January' => '01', 'February' => '02', 'March' => '03',
            'April' => '04', 'May' => '05', 'June' => '06',
            'July' => '07', 'August' => '08', 'September' => '09',
            'October' => '10', 'November' => '11', 'December' => '12'
        };
        List<String> dateParts = dateString.split(' ');
        if (dateParts.size() == 3) {
            String day = dateParts[0];
            String month = months.get(dateParts[1]);
            String year = dateParts[2];
            String formattedDate = year + '-' + month + '-' + day;
            return Date.valueOf(formattedDate);
        } else if (dateParts.size() == 2) {
            String day = dateParts[1];
            String month = months.get(dateParts[0]);
            String year = String.valueOf(Date.today().year());
            String formattedDate = year + '-' + month + '-' + day;
            return Date.valueOf(formattedDate);
        } else {
            System.debug('Invalid date format: ' + dateString);
            return null;
        }
    }

    // Test method to run in anonymous window
    public static void testExtractPatterns() {
        String inputText = 'contractDate: June 17, 2024, athleteName: Nick Read, agreementTerms: 6 years, servicesToBeRendered: - Wearing Nike apparel, footwear, and accessories during all official games, training sessions, and public appearances.n- Participating in Nike advertising campaigns, photoshoots, and promotional events.n- Endorsing Nike products on social media platforms and other media as specified by Nike.n- Providing feedback on Nike products and participating in product development and testing as reasonably requested., compensation: $6,000,000, commissionOnPlayersSignatureProducts: 8%, canUsePlayersNameAndLikeness: True, confidentiality: Player agrees to keep confidential and not disclose any proprietary information or trade secrets of Nike during and after the term of this Agreement., termination: - Player breaches any material term of this Agreement.n- Player engages in conduct that in Nike\'s reasonable judgment reflects unfavorably on Nike or its products.n- Player is unable to perform the services due to injury or other incapacity., performanceBonuses: - Championship Win: $700,000n- MVP Award: $275,000n- All-Star Selection: $100,000, paymentTerms: Quarterly, contractStartDate: July 1, 2024, contractEndDate: June 30, 2030';
        
        List<Request> requests = new List<Request>();
        Request req = new Request();
        req.inputText = inputText;
        requests.add(req);
        
        List<Response> responses = extractPatterns(requests);
        System.debug('Extracted Compensation: ' + responses[0].compensation);
        System.debug('Extracted Commission on Player\'s Signature Products: ' + responses[0].commissionOnPlayersSignatureProducts);
        System.debug('Extracted Payment Terms: ' + responses[0].paymentTerms);
        System.debug('Extracted Contract Date: ' + responses[0].contractDate);
        System.debug('Extracted Athlete Name: ' + responses[0].athleteName);
        System.debug('Extracted Number of Years: ' + responses[0].numberOfYears);
        System.debug('Extracted Contract Start Date: ' + responses[0].contractStartDate);
        System.debug('Extracted Contract End Date: ' + responses[0].contractEndDate);
    }
}