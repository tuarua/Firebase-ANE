#### Place values.xml file in here

- Create a values.xml file in this folder with the below contents.
Update values with those found in the google-services.json file from your Firebase app   

````xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">FirebaseANE</string>
    <string name="default_web_client_id" translatable="false">[JSON client_id]</string>
    <string name="firebase_database_url" translatable="false">[JSON firebase_url]</string>
    <string name="gcm_defaultSenderId" translatable="false">[JSON project_number]</string>
    <string name="google_api_key" translatable="false">[JSON current_key]</string>
    <string name="google_app_id" translatable="false">[JSON mobilesdk_app_id]</string>
    <string name="google_crash_reporting_api_key" translatable="false">[JSON current_key]</string>
    <string name="google_storage_bucket" translatable="false">[JSON storage_bucket]</string>
    <string name="project_id" translatable="false">[JSON project_id]</string>
</resources>
`````
