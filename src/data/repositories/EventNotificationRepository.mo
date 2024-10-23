import T "../../domain/entities/Types";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";

module {
    public class EventNotificationRepository() {
        private var notifications : Buffer.Buffer<T.EventNotification> = Buffer.Buffer<T.EventNotification>(0);

        public func addNotification(notification : T.EventNotification) : async Result.Result<(), T.Error> {
            notifications.add(notification);
            #ok(());
        };

        public func getNotifications() : async Result.Result<[T.EventNotification], T.Error> {
            #ok(Buffer.toArray(notifications));
        };

        public func clearNotifications() : async Result.Result<(), T.Error> {
            notifications.clear();
            #ok(());
        };

        // TODO
        // - getUnreadNotifications
        // - markNotificationAsRead
        // - getNotificationsByType
    };
};
