package com.tuarua.firebase.auth {
import com.tuarua.firebase.AuthANEContext;
import com.tuarua.fre.ANEError;

[RemoteClass(alias="com.tuarua.firebase.auth.FirebaseUser")]
public class FirebaseUser {
    private var _email:String;
    private var _displayName:String;
    private var _isAnonymous:Boolean;
    private var _isEmailVerified:Boolean;
    private var _photoUrl:String;
    private var _phoneNumber:String;
    private var _uid:String;

    public function FirebaseUser(uid:String, displayName:String, email:String, isAnonymous:Boolean,
                                 isEmailVerified:Boolean, photoUrl:String, phoneNumber:String) {
        this._uid = uid;
        this._displayName = displayName;
        this._email = email;
        this._isAnonymous = isAnonymous;
        this._isEmailVerified = isEmailVerified;
        this._photoUrl = photoUrl;
        this._phoneNumber = phoneNumber;
    }


    /*
    ret.setProp("uid", currentUser.uid)
            ret.setProp("displayName", currentUser.displayName)
            ret.setProp("email", currentUser.email)
            ret.setProp("isAnonymous", currentUser.isAnonymous)
            ret.setProp("isEmailVerified", currentUser.isEmailVerified)
            ret.setProp("photoUrl", currentUser.photoUrl)
            ret.setProp("phoneNumber", currentUser.phoneNumber)
            */

    public function set displayName(value:String):void {
        _displayName = value;
    }

    public function sendEmailVerification():void {
        var theRet:* = AuthANEContext.context.call("sendEmailVerification");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    //TODO
    public function unlink(provider:String):void {

    }
//TODO
    public function linkWithCredential(credential:AuthCredential):void {

    }

//TODO
    public function reauthenticate(credential:AuthCredential):void {

    }
//TODO
    public function reauthenticateAndRetrieveData(credential:AuthCredential):void {

    }
//TODO
    public function reload():void{

    }

    public function getIdToken(forceRefresh:Boolean):void {
        var theRet:* = AuthANEContext.context.call("getIdToken", forceRefresh);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function set email(value:String):void {
        _email = value;
        var theRet:* = AuthANEContext.context.call("updateEmail", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function set password(value:String):void {
        var theRet:* = AuthANEContext.context.call("updatePassword", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /*public function updatePhoneNumber(value:PhoneAuthCredential):void {
        var theRet:* = AuthANEContext.context.call("updatePhoneNumber", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }*/

    //TODO
    public function updateProfile():void {

    }


    public function get email():String {
        return _email;
    }

    public function get uid():String {
        return _uid;
    }

    public function get displayName():String {
        return _displayName;
    }


    public function get isAnonymous():Boolean {
        return _isAnonymous;
    }

    public function get isEmailVerified():Boolean {
        return _isEmailVerified;
    }

    public function get photoUrl():String {
        return _photoUrl;
    }

    public function get phoneNumber():String {
        return _phoneNumber;
    }


}
}