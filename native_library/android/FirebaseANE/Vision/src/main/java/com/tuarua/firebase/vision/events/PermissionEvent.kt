package com.tuarua.firebase.vision.events

data class PermissionEvent(val permission:String, val status: Int) {
    companion object {
        const val ON_PERMISSION_STATUS = "Permission.OnStatus"
        const val PERMISSION_DENIED = 2
        const val PERMISSION_ALWAYS = 3
        const val PERMISSION_SHOW_RATIONALE = 5
    }
}