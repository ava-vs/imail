module {
    public type SubscriptionInfo = {
        namespace : Text; // The namespace of the subscription
        subscriber : Principal; // Principal ID of the subscriber
        active : Bool; // Indicates whether the subscription is currently active
        filters : [Text]; // Currently active filters for this subscription
    };
};
