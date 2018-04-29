package views.examples {
import com.tuarua.City;
import com.tuarua.firebase.FirestoreANE;
import com.tuarua.firebase.firestore.CollectionReference;
import com.tuarua.firebase.firestore.DocumentReference;
import com.tuarua.firebase.firestore.DocumentSnapshot;
import com.tuarua.firebase.firestore.FirestoreSettings;
import com.tuarua.firebase.firestore.Query;
import com.tuarua.firebase.firestore.QuerySnapshot;
import com.tuarua.firebase.firestore.WriteBatch;
import com.tuarua.firebase.firestore.events.BatchEvent;
import com.tuarua.firebase.firestore.events.DocumentEvent;
import com.tuarua.firebase.firestore.events.FirestoreErrorEvent;
import com.tuarua.firebase.firestore.events.QueryEvent;

import flash.globalization.NumberFormatter;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class FirestoreExample extends Sprite {
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

    public function FirestoreExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        FirestoreANE.loggingEnabled = true;
        db = FirestoreANE.firestore;
        var fs:FirestoreSettings = db.settings;

        if (fs) {
            trace("fs.host:", fs.host);
            trace("fs.isPersistenceEnabled:", fs.isPersistenceEnabled);
            trace("fs.isSslEnabled:", fs.isSslEnabled);
        }

        initMenu();
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

        statusLabel.text = "Checking Database...";
        statusLabel.y = btnRunQuery.y + StarlingRoot.GAP;

        checkCitiesExist();

    }

    private function checkCitiesExist():void {
        var collection:CollectionReference = db.collection("cities");
        var query:Query = collection.limit(1);
        query.addEventListener(QueryEvent.QUERY_SNAPSHOT, function (event:QueryEvent):void {
            statusLabel.text = "";
            if (event.snapshot.isEmpty) {
                btnCreateDatabase.visible = true;
            } else {
                btnAddDocument.visible = btnDeleteDocument.visible =
                        btnUpdateDocument.visible = btnGetDocument.visible = btnRunQuery.visible = true;
            }
        });
        query.get();
    }


    public function onDocSnapshot(event:DocumentEvent):void {
        trace(event);
        var docRef:DocumentReference = event.target as DocumentReference;
        var docSnapShot:DocumentSnapshot = event.data;
        statusLabel.text = "";
        if (!docSnapShot.exists) {
            statusLabel.text = "No Document found";
            return;
        }
        var city:City = docSnapShot.data as City;
        if (city) {
            statusLabel.text = "Id: " + docSnapShot.id + "\n" +
                    "City: " + city.name + "\n" +
                    "State: " + city.state + "\n" +
                    "Country: " + city.country + "\n" +
                    "Population: " + populationFormatter.formatNumber(city.population) + "\n" +
                    "Is Captial: " + city.capital + "\n";
        }

        trace("onDocSnapshotSuccess", docSnapShot);
        trace("docSnapShot.id", docSnapShot.id);
        trace("docSnapShot.data", docSnapShot.data);
        trace("docSnapShot.exists", docSnapShot.exists);
        trace("docSnapShot.metadata.isFromCache", docSnapShot.metadata.isFromCache);
        trace("docSnapShot.metadata.hasPendingWrites", docSnapShot.metadata.hasPendingWrites);
        trace("onDocSnapshotSuccess realtime", event.realtime);

        //remove the realtime listener
        //docRef.removeEventListener(DocumentEvent.SNAPSHOT, onDocSnapshot);
    }

    private function onCreateDatabaseClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnCreateDatabase);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            btnCreateDatabase.visible = false;
            statusLabel.text = "Creating Database";

            var batch:WriteBatch = db.batch();
            batch.addEventListener(BatchEvent.COMPLETE, function ():void {
                trace("cities are created");
                statusLabel.text = "Database created";
                btnAddDocument.visible = btnDeleteDocument.visible = btnUpdateDocument.visible =
                        btnGetDocument.visible = btnRunQuery.visible = true;
            });
            var citiesRef:CollectionReference = db.collection("cities");

            batch.set(citiesRef.document("SF"), {
                "name": "San Francisco",
                "state": "CA",
                "country": "USA",
                "capital": false,
                "population": 860000
            });

            batch.set(citiesRef.document("LA"), {
                "name": "Los Angeles",
                "state": "CA",
                "country": "USA",
                "capital": false,
                "population": 3900000
            });

            batch.set(citiesRef.document("DC"), {
                "name": "Washington D.C.",
                "country": "USA",
                "capital": true,
                "population": 680000
            });

            batch.set(citiesRef.document("TOK"), {
                "name": "Tokyo",
                "country": "Japan",
                "capital": true,
                "population": 9000000
            });

            batch.set(citiesRef.document("BJ"), {
                "name": "Beijing",
                "country": "China",
                "capital": true,
                "population": 21500000
            });

            batch.commit();
        }
    }

    private function onGetDocumentClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGetDocument);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var doc:DocumentReference = new DocumentReference("cities/SF");
            if(doc){
                doc.map(City);
                doc.addSnapshotListener(onDocSnapshot); // This is for realtime updates
                // doc.addEventListener(DocumentEvent.SNAPSHOT, onDocSnapshot);
                doc.get();
            }
        }
    }

    private function onUpdateDocumentClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnUpdateDocument);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var doc:DocumentReference = new DocumentReference("cities/SF");
            doc.addEventListener(DocumentEvent.COMPLETE, onDocUpdated);
            doc.update({"population": 860999});
        }
    }

    private function onDocUpdated(event:DocumentEvent):void {
        trace(event);
        var docRef:DocumentReference = event.target as DocumentReference;
        docRef.removeEventListener(DocumentEvent.COMPLETE, onDocUpdated);
        trace("updated", "id", docRef.id, "path", docRef.path);
        statusLabel.text = "Updated " + docRef.id + " - " + docRef.path;
    }

    private function onDeleteDocumentClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDeleteDocument);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var doc:DocumentReference = new DocumentReference("cities/SF");
            doc.addEventListener(DocumentEvent.COMPLETE, onDocDeleted);
            doc.remove();
        }
    }

    private function onAddDocumentClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnAddDocument);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var doc:DocumentReference = new DocumentReference("cities/DUB");
            doc.addEventListener(DocumentEvent.COMPLETE, onDocAdded);
            doc.set({
                "name": "Dublin",
                "country": "Rep. of Ireland",
                "capital": true,
                "population": 1800000
            }, true);
        }
    }

    private function onDocAdded(event:DocumentEvent):void {
        var docRef:DocumentReference = event.target as DocumentReference;
        docRef.removeEventListener(DocumentEvent.COMPLETE, onDocDeleted);
        statusLabel.text = "Added " + docRef.id + " - " + docRef.path;
    }

    private function onDocDeleted(event:DocumentEvent):void {
        var docRef:DocumentReference = event.target as DocumentReference;
        docRef.removeEventListener(DocumentEvent.COMPLETE, onDocDeleted);
        statusLabel.text = "Deleted " + docRef.id + " - " + docRef.path;
    }

    private function onRunQueryClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnRunQuery);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var collection:CollectionReference = db.collection("cities");
            var query:Query = collection.where("capital", "==", true).order("name").endAt("Tokyo");
            query.addEventListener(FirestoreErrorEvent.ERROR, onError);
            query.addEventListener(QueryEvent.QUERY_SNAPSHOT, onQuery);
            query.map(City);
            query.get();
        }
    }

    private function onQuery(event:QueryEvent):void {
        var querySnapshot:QuerySnapshot = event.snapshot;
        trace("querySnapshot", querySnapshot.size, querySnapshot.isEmpty);
        statusLabel.text = "";
        for each (var doc:DocumentSnapshot in querySnapshot.documents) {
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

            trace("id", doc.id);
            trace("city", city.name, city.state, city.country, city.population, city.capital);
            trace("hasPendingWrites", doc.metadata.hasPendingWrites);
            trace("isFromCache", doc.metadata.isFromCache);
        }
    }

    private function onError(event:FirestoreErrorEvent):void {
        statusLabel.text = "Error: " + event.errorID + " - " + event.text;
    }


}
}
