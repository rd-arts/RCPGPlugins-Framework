
var pushnotification = {

registerForNotifications: function(notification_callback, error_callback) {
    return PhoneGap.exec(notification_callback, error_callback, "com.rearden.rcpgpushnotification", "registerForNotifications", []);
}

};

