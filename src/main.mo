import EmailRepository "./data/repositories/EmailRepository";
import SubscriptionRepository "./data/repositories/SubscriptionRepository";
import UsecaseFactory "./domain/usecases/UsecaseFactory";
import IcpInterface "./infrastructure/IcpInterfaceImpl";
import Result "mo:base/Result";
import Debug "mo:base/Debug";
import T "./domain/entities/Types";
import Email "domain/entities/Email";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Nat32 "mo:base/Nat32";
import IEventNotificationRepository "domain/repositories/IEventNotificationRepository";
import EventNotificationRepository "data/repositories/EventNotificationRepository";

actor class DeMail(canister_id : Text) = Self {
    // Init repositories and services
    let hub = Principal.fromText("rvrj4-pyaaa-aaaal-ajluq-cai");
    let self = canister_id;
    let emailRepository = EmailRepository.EmailRepository();
    let icpInterface = IcpInterface.ICRC72ClientImpl(hub, Principal.fromText(self));
    let subscriptionRepository = SubscriptionRepository.SubscriptionRepository(icpInterface);
    let eventNotificationRepository : IEventNotificationRepository.IEventNotificationRepository = EventNotificationRepository.EventNotificationRepository();

    // Init usecaseFactory
    let usecaseFactory = UsecaseFactory.UsecaseFactory(emailRepository, subscriptionRepository, eventNotificationRepository, icpInterface);

    // Init usecases
    let getAllSubscriptionsUseCase = usecaseFactory.createGetAllSubscriptionsUseCase();
    let saveInboundEmailUseCase = usecaseFactory.createSaveInboundEmailUseCase();
    let subscribeNamespaceUseCase = usecaseFactory.createSubscribeNamespaceUseCase();
    let unsubscribeEventUseCase = usecaseFactory.createUnsubscribeEventUseCase();
    let publishEventUseCase = usecaseFactory.createPublishEventUseCase();
    let getEventNotificationsUseCase = usecaseFactory.createGetEventNotificationsUseCase();
    let receiveEventNotificationUseCase = usecaseFactory.createReceiveEventNotificationUseCase();

    // Public methods for message handling

    public func icrc72_handle_notification(notifications : [T.EventNotification]) : async () {
        Debug.print("Notifications received: " # debug_show (notifications));
        for (notification in notifications.vals()) {
            let result = await receiveEventNotificationUseCase.execute(notification);
            switch (result) {
                case (#ok(_)) {
                    Debug.print("Notification processed and saved successfully");
                };
                case (#err(error)) {
                    Debug.print("Error processing and saving notification: " # debug_show (error));
                };
            };
        };
    };

    public func getEventNotifications() : async Result.Result<[T.EventNotification], T.Error> {
        await getEventNotificationsUseCase.execute();
    };

    private type EmailRecord = {
        email : Email.Email;
        sent : Bool;
    };

    stable var emails : [EmailRecord] = [];

    // ID for email
    private var nextEmailId : Nat = 0;

    public func clearEmails() : async Result.Result<(), T.Error> {
        emails := [];
        #ok;
    };

    public func addEmail(email : Email.Email) : async Text {
        let emailId = Nat.toText(nextEmailId);
        nextEmailId += 1;

        let emailWithId = {
            email = {
                id = emailId;
                from = email.from;
                to = email.to;
                subject = email.subject;
                textBody = email.textBody;
                htmlBody = email.htmlBody;
                messageStream = ?"outbound";
            };
            sent = false;
        };

        emails := Array.append<EmailRecord>(emails, [emailWithId]);
        return emailId;
    };

    public func saveInboundEmail(email : Email.Email) : async Result.Result<Text, T.Error> {
        let result = await saveInboundEmailUseCase.execute(email);
        switch (result) {
            case (#ok(emailId)) {
                Debug.print("Inbound email saved with ID: " # emailId);
                #ok(emailId);
            };
            case (#err(error)) {
                Debug.print("Error saving inbound email: " # debug_show (error));
                #err(error);
            };
        };
    };

    public func getPendingEmails() : async [Email.Email] {
        let pendingEmails = Array.filter<EmailRecord>(
            emails,
            func(record : EmailRecord) : Bool {
                return not record.sent;
            },
        );
        return Array.map<EmailRecord, Email.Email>(
            pendingEmails,
            func(record : EmailRecord) : Email.Email {
                record.email;
            },
        );
    };

    public func markEmailAsSent(emailId : Text) : async () {
        emails := Array.map<EmailRecord, EmailRecord>(
            emails,
            func(record : EmailRecord) : EmailRecord {
                if (record.email.id == emailId) {
                    { email = record.email; sent = true };
                } else {
                    record;
                };
            },
        );
    };

    public func removeSentEmails() : async () {
        emails := Array.filter<EmailRecord>(
            emails,
            func(record : EmailRecord) : Bool {
                return not record.sent;
            },
        );
    };

    // Public methods for subscription handling
    // Subscribe method caller
    public func subscribeToNamespace(namespace : Text) : async Result.Result<(), T.Error> {
        let subscriber = self;
        let result = await subscribeNamespaceUseCase.execute(namespace, Principal.fromText(subscriber));
        switch (result) {
            case (#ok(_)) {
                Debug.print("Successfully subscribed to namespace: " # namespace);
            };
            case (#err(error)) {
                Debug.print("Error subscribing to namespace: " # namespace # ". Error: " # debug_show (error));
            };
        };
        result;
    };

    // Subsciption current canister
    public func subscribe(namespace : Text) : async Result.Result<(), T.Error> {
        let subscription : T.SubscriptionInfo = {
            namespace = namespace;
            subscriber = Principal.fromText(self);
            active = true;
            filters = [namespace];
            messagesReceived = 0;
            messagesRequested = 0;
            messagesConfirmed = 0;
        };
        let result = await subscribeNamespaceUseCase.execute(namespace, subscription.subscriber);
        switch (result) {
            case (#ok(_)) {
                Debug.print("Subscribed successfully to namespace: " # namespace);
            };
            case (#err(error)) {
                Debug.print("Error subscribing to namespace: " # namespace # ". Error: " # debug_show (error));
            };
        };
        result;
    };

    public func unsubscribe(namespace : Text) : async Result.Result<(), T.Error> {
        let result = await unsubscribeEventUseCase.execute(namespace, Principal.fromActor(Self));
        switch (result) {
            case (#ok(_)) {
                Debug.print("Unsubscribed successfully from namespace: " # namespace);
            };
            case (#err(error)) {
                Debug.print("Error unsubscribing from namespace: " # namespace # ". Error: " # debug_show (error));
            };
        };
        result;
    };

    public func getAllSubscriptions() : async Result.Result<[T.SubscriptionInfo], T.Error> {
        let result = await getAllSubscriptionsUseCase.execute();
        switch (result) {
            case (#ok(subscriptions)) {
                Debug.print("Successfully retrieved all subscriptions. Count: " # debug_show (subscriptions.size()));
            };
            case (#err(error)) {
                Debug.print("Error retrieving subscriptions: " # debug_show (error));
            };
        };
        result;
    };

    public func publishEvent(event : T.Event) : async Result.Result<[Nat], T.Error> {
        let result = await publishEventUseCase.execute(event);
        switch (result) {
            case (#ok(eventIds)) {
                Debug.print("Event published successfully. Event IDs: " # debug_show (eventIds));
            };
            case (#err(error)) {
                Debug.print("Error publishing event. Error: " # debug_show (error));
            };
        };
        result;
    };

    // Test mail
    public func createTestEmail() : async Result.Result<Text, T.Error> {
        let testEmail : Email.Email = {
            id = ""; // It will fill in addEmail
            from = "info@ava.capetown";
            to = "info@ava.capetown";
            subject = "Test Email";
            textBody = "This is a test email sent from the DeMail canister.";
            htmlBody = "<p>This is a test email sent from the DeMail canister.</p>";
            messageStream = ?"outbound";
        };

        let emailId = await addEmail(testEmail);
        Debug.print("Test email created with ID: " # emailId);
        #ok(emailId);
    };

    // Test Notification
    public func createTestNotification() : async Result.Result<(), T.Error> {
        // Subsribe with namespace
        let subscribeResult = await subscribe("test");
        switch (subscribeResult) {
            case (#err(error)) return #err(error);
            case (#ok(_)) {
                let testEvent : T.Event = {
                    id = 1;
                    prevId = null;
                    timestamp = Nat32.toNat(Nat32.fromIntWrap(Time.now()));
                    namespace = "test";
                    source = Principal.fromActor(Self);
                    data = #Text("This is a test notification");
                    headers = null;
                };

                let publishResult = await publishEvent(testEvent);
                switch (publishResult) {
                    case (#err(error)) return #err(error);
                    case (#ok(_)) {
                        Debug.print("Test notification created and published successfully");
                        return #ok(());
                    };
                };
            };
        };
    };

    public shared query func getAllEmails() : async [Email.Email] {
        Array.map<EmailRecord, Email.Email>(
            emails,
            func(record : EmailRecord) : Email.Email {
                record.email;
            },
        );
    };
};
