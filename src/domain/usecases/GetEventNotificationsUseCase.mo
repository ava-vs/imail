import Result "mo:base/Result";
import T "../entities/Types";
import IEventNotificationRepository "../repositories/IEventNotificationRepository";

module {
    public class GetEventNotifications(repository: IEventNotificationRepository.IEventNotificationRepository) {
        public func execute() : async Result.Result<[T.EventNotification], T.Error> {
            await repository.getNotifications();
        };
    };
};
