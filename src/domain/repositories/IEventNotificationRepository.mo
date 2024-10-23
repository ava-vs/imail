import Result "mo:base/Result";
import T "../entities/Types";

module {
    public type IEventNotificationRepository = {
        addNotification : (T.EventNotification) -> async Result.Result<(), T.Error>;
        getNotifications : () -> async Result.Result<[T.EventNotification], T.Error>;
        clearNotifications : () -> async Result.Result<(), T.Error>;
    };
};
