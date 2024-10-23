import Result "mo:base/Result";
import T "../entities/Types";
import IEventNotificationRepository "../repositories/IEventNotificationRepository";
import Debug "mo:base/Debug";
import Error "mo:base/Error";

module {
    public class ReceiveEventNotification(repository : IEventNotificationRepository.IEventNotificationRepository) {
        public func execute(notification : T.EventNotification) : async Result.Result<(), T.Error> {
            Debug.print("Received event notification: " # debug_show (notification));

            try {
                let result = await repository.addNotification(notification);
                switch (result) {
                    case (#ok(_)) {
                        Debug.print("Event notification saved successfully");
                        #ok(());
                    };
                    case (#err(error)) {
                        Debug.print("Error saving event notification: " # debug_show (error));
                        #err(error);
                    };
                };
            } catch (error) {
                Debug.print("Unexpected error while saving event notification: " # Error.message(error));
                #err(#SystemError("Unexpected error while saving event notification"));
            };
        };
    };
};
