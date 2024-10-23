import Result "mo:base/Result";
import T "../entities/Types";
import ISubscriptionRepository "../repositories/ISubscriptionRepository";
import Principal "mo:base/Principal";

module {
    public class UnsubscribeEvent(
        subscriptionRepository: ISubscriptionRepository.ISubscriptionRepository
    ) {
        public func execute(namespace: Text, subscriber: Principal) : async Result.Result<(), T.Error> {
            // Implement the logic to unsubscribe from an event
            // This involves deleting the subscription from the repository
            await subscriptionRepository.deleteSubscription(namespace, subscriber)
        };
    };
};
