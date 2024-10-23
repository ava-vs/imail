module {
    public type Namespace = Text;

    public type Event = {
        id : Nat;
        prevId : ?Nat;
        timestamp : Nat;
        namespace : Text;
        source : Principal;
        data : ICRC16;
        headers : ?Map;
    };

    public type Map = [(Text, ICRC16)];

    public type EventNotification = {
        id : Nat;
        eventId : Nat;
        prevId : ?Nat;
        timestamp : Nat;
        namespace : Text;
        data : ICRC16;
        source : Principal;
        headers : ?Map;
        filter : ?Text;
    };

    public type ICRC16Property = {
        name : Text;
        value : ICRC16;
        immutable : Bool;
    };

    public type ICRC16 = {
        #Array : [ICRC16];
        #Blob : Blob;
        #Bool : Bool;
        #Bytes : [Nat8];
        #Class : [ICRC16Property];
        #Float : Float;
        #Floats : [Float];
        #Int : Int;
        #Int16 : Int16;
        #Int32 : Int32;
        #Int64 : Int64;
        #Int8 : Int8;
        #Map : [(Text, ICRC16)];
        #ValueMap : [(ICRC16, ICRC16)];
        #Nat : Nat;
        #Nat16 : Nat16;
        #Nat32 : Nat32;
        #Nat64 : Nat64;
        #Nat8 : Nat8;
        #Nats : [Nat];
        #Option : ?ICRC16;
        #Principal : Principal;
        #Set : [ICRC16];
        #Text : Text;
    };

    public type Error = {
        #NotFound;
        #AlreadyExists;
        #DatabaseError;
        #InvalidInput;
        #SubscriptionFailed;
        #NotImplemented;
        #PublishError : Text;
        #SystemError : Text;
    };

    public type SubscriptionInfo = {
        namespace : Text; // The namespace of the subscription
        subscriber : Principal; // Principal ID of the subscriber
        active : Bool; // Indicates whether the subscription is currently active
        filters : [Text]; // Currently active filters for this subscription
        messagesReceived : Nat; // Total number of messages received under this subscription
        messagesRequested : Nat; // Number of messages explicitly requested or queried by the subscriber
        messagesConfirmed : Nat; // Number of messages confirmed by the subscriber (acknowledgment of processing or receipt)
    };

    // HTTPs outcalls

    public type Timestamp = Nat64;

    public type HttpRequestArgs = {
        url : Text;
        max_response_bytes : ?Nat64;
        headers : [HttpHeader];
        body : ?[Nat8];
        method : HttpMethod;
        transform : ?TransformRawResponseFunction;
    };

    public type HttpHeader = {
        name : Text;
        value : Text;
    };

    public type HttpMethod = {
        #get;
        #post;
        #head;
    };

    public type HttpResponsePayload = {
        status : Nat;
        headers : [HttpHeader];
        body : [Nat8];
    };

    // HTTPS outcalls have an optional "transform" key. These two types help describe it.
    // The transform function can transform the body in any way, add or remove headers, or modify headers.
    // This Type defines a function called 'TransformRawResponse', which is used above.

    public type TransformRawResponseFunction = {
        function : shared query TransformArgs -> async HttpResponsePayload;
        context : Blob;
    };

    public type TransformArgs = {
        response : HttpResponsePayload;
        context : Blob;
    };

    public type CanisterHttpResponsePayload = {
        status : Nat;
        headers : [HttpHeader];
        body : [Nat8];
    };

    public type TransformContext = {
        function : shared query TransformArgs -> async HttpResponsePayload;
        context : Blob;
    };

    public type IC = actor {
        http_request : HttpRequestArgs -> async HttpResponsePayload;
    };

};
