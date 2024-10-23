import Email "../entities/Email";
import Result "mo:base/Result";
import T "../entities/Types";

module {
    public type IEmailRepository = {
        saveInboundEmail : (Email.Email) -> async Result.Result<(), T.Error>;
        getInboundEmailById : (Email.EmailId) -> async Result.Result<Email.Email, T.Error>;
        deleteInboundEmail : (Email.EmailId) -> async Result.Result<(), T.Error>;
        getAllInboundEmail : () -> async Result.Result<[Email.Email], T.Error>;
    };
};
