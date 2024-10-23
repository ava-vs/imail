import Result "mo:base/Result";
import T "../../domain/entities/Types";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import IIcpService "../../domain/interfaces/IIcpService";
import ISubscriptionRepository "../../domain/repositories/ISubscriptionRepository";

module {
    public class SubscriptionRepository(icpService : IIcpService.IIcpService) : ISubscriptionRepository.ISubscriptionRepository {

        private var subscriptions : HashMap.HashMap<Text, T.SubscriptionInfo> = HashMap.HashMap<Text, T.SubscriptionInfo>(0, Text.equal, Text.hash);

        private func makeKey(namespace : Text, subscriber : Principal) : Text {
            namespace # ":" # Principal.toText(subscriber);
        };

        public func createSubscription(subscription : T.SubscriptionInfo) : async Result.Result<(), T.Error> {
            let key = makeKey(subscription.namespace, subscription.subscriber);
            Debug.print("Makekey: " # debug_show (key));
            switch (subscriptions.get(key)) {
                case null {
                    subscriptions.put(key, subscription);
                    #ok(());
                };
                case (?_) {
                    #err(#AlreadyExists);
                };
            };
        };

        public func getSubscription(namespace : Text, subscriber : Principal) : async Result.Result<T.SubscriptionInfo, T.Error> {
            let key = makeKey(namespace, subscriber);
            switch (subscriptions.get(key)) {
                case null { #err(#NotFound) };
                case (?subscription) { #ok(subscription) };
            };
        };

        public func updateSubscription(subscription : T.SubscriptionInfo) : async Result.Result<(), T.Error> {
            let key = makeKey(subscription.namespace, subscription.subscriber);
            switch (subscriptions.get(key)) {
                case null {
                    #err(#NotFound);
                };
                case (?_) {
                    subscriptions.put(key, subscription);
                    #ok(());
                };
            };
        };

        public func deleteSubscription(namespace : Text, subscriber : Principal) : async Result.Result<(), T.Error> {
            let key = makeKey(namespace, subscriber);
            switch (subscriptions.get(key)) {
                case null { #err(#NotFound) };
                case (?_) {
                    subscriptions.delete(key);
                    #ok(());
                };
            };
        };

        public func getAllSubscriptions() : async Result.Result<[T.SubscriptionInfo], T.Error> {
            #ok(Iter.toArray(subscriptions.vals()));
        };

        public func getSubscriptionsByNamespace(namespace : T.Namespace) : async Result.Result<[T.SubscriptionInfo], T.Error> {
            let filteredSubscriptions = Array.filter<T.SubscriptionInfo>(
                Iter.toArray(subscriptions.vals()),
                func(subscription : T.SubscriptionInfo) : Bool {
                    subscription.namespace == namespace;
                },
            );
            #ok(filteredSubscriptions);
        };
    };
};
