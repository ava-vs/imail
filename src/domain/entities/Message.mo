import Time "mo:base/Time";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import T "./Types";

module {
    public type MessageId = Nat;

    public type Message = {
        id : MessageId;
        sender : Text;
        recipient : Text;
        subject : Text;
        body : Text;
        data : T.ICRC16;
        headers : ?T.Map;
        timestamp : Time.Time;
        filter : ?Text;
        namespace : Text;
        isRead : Bool;
    };

    public func createMessage(
        id : MessageId,
        sender : Text,
        recipient : Text,
        subject : Text,
        body : Text,
        data : T.ICRC16,
        headers : ?T.Map,
        filter : ?Text,
        namespace : Text,
    ) : Message {
        {
            id = id;
            sender = sender;
            recipient = recipient;
            subject = subject;
            body = body;
            data = data;
            headers = headers;
            timestamp = Time.now();
            filter = filter;
            namespace = namespace;
            isRead = false;
        };
    };

    public func equal(m1 : Message, m2 : Message) : Bool {
        m1.id == m2.id and m1.sender == m2.sender and m1.recipient == m2.recipient and m1.subject == m2.subject;
    };

    public func hash(m : Message) : Hash.Hash {
        let hashFields = Nat.toText(m.id) #
        m.sender #
        m.recipient #
        m.subject;

        Text.hash(hashFields);
    };
};
