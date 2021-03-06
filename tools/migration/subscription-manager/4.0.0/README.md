# WSO2 Private PaaS Migration Tool


This tool will enable users to export tenant subscriptions to a file and import them to another deployment.

## Instructions

1. Build the ppaas-migration tool by running the following command

mvn clean install

2. Deploy the migration.war web archive generated to Stratos Manager in Private PaaS 4.0.0 deployment

3. Update the scripts/export.sh file with details of your old PPaaS deployment and run the script.
   This will create a file named 'subscription-data.json' with all the subscriptions for all tenants.

4. Update the scripts/import.sh file with relevant details of your new PPaaS deployment and run the script.
   This will import all the subscription to the new deployment



## Clean Subscriptions in a Private PaaS deployment

Run the following command to clean all subscriptions from all tenants

   curl -X DELETE -k -u <username>:<password> https://<hostname>:<port>/migration/admin/cartridge/unsubscribe/all



## Retrieve all subscriptions in a Private PaaS deployment

   curl -k -u <username>:<password> https://<hostname>:<port>/migration/admin/cartridge/list/subscribed/all