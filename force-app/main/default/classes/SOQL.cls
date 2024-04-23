/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Phi Huynh
*/

public with sharing class SOQL {
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getLeads() {
        List<Lead> allLeads = [SELECT Id, LastName, Company, Phone, Email FROM Lead];
        // Return the list of leads
        return allLeads;
    }
 
    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getJohns() {
        List<Contact> allContacts = [SELECT Id, Name FROM Contact WHERE FirstName ='John'];
       
        return allContacts;
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName() {
        List<Contact> matchingContacts = [SELECT Id FROM Contact WHERE LastName IN ('Smith', 'Jones')];
        List<Id> contactIds = new List<Id>();

        for (Contact contact : matchingContacts) {
            contactIds.add(contact.Id);
        }
        return contactIds;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
        public static List<Opportunity> getClosedWonOpportunitiesByAccount(Id accountId) {
            List<Opportunity> closedWonOpportunities = [
                SELECT Id, Name, StageName, CloseDate, AccountId, Amount 
                FROM Opportunity 
                WHERE AccountId = :accountId AND StageName = 'Closed Won'
            ];    
            return closedWonOpportunities;
        }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
    **/
     public static Integer getAccountCount() {
        Integer accountCount = [SELECT COUNT() FROM Account];
        return accountCount;
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek() {
        Date nextWeek = Date.today().addDays(7);
        List<Task> tasks = [SELECT Id, Subject, ActivityDate FROM Task WHERE ActivityDate <= :nextWeek];
        // Create map to store the results
        Map<Id, Task> taskMap = new Map<Id, Task>();
        for (Task task : tasks) {
            taskMap.put(task.Id, task);
        }
        
        return taskMap;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain() {
        // Query for contacts
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Name, Email FROM Contact WHERE Email LIKE '%@example.com'];
        return contacts;
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        // Query for opportunities with the keyword in their name
        List<Opportunity> opportunities = [SELECT Id, Name, StageName, CloseDate, Amount FROM Opportunity WHERE Name LIKE :('%' + keyword + '%')];
        return opportunities;
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        // Query for cases 
        List<Case> cases = [SELECT Id, CaseNumber, Origin FROM Case WHERE Origin NOT IN ('Web', 'Email', '')];
        return cases;
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) {
        // Query for leads based on the given Lead Source or keyword
        String query = 'SELECT Id, Name, Title, LastName, Company, Phone, Email, LeadSource FROM Lead WHERE LeadSource = :leadSource OR Title LIKE :keyword';
        List<Lead> leads = Database.query(query);

        return leads;
    }  

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contactLastNames = new List<String>();
        // Query the Contacts
        List<Contact> contacts = [SELECT LastName FROM Contact WHERE AccountId = :accountId];
        // Loop through each Contact and add the LastName to the list
        for (Contact con : contacts) {
            contactLastNames.add(con.LastName);
        }

        // Return the list of Contact LastNames
        return contactLastNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total
        AggregateResult[] results = [SELECT SUM(Amount) totalRevenue FROM Opportunity WHERE StageName = :stage OR Amount > 10000];

        // Retrieve the total revenue
        Decimal totalRevenue = 0;
        if (results.size() > 0) {
            totalRevenue = (Decimal)results[0].get('totalRevenue');
        }
        return totalRevenue;
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        // Query the first 10 Accounts ordered by Name
        List<Account> firstTenAccounts = [SELECT Id, Name FROM Account ORDER BY Name LIMIT 10];
        return firstTenAccounts;
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        List<Opportunity> highValueOpportunities = [SELECT Id, Name, Amount, CloseDate FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate LIMIT 5];
        return highValueOpportunities;
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        List<Contact> birthdateContacts = [SELECT Id, FirstName, LastName, Birthdate FROM Contact WHERE Birthdate != null ORDER BY Birthdate DESC LIMIT 3];
        return birthdateContacts; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        List<Case> casesWithStatus = [SELECT Id, CaseNumber, Status, CreatedDate FROM Case WHERE Status = 'Open' ORDER BY CreatedDate LIMIT 10 OFFSET 5];
        return casesWithStatus; // Replace null with the variable you used to store the result
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Create a set to hold the Case Ids
        Set<Id> caseIds = new Set<Id>();
        // Query the Cases
        List<Case> relatedCases = [SELECT Id FROM Case WHERE AccountId = :accountId];
        // Loop through each Case and add the Id to the set
        for (Case c : relatedCases) {
            caseIds.add(c.Id);
        }
        return caseIds; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        // Query the Accounts
        // Loop through each Account and add the Id and Name to the map
        List<Account> accountsNotInCountry = [SELECT Id, Name FROM Account WHERE BillingCountry != :country];
        for (Account acc : accountsNotInCountry) {
            accountIdsToNames.put(acc.Id, acc.Name);
        }
        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        // Initialize a variable to store the Account Name
        String accountName = null;
        // Query the Contact to get its related Account's Name
        Contact contactWithAccount = [SELECT Account.Name FROM Contact WHERE Id = :contactId LIMIT 1];
        // Check if the contact exists and has an associated Account
        if (contactWithAccount != null && contactWithAccount.Account != null) {
            // Assign the Account Name to the variable
            accountName = contactWithAccount.Account.Name;
        }
        // Return the Account Name of the Contact
        return accountName; // Replace null with the variable you used to store the result
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getOpportunityAndAccountNamesForLineItem('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getOpportunityAndAccountNamesForLineItem(Id accountId) {
        // Query the Account and related Opportunities
        Account accountWithOpportunities = [SELECT Id, Name, (SELECT Id, Name FROM Opportunities) FROM Account WHERE Id = :accountId LIMIT 1];

        // Return the Account with related Opportunities
        return accountWithOpportunities; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        // Query the Account
        Account acc = [SELECT BillingState FROM Account WHERE Id = :accountId LIMIT 1];
        String billingState = acc.BillingState;
        // Store the Account's BillingState
        List<Contact> contacts = [SELECT Id, Name, MailingState FROM Contact WHERE MailingState = :billingState];
        // Query the Contacts
        return contacts; // Replace null with the variable you used to store the result
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findContactsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findContactsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads
        List<Lead> leads = [SELECT Id, Email FROM Lead WHERE Id IN :leadIds];

        // Create a set to store email domains from the Leads
        Set<String> emailDomains = new Set<String>();

        // Loop through each Lead
        for (Lead lead : leads) {
            // Get the email from the Lead
            String leadEmail = lead.Email;

            // Check if the email is not null
            if (leadEmail != null) {
                // Extract the email domain
                String[] emailParts = leadEmail.split('@');
                if (emailParts.size() == 2) {
                    String emailDomain = emailParts[1];

                    // Add the email domain to the set
                    emailDomains.add(emailDomain);
                }
            }
        }

        // Query the Accounts with matching website domains
        List<Account> matchingAccounts = new List<Account>();
        for (String domain : emailDomains) {
            String domainPattern = '%' + domain + '%';
            List<Account> accounts = [SELECT Id, Name, Website FROM Account WHERE Website LIKE :domainPattern];
            matchingAccounts.addAll(accounts);
        }

        // Return the list of matching Accounts
        return matchingAccounts; // Replace null with the variable you used to store the result
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> origLineItems = [SELECT Id, Quantity, PricebookEntryId FROM OpportunityLineItem WHERE OpportunityId = :origOppId];

        // Create a map to hold the original line item's PricebookEntryId to UnitPrice mapping
        Map<Id, Decimal> pricebookEntryIdToUnitPriceMap = new Map<Id, Decimal>();

        // Populate the map with PricebookEntryId to UnitPrice mapping
        for (OpportunityLineItem origLineItem : origLineItems) {
            // Query for the unit price of the original line item's price book entry
            PricebookEntry origPricebookEntry = [SELECT UnitPrice FROM PricebookEntry WHERE Id = :origLineItem.PricebookEntryId];
            pricebookEntryIdToUnitPriceMap.put(origLineItem.PricebookEntryId, origPricebookEntry.UnitPrice);
        }

        // Create a list to hold the new line items
        List<OpportunityLineItem> newLineItems = new List<OpportunityLineItem>();

        // Loop through each cloned Opportunity Id
        for (Id cloneOppId : cloneOppIds) {
            // Loop through each original line item
            for (OpportunityLineItem origLineItem : origLineItems) {
                // Generate a random number between 1 and 3 for the quantity
                Integer randomQuantity = (Integer)Math.round(Math.random() * 2) + 1;

                // Calculate the total price based on the unit price and rounded quantity
                Decimal unitPrice = pricebookEntryIdToUnitPriceMap.get(origLineItem.PricebookEntryId);
                Decimal totalPrice = unitPrice * randomQuantity;

                // Clone the original line item and add the random quantity and calculated total price
                OpportunityLineItem newLineItem = new OpportunityLineItem(
                    OpportunityId = cloneOppId,
                    Quantity = randomQuantity,
                    PricebookEntryId = origLineItem.PricebookEntryId,
                    TotalPrice = totalPrice
                );
                newLineItems.add(newLineItem);
            }
        }

        // Insert the new line items
        insert newLineItems;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        return [SELECT Id, Name, Account.Name, Owner.Name
                FROM Opportunity
                WHERE StageName = 'Closed Won']; // Replace null with the variable you used to store the result
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        // Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> opportunities = getOpportunityDetailsForClosedWon();
            
        // Create a set of Account Ids from the Opportunities
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : opportunities) {
            accountIds.add(opp.AccountId);
        }

        // Query the Contacts
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds ORDER BY CreatedDate ASC];

        // Create a map to hold the primary contact Id for each Account
        Map<Id, Id> accountToPrimaryContactMap = new Map<Id, Id>();
        for (Contact contact : contacts) {
            if (!accountToPrimaryContactMap.containsKey(contact.AccountId)) {
                accountToPrimaryContactMap.put(contact.AccountId, contact.Id);
            }
        }

        // Loop through each Opportunity and update the primary contact
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for (Opportunity opp : opportunities) {
            if (accountToPrimaryContactMap.containsKey(opp.AccountId)) {
                opp.Primary_Contact__c = accountToPrimaryContactMap.get(opp.AccountId);
                opportunitiesToUpdate.add(opp);
            }
        }

        // Update the Opportunities
        update opportunitiesToUpdate;
    }
}