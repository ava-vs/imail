import Result "mo:base/Result";
import T "../entities/Types";

module {
    public type Event = T.Event;
    public type SubscriptionInfo = T.SubscriptionInfo;

    public type IIcpService = {
        subscribe : (namespace : Text) -> async Bool;
        publish : (event : Event) -> async Result.Result<[Nat], Text>;
    };
};
