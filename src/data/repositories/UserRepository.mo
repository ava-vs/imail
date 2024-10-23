import Result "mo:base/Result";
import T "../../domain/entities/Types";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import User "../../domain/entities/User";

module {
    public class UserRepository() {

        private var users : HashMap.HashMap<Principal, User.User> = HashMap.HashMap<Principal, User.User>(0, Principal.equal, Principal.hash);

        public func createUser(user : User.User) : async Result.Result<(), T.Error> {
            switch (users.get(user.id)) {
                case null {
                    users.put(user.id, user);
                    #ok(());
                };
                case (?_) {
                    #err(#AlreadyExists);
                };
            };
        };

        public func getUser(id : Principal) : async Result.Result<User.User, T.Error> {
            switch (users.get(id)) {
                case null { #err(#NotFound) };
                case (?user) { #ok(user) };
            };
        };

        public func updateUser(user : User.User) : async Result.Result<(), T.Error> {
            switch (users.get(user.id)) {
                case null {
                    #err(#NotFound);
                };
                case (?_) {
                    users.put(user.id, user);
                    #ok(());
                };
            };
        };

        public func deleteUser(id : Principal) : async Result.Result<(), T.Error> {
            switch (users.get(id)) {
                case null { #err(#NotFound) };
                case (?_) {
                    users.delete(id);
                    #ok(());
                };
            };
        };

        public func getAllUsers() : async Result.Result<[User.User], T.Error> {
            #ok(Iter.toArray(users.vals()));
        };

        public func getUserByUsername(username : Text) : async Result.Result<User.User, T.Error> {
            let foundUser = Array.find<User.User>(
                Iter.toArray(users.vals()),
                func(u : User.User) : Bool { u.username == username },
            );

            switch (foundUser) {
                case null { #err(#NotFound) };
                case (?user) { #ok(user) };
            };
        };

        public func getUserByTelegram(telegram : Text) : async Result.Result<User.User, T.Error> {
            let foundUser = Array.find<User.User>(
                Iter.toArray(users.vals()),
                func(u : User.User) : Bool { u.telegram == telegram },
            );

            switch (foundUser) {
                case null { #err(#NotFound) };
                case (?user) { #ok(user) };
            };
        };

        public func getUserByEmail(email : Text) : async Result.Result<User.User, T.Error> {
            let foundUser = Array.find<User.User>(
                Iter.toArray(users.vals()),
                func(u : User.User) : Bool { u.email == email },
            );

            switch (foundUser) {
                case null { #err(#NotFound) };
                case (?user) { #ok(user) };
            };
        };
    };
};
