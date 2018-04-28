package com.tuarua.firebase.firestore {
import com.tuarua.firebase.FirestoreANEContext;
import com.tuarua.fre.ANEError;
public class CollectionReference extends Query {
    private var _id:String;
    //https://firebase.google.com/docs/reference/ios/firebasefirestore/api/reference/Classes/FIRCollectionReference#-documentwithautoid

    public function CollectionReference(path:String) {
        _path = path;
        _asId = FirestoreANEContext.context.call("createGUID") as String;
        if (FirestoreANEContext.context) {
            var theRet:* = FirestoreANEContext.context.call("initCollectionReference", path);
            if (theRet is ANEError) throw theRet as ANEError;
            _id = theRet as String;
        }
    }

    public function add(data:*):CollectionReference {
        var doc:DocumentReference = this.document();
        doc.set(data);
        return this;
    }

    public function document(documentPath:String = null):DocumentReference {
        if (FirestoreANEContext.context) {
            if (documentPath) {
                return new DocumentReference(_path + "/" + documentPath);
            } else {
                var theRet:* = FirestoreANEContext.context.call("documentWithAutoId", _path);
                if (theRet is ANEError) {
                    throw theRet as ANEError;
                }
                var docPath:String = theRet as String;
                return new DocumentReference(docPath);
            }
        }
        return null;
    }

    public function get parent():DocumentReference {
        if (FirestoreANEContext.context) {
            var theRet:* = FirestoreANEContext.context.call("getCollectionParent", _path);
            if (theRet is ANEError) throw theRet as ANEError;
        }
        return new DocumentReference(theRet as String);
    }

    public function get path():String {
        return _path;
    }

    public function get id():String {
        return _id;
    }
}
}
