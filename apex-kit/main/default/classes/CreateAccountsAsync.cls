public with sharing class CreateAccountsAsync extends Promise {
    public override void execute() {
        List<Account> accountList = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accountList.add(new Account(Name = 'Test Acc - ' + i));
        }
        insert accountList;

        this.setPassThroughDataForNextJob(accountList);
    }

    private void setPassThroughDataForNextJob(List<Account> accountList) {
        Set<Id> accIds = new Set<Id>();
        for (Account account : accountList) {
            accIds.add(account.Id);
        }
        this.passthrough = accIds;
    }
}
