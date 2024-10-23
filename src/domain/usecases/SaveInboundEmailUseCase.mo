import Result "mo:base/Result";
import T "../../domain/entities/Types";
import Email "../../domain/entities/Email";
import IEmailRepository "../../domain/repositories/IEmailRepository";
import Time "mo:base/Time";

module {
    public class SaveInboundEmailUseCase(repository : IEmailRepository.IEmailRepository) {
        public func execute(email : Email.Email) : async Result.Result<Text, T.Error> {
            let inboundEmail : Email.Email = {
                id = email.id;
                from = email.from;
                to = email.to;
                subject = email.subject;
                textBody = email.textBody;
                htmlBody = email.htmlBody;
                messageStream = ?("inbound");
                timestamp = Time.now();
            };

            let result = await repository.saveInboundEmail(inboundEmail);
            switch (result) {
                case (#ok(_)) {
                    #ok(inboundEmail.id);
                };
                case (#err(error)) {
                    #err(error);
                };
            };
        };
    };
};
