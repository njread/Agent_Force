@isTest
public class CreatePayoutScheduleTest {
    @isTest
    static void testCreatePayoutSchedule() {
        // Create a test Player_Contracts__c record
        Player_Contracts__c contract = new Player_Contracts__c(
            Contract_Effective_Date__c = Date.today(),
            Total_Contract_Value__c = 5000000,
            Contract_Duration_Years__c = 6,
            Name = 'Test Contract'
        );
        insert contract;
        
        // Query the Contract_Pay_Out__c records
        List<Contract_Pay_Out__c> schedules = [SELECT Id, Payout_Date__c, Payout_Amount__c, Contract_Duration__c, Contract_Start_Date__c, Year__c, Contract_Name__c FROM Contract_Pay_Out__c WHERE Player_Contract__c = :contract.Id];
        
        // Assert the expected number of payout schedules
        System.assertEquals(24, schedules.size());
        
        // Calculate the expected payout amount
        Decimal expectedPayout = (5000000.00 / 24).setScale(2, RoundingMode.HALF_UP);
        for (Contract_Pay_Out__c schedule : schedules) {
            // Ensure both expected and actual values are compared at the same scale
            System.assertEquals(expectedPayout, schedule.Payout_Amount__c.setScale(2, RoundingMode.HALF_UP));
            System.assertEquals(contract.Contract_Duration_Years__c, schedule.Contract_Duration__c);
            System.assertEquals(contract.Contract_Effective_Date__c, schedule.Contract_Start_Date__c);
            System.assertEquals(schedule.Payout_Date__c.year(), schedule.Year__c);
            System.assertEquals(contract.Name, schedule.Contract_Name__c);
        }
    }
}