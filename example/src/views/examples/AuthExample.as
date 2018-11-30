package views.examples {
import com.tuarua.firebase.AuthANE;
import com.tuarua.firebase.auth.AuthError;
import com.tuarua.firebase.auth.EmailAuthCredential;
import com.tuarua.firebase.auth.FirebaseUser;
import com.tuarua.firebase.auth.GoogleAuthCredential;
//import com.tuarua.google.GoogleSignInANE;
//import com.tuarua.google.signin.events.GoogleSignInEvent;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class AuthExample extends Sprite implements IExample {
    private var stageWidth:Number;
    private var isInited:Boolean;
    private var auth:AuthANE;
    //private var googleSignIn:GoogleSignInANE;
    private var btnSignInAnon:SimpleButton = new SimpleButton("Login Anonymously");
    private var btnSignInEmailPassword:SimpleButton = new SimpleButton("Sign in w/ Email + Password");
    private var btnSignOut:SimpleButton = new SimpleButton("Sign out");
    private var btnUpdateProfile:SimpleButton = new SimpleButton("Update Profile");
    private var btnCreateNewUser:SimpleButton = new SimpleButton("Create New User");
    private var btnSignInWithGoogle:SimpleButton = new SimpleButton("Sign in w/ Google");
    private var btnLinkWithGoogle:SimpleButton = new SimpleButton("Link w/ Google");
    private var statusLabel:TextField;

    public function AuthExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        initMenu();
    }

    public function initANE():void {
        if (isInited) return;
        auth = AuthANE.auth;
//        googleSignIn = GoogleSignInANE.googleSignIn;
//        googleSignIn.addEventListener(GoogleSignInEvent.SIGN_IN, onGoogleSignIn);
//        googleSignIn.addEventListener(GoogleSignInEvent.ERROR, onGoogleSignIn);
        isInited = true;
    }

    private function initMenu():void {
        btnLinkWithGoogle.x = btnSignInWithGoogle.x = btnUpdateProfile.x = btnCreateNewUser.x =
                btnSignInAnon.x = btnSignInEmailPassword.x = btnSignOut.x = (stageWidth - 200) * 0.5;
        btnSignInAnon.y = StarlingRoot.GAP;
        btnSignInAnon.addEventListener(TouchEvent.TOUCH, onSignInAnonClick);
        addChild(btnSignInAnon);

        btnSignInEmailPassword.y = btnSignInAnon.y + StarlingRoot.GAP;
        btnSignInEmailPassword.addEventListener(TouchEvent.TOUCH, onSignInEmailPasswordClick);
        addChild(btnSignInEmailPassword);

        btnSignOut.y = btnSignInEmailPassword.y + StarlingRoot.GAP;
        btnSignOut.addEventListener(TouchEvent.TOUCH, onSignOutClick);
        addChild(btnSignOut);

        btnCreateNewUser.y = btnSignOut.y + StarlingRoot.GAP;
        btnCreateNewUser.addEventListener(TouchEvent.TOUCH, onCreateNewUserClick);
        addChild(btnCreateNewUser);

        btnUpdateProfile.y = btnCreateNewUser.y + StarlingRoot.GAP;
        btnUpdateProfile.addEventListener(TouchEvent.TOUCH, onUpdateProfileClick);
        addChild(btnUpdateProfile);

        btnSignInWithGoogle.y = btnUpdateProfile.y + StarlingRoot.GAP;
        btnSignInWithGoogle.addEventListener(TouchEvent.TOUCH, onSignInWithGoogleClick);
        addChild(btnSignInWithGoogle);

        btnLinkWithGoogle.y = btnSignInWithGoogle.y + StarlingRoot.GAP;
        btnLinkWithGoogle.addEventListener(TouchEvent.TOUCH, onLinkWithGoogleClick);
        addChild(btnLinkWithGoogle);

        statusLabel = new TextField(stageWidth, 1400, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnLinkWithGoogle.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);
    }

    private function onCreateNewUserClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnCreateNewUser);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            auth.createUserWithEmailAndPassword("test@test.com", "password", onNewUser);
            statusLabel.text = "Creating new user";
        }
    }

    private function onUpdateProfileClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnUpdateProfile);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            auth.currentUser.updateProfile("FireAceOfBase",
                    "https://cdn0.iconfinder.com/data/icons/user-pictures/100/matureman1-512.png",
                    function (error:AuthError):void {
                        if (error) {
                            statusLabel.text = "onSignedIn error: " + error.errorID + " : " + error.message;
                            return;
                        }
                        statusLabel.text = "Profile Updated";
                        var user:FirebaseUser = auth.currentUser;
                        statusLabel.text = "Signed In" + "\n" +
                                "isAnonymous: " + user.isAnonymous + "\n" +
                                "displayName: " + user.displayName + "\n" +
                                "email: " + user.email + "\n" +
                                "isEmailVerified: " + user.isEmailVerified + "\n" +
                                "photoUrl: " + user.photoUrl + "\n";
                    });
            statusLabel.text = "Updating Profile";
        }
    }

    private function onSignInWithGoogleClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnSignInWithGoogle);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
           // googleSignIn.signIn();
        }
    }

//    private function onGoogleSignIn(event:GoogleSignInEvent):void {
//        if (event.error) {
//            statusLabel.text = "Google Sign In error: " + event.error.errorID + " : " + event.error.message;
//            return;
//        }
//        auth.signIn(event.credential, onSignedIn);
//    }

    private function onLinkWithGoogleClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnLinkWithGoogle);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            if (auth && auth.currentUser) {
                auth.currentUser.link(new GoogleAuthCredential("id", "access_token"), onLinked);
            }
        }
    }

    private function onLinked(error:AuthError):void {
        if (error) {
            statusLabel.text = "onLinked error: " + error.errorID + " : " + error.message;
            return;
        }
        statusLabel.text = "User linked";
    }

    private function onNewUser(error:AuthError):void {
        if (error) {
            statusLabel.text = "onSignedIn error: " + error.errorID + " : " + error.message;
            return;
        }
        statusLabel.text = "New user created";
    }

    private function onSignOutClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnSignOut);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            auth.signOut();
            statusLabel.text = "Signed Out";
        }
    }

    private function onSignInEmailPasswordClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnSignInEmailPassword);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            auth.signIn(new EmailAuthCredential("test@test.com", "password"), onSignedIn);
        }
    }

    private function onSignInAnonClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnSignInAnon);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            auth.signInAnonymously(onSignedIn);
        }
    }

    private function onSignedIn(error:AuthError):void {
        if (error) {
            statusLabel.text = "onSignedIn error: " + error.errorID + " : " + error.message;
            return;
        }
        var user:FirebaseUser = auth.currentUser;
        statusLabel.text = "Signed In" + "\n" +
                "isAnonymous: " + user.isAnonymous + "\n" +
                "displayName: " + user.displayName + "\n" +
                "email: " + user.email + "\n" +
                "isEmailVerified: " + user.isEmailVerified + "\n" +
                "photoUrl: " + user.photoUrl + "\n";
        user.getIdToken(true, function (token:String):void {
            statusLabel.text += "token: " + token.substr(0, 10) + "...";
        });
    }

}
}
