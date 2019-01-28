package views.examples {
import com.tuarua.City;
import com.tuarua.firebase.FirestoreANE;
import com.tuarua.firebase.firestore.CollectionReference;
import com.tuarua.firebase.firestore.DocumentChange;
import com.tuarua.firebase.firestore.DocumentChangeType;
import com.tuarua.firebase.firestore.DocumentReference;
import com.tuarua.firebase.firestore.DocumentSnapshot;
import com.tuarua.firebase.firestore.FirestoreError;
import com.tuarua.firebase.firestore.FirestoreSettings;
import com.tuarua.firebase.firestore.Query;
import com.tuarua.firebase.firestore.QuerySnapshot;
import com.tuarua.firebase.firestore.WriteBatch;

import flash.globalization.NumberFormatter;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class FirestoreExample extends Sprite implements IExample {
    private var db:FirestoreANE;
    private var btnCreateDatabase:SimpleButton = new SimpleButton("Create Database");
    private var btnGetDocument:SimpleButton = new SimpleButton("Get Document");
    private var btnUpdateDocument:SimpleButton = new SimpleButton("Update Document");
    private var btnDeleteDocument:SimpleButton = new SimpleButton("Delete Document");
    private var btnAddDocument:SimpleButton = new SimpleButton("Add Document");
    private var btnRunQuery:SimpleButton = new SimpleButton("Run Query");
    private var statusLabel:TextField;
    private var stageWidth:Number;
    private static var populationFormatter:NumberFormatter = new NumberFormatter(flash.globalization.LocaleID.DEFAULT);
    private var sanFran:DocumentReference;
    private var isInited:Boolean;

    public function FirestoreExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        initMenu();
    }

    public function initANE():void {
        if (isInited) return;

        FirestoreANE.loggingEnabled = true;
        db = FirestoreANE.firestore;
        sanFran = new DocumentReference("cities/SF");
        var fs:FirestoreSettings = db.settings;
        if (fs) {
            trace("fs.host:", fs.host);
            trace("fs.isPersistenceEnabled:", fs.isPersistenceEnabled);
            trace("fs.isSslEnabled:", fs.isSslEnabled);
        }

        checkCitiesExist();

        isInited = true;
    }

    private function initMenu():void {
        statusLabel = new TextField(stageWidth - 100, 1400, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.LEFT, Align.TOP);
        statusLabel.wordWrap = true;
        statusLabel.touchable = false;
        statusLabel.x = 50;

        addChild(statusLabel);
        btnAddDocument.visible = btnCreateDatabase.visible = btnDeleteDocument.visible =
                btnUpdateDocument.visible = btnGetDocument.visible = btnRunQuery.visible = false;
        btnAddDocument.x = btnCreateDatabase.x = btnDeleteDocument.x = btnUpdateDocument.x =
                btnRunQuery.x = btnGetDocument.x = (stageWidth - 200) * 0.5;

        btnCreateDatabase.addEventListener(TouchEvent.TOUCH, onCreateDatabaseClick);
        addChild(btnCreateDatabase);

        btnCreateDatabase.y = btnGetDocument.y = StarlingRoot.GAP;
        btnGetDocument.addEventListener(TouchEvent.TOUCH, onGetDocumentClick);
        addChild(btnGetDocument);

        btnUpdateDocument.y = btnGetDocument.y + StarlingRoot.GAP;
        btnUpdateDocument.addEventListener(TouchEvent.TOUCH, onUpdateDocumentClick);
        addChild(btnUpdateDocument);

        btnDeleteDocument.y = btnUpdateDocument.y + StarlingRoot.GAP;
        btnDeleteDocument.addEventListener(TouchEvent.TOUCH, onDeleteDocumentClick);
        addChild(btnDeleteDocument);

        btnAddDocument.y = btnDeleteDocument.y + StarlingRoot.GAP;
        btnAddDocument.addEventListener(TouchEvent.TOUCH, onAddDocumentClick);
        addChild(btnAddDocument);

        btnRunQuery.y = btnAddDocument.y + StarlingRoot.GAP;
        btnRunQuery.addEventListener(TouchEvent.TOUCH, onRunQueryClick);
        btnRunQuery.visible = false;
        addChild(btnRunQuery);


        statusLabel.y = btnRunQuery.y + (StarlingRoot.GAP * 1.25);

    }

    private function checkCitiesExist():void {
        statusLabel.text = "Checking Database...";
        var collection:CollectionReference = db.collection("cities");
        var query:Query = collection.limit(1);
        query.getDocuments(hasCities);
    }

    private function hasCities(snapshot:QuerySnapshot, error:FirestoreError):void {
        if (error) {
            statusLabel.text = "onCitiesCreated error: " + error.errorID + " : " + error.message;
            return;
        }
        statusLabel.text = "";
        if (snapshot.isEmpty) {
            btnCreateDatabase.visible = true;
        } else {
            btnAddDocument.visible = btnDeleteDocument.visible =
                    btnUpdateDocument.visible = btnGetDocument.visible = btnRunQuery.visible = true;
        }

    }

    private function onCreateDatabaseClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnCreateDatabase);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            btnCreateDatabase.visible = false;
            statusLabel.text = "Creating Database";

            var batch:WriteBatch = db.batch();
            var citiesRef:CollectionReference = db.collection("cities");

            batch.setData({
                "name": "San Francisco",
                "state": "CA",
                "country": "USA",
                "capital": false,
                "population": 860000
            }, citiesRef.document("SF"));

            batch.setData({
                "name": "Los Angeles",
                "state": "CA",
                "country": "USA",
                "capital": false,
                "population": 3900000
            }, citiesRef.document("LA"));

            batch.setData({
                "name": "Washington D.C.",
                "country": "USA",
                "capital": true,
                "population": 680000
            }, citiesRef.document("DC"));

            batch.setData({
                "name": "Tokyo",
                "country": "Japan",
                "capital": true,
                "population": 9000000
            }, citiesRef.document("TOK"));

            batch.setData({
                "name": "Beijing",
                "country": "China",
                "capital": true,
                "population": 21500000
            }, citiesRef.document("BJ"));

            batch.commit(onCitiesCreated);
            
        }
    }

    private function onCitiesCreated(error:FirestoreError):void {
        if (error) {
            statusLabel.text = "onCitiesCreated error: " + error.errorID + " : " + error.message;
            return;
        }
        statusLabel.text = "Database created";
        btnAddDocument.visible = btnDeleteDocument.visible = btnUpdateDocument.visible =
                btnGetDocument.visible = btnRunQuery.visible = true;
    }

    private function onGetDocumentClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGetDocument);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            if (sanFran) {
                sanFran.map(City);
                sanFran.addSnapshotListener(onDocSnapshot); // This is for realtime updates
                // doc.getDocument(onDocSnapshot); // This is for a single update
            }
        }
    }

    private function onDocSnapshot(snapshot:DocumentSnapshot, error:FirestoreError, realtime:Boolean):void {
        if (error) {
            statusLabel.text = "onDocSnapshot error: " + error.errorID + " : " + error.message;
            return;
        }
        var city:City = snapshot.data as City;
        if (city) {
            statusLabel.text = "realtime: " + realtime + "\n" +
                    "Id: " + snapshot.id + "\n" +
                    "City: " + city.name + "\n" +
                    "State: " + city.state + "\n" +
                    "Country: " + city.country + "\n" +
                    "Population: " + populationFormatter.formatNumber(city.population) + "\n" +
                    "Is Capital: " + city.capital + "\n";
        }
        // sanFran.removeSnapshotListener(onDocSnapshot); //to clear realtimes updates
    }

    private function onUpdateDocumentClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnUpdateDocument);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            sanFran.updateData({"population": 860999}, onDocUpdated);
        }
    }

    private function onDocUpdated(path:String, error:FirestoreError):void {
        if (error) {
            statusLabel.text = "onDocUpdated error: " + error.errorID + " : " + error.message;
            return;
        }
        trace(path);
        statusLabel.text = "Updated " + path;
    }

    private function onDeleteDocumentClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDeleteDocument);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            sanFran.remove(onDocDeleted);
        }
    }

    private function onAddDocumentClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnAddDocument);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var doc:DocumentReference = new DocumentReference("cities/DUB");
            doc.setData({
                "name": "Dublin",
                "country": "Rep. of Ireland",
                "capital": true,
                "population": 1800000
            }, onDocAdded, true);
        }
    }

    private function onDocAdded(path:String, error:FirestoreError):void {
        if (error) {
            statusLabel.text = "onDocUpdated error: " + error.errorID + " : " + error.message;
            return;
        }
        statusLabel.text = "Added " + path;
    }

    private function onDocDeleted(path:String, error:FirestoreError):void {
        if (error) {
            statusLabel.text = "onDocUpdated error: " + error.errorID + " : " + error.message;
            return;
        }
        statusLabel.text = "Deleted " + path;
    }

    private function onRunQueryClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnRunQuery);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var collection:CollectionReference = db.collection("cities");
            var query:Query = collection.where("capital", "==", true).order("name").endAt("Tokyo");
            query.map(City);
            query.getDocuments(onQuery);
        }
    }

    private function onQuery(snapshot:QuerySnapshot, error:FirestoreError):void {
        if (error) {
            statusLabel.text = "onDocUpdated error: " + error.errorID + " : " + error.message;
            return;
        }
        statusLabel.text = "";
        for each (var doc:DocumentSnapshot in snapshot.documents) {
            if (!doc.exists) {
                continue;
            }
            var city:City = doc.data as City;

            statusLabel.text = statusLabel.text +
                    "Id: " + doc.id + "\n" +
                    "City: " + city.name + "\n" +
                    "State: " + city.state + "\n" +
                    "Country: " + city.country + "\n" +
                    "Population: " + populationFormatter.formatNumber(city.population) + "\n" +
                    "Is Captial: " + city.capital + "\n";
        }
    }

}
}
