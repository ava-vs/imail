import Result "mo:base/Result";
import Error "mo:base/Error";
import T "../entities/Types";
import IIcpService "../interfaces/IIcpService";

module {
    public class PublishEventUseCase(icpService : IIcpService.IIcpService) {
        public func execute(event : T.Event) : async Result.Result<[Nat], T.Error> {
            try {
                let result = await icpService.publish(event);
                switch (result) {
                    case (#ok(eventIds)) {
                        #ok(eventIds)
                    };
                    case (#err(error)) {
                        #err(#PublishError(error))
                    };
                }
            } catch (error) {
                #err(#SystemError("Error publishing event: " # Error.message(error)))
            }
        };
    };
};
