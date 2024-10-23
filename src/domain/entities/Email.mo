import T "Types";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

module {
    public type EmailId = Text;

    public type Email = {
        id : EmailId;
        from : Text;
        to : Text;
        subject : Text;
        textBody : Text;
        htmlBody : Text;
        messageStream : ?Text;
    };

    public func equal(m1 : Email, m2 : Email) : Bool {
        m1.id == m2.id and m1.from == m2.from and m1.to == m2.to and m1.subject == m2.subject;
    };

    public func hash(m : Email) : Hash.Hash {
        let hashFields = m.id #
        m.from #
        m.to #
        m.subject;

        Text.hash(hashFields);
    };
};
