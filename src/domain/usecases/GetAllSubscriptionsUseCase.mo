import Result "mo:base/Result";
import T "../../domain/entities/Types";
import ISubscriptionRepository "../../domain/repositories/ISubscriptionRepository";

module {
    public class GetAllSubscriptionsUseCase(repository : ISubscriptionRepository.ISubscriptionRepository) {
        public func execute() : async Result.Result<[T.SubscriptionInfo], T.Error> {
            await repository.getAllSubscriptions();
        };
    };
};
