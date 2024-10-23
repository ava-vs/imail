import Result "mo:base/Result";
import T "../entities/Types";
import Principal "mo:base/Principal";

module {
    public type ISubscriptionRepository = {
        createSubscription : (subscription : T.SubscriptionInfo) -> async Result.Result<(), T.Error>;
        getSubscription : (namespace : Text, subscriber : Principal) -> async Result.Result<T.SubscriptionInfo, T.Error>;
        updateSubscription : (subscription : T.SubscriptionInfo) -> async Result.Result<(), T.Error>;
        deleteSubscription : (namespace : Text, subscriber : Principal) -> async Result.Result<(), T.Error>;
        getAllSubscriptions : () -> async Result.Result<[T.SubscriptionInfo], T.Error>;
        getSubscriptionsByNamespace : (namespace : T.Namespace) -> async Result.Result<[T.SubscriptionInfo], T.Error>;
    };
};
