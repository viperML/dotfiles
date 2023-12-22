polkit.addRule(function(action, subject) {
    polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
});

polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.AUTH_ADMIN_KEEP;
    }
});
