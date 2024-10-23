import Result "mo:base/Result";
import T "../../domain/entities/Types";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Email "../../domain/entities/Email";

module {
    public class EmailRepository() {

        private var emails : HashMap.HashMap<Email.Email, Email.Email> = HashMap.HashMap<Email.Email, Email.Email>(0, Email.equal, Email.hash);

        public func saveInboundEmail(email : Email.Email) : async Result.Result<(), T.Error> {
            switch (emails.get(email)) {
                case null {
                    emails.put(email, email);
                    #ok(());
                };
                case (?_) {
                    #err(#AlreadyExists);
                };
            };
        };

        public func deleteInboundEmail(id : Email.EmailId) : async Result.Result<(), T.Error> {
            let foundMessage = Array.find<Email.Email>(
                Iter.toArray(emails.vals()),
                func(m : Email.Email) : Bool { m.id == id },
            );

            switch (foundMessage) {
                case null { #err(#NotFound) };
                case (?email) {
                    emails.delete(email);
                    #ok(());
                };
            };
        };

        public func getAllInboundEmail() : async Result.Result<[Email.Email], T.Error> {
            #ok(Iter.toArray(emails.vals()));
        };

        public func getInboundEmailById(id : Email.EmailId) : async Result.Result<Email.Email, T.Error> {
            let filteredMessages = Array.find<Email.Email>(
                Iter.toArray(emails.vals()),
                func(email : Email.Email) : Bool {
                    email.id == id;
                },
            );
            switch (filteredMessages) {
                case null {
                    #err(#NotFound);
                };
                case (?email) {
                    #ok(email);
                };
            };
        };
    };
};
