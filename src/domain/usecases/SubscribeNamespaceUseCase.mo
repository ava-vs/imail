import Result "mo:base/Result";
import T "../../domain/entities/Types";
import ISubscriptionRepository "../../domain/repositories/ISubscriptionRepository";
import IIcpService "../../domain/interfaces/IIcpService";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Error "mo:base/Error";

module {
    public class SubscribeNamespaceUseCase(
        subscriptionRepository : ISubscriptionRepository.ISubscriptionRepository,
        icpService : IIcpService.IIcpService,
    ) {
        public func execute(namespace : Text, subscriber : Principal) : async Result.Result<(), T.Error> {
            try {
                // Check if the subscription already exists in the repository
                let existingSubscription = await subscriptionRepository.getSubscription(namespace, subscriber);

                switch (existingSubscription) {
                    case (#ok(_)) {
                        // Subscription already exists
                        Debug.print("Subscription already exists for namespace: " # namespace);
                        return #err(#AlreadyExists);
                    };
                    case (#err(_)) {
                        // Subscription doesn't exist, proceed with creation
                        let subscribeResult = await icpService.subscribe(namespace);

                        if (subscribeResult) {
                            let newSubscription : T.SubscriptionInfo = {
                                namespace = namespace;
                                subscriber = subscriber;
                                active = true;
                                filters = [namespace];
                                messagesReceived = 0;
                                messagesRequested = 0;
                                messagesConfirmed = 0;
                            };

                            let createResult = await subscriptionRepository.createSubscription(newSubscription);

                            switch (createResult) {
                                case (#ok(_)) {
                                    Debug.print("Subscription created successfully for namespace: " # namespace);
                                    #ok(());
                                };
                                case (#err(error)) {
                                    Debug.print("Subscription created successfully, but error creating subscription in repository: " # debug_show (error));
                                    #err(error);
                                };
                            };
                        } else {
                            Debug.print("Failed to subscribe to namespace via ICP service: " # namespace);
                            #err(#SubscriptionFailed);
                        };
                    };
                };
            } catch (error) {
                Debug.print("Unexpected error during subscription process: " # Error.message(error));
                #err(#SystemError("Error subscribing to namespace: " # Error.message(error)));
            };
        };
    };
};
