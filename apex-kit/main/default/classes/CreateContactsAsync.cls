public with sharing class CreateContactsAsync extends Promise {
    public override void execute() {
        Set<Id> insertedAccountIds = (Set<Id>) this.passthrough;

        List<Contact> contactList = new List<Contact>();
        for (Id accId : insertedAccountIds) {
            contactList.add(new Contact(AccountId = accId, LastName = 'Contact for ' + accId, FirstName = 'Test'));
        }

        insert contactList;
    }
}
