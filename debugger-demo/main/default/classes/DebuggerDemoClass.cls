public with sharing class DebuggerDemoClass {
    public static void createSampleDataToDebug(Integer count) {
        List<Account> accountListToInsert = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accountListToInsert.add(new Account(Name = 'Ozan Shop ' + i, Industry = 'Hospo'));
        }
        insert accountListToInsert;

        List<Account> queriedAccounts = [SELECT Name, Industry, Type FROM Account];
        String debugName = '';
        for (Account acc : queriedAccounts) {
            debugName = acc.Name;
        }
    }
}

/**
 *  DebuggerDemoClass.createSampleDataToDebug(5);
 */

