package com.tuarua.firebase.remoteconfig {
[RemoteClass(alias="com.tuarua.firebase.remoteconfig.RemoteConfigSettings")]
public class RemoteConfigSettings {
    public var developerModeEnabled:Boolean;
    public function RemoteConfigSettings(developerModeEnabled: Boolean = false) {
        this.developerModeEnabled = developerModeEnabled;
    }
}
}
