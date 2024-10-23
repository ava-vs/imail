// import Blob "mo:base/Blob";
// import Cycles "mo:base/ExperimentalCycles";
// import Debug "mo:base/Debug";
// import Error "mo:base/Error";
// import Nat8 "mo:base/Nat8";
// import Text "mo:base/Text";
// import Int "mo:base/Int";
// import Time "mo:base/Time";

// actor EmailSender {
//     type HttpHeader = { name : Text; value : Text };
//     type HttpMethod = {
//         #get;
//         #post;
//         #head;
//     };
//     type TransformArgs = {
//         response : {
//             status : Nat;
//             headers : [HttpHeader];
//             body : [Nat8];
//         };
//         context : Blob;
//     };
//     type CanisterHttpResponsePayload = {
//         status : Nat;
//         headers : [HttpHeader];
//         body : [Nat8];
//     };
//     type HttpRequestArgs = {
//         url : Text;
//         max_response_bytes : ?Nat64;
//         headers : [HttpHeader];
//         body : ?[Nat8];
//         method : HttpMethod;
//         transform : ?{
//             function : shared query TransformArgs -> async CanisterHttpResponsePayload;
//             context : Blob;
//         };
//     };
//     type HttpResponsePayload = {
//         status : Nat;
//         headers : [HttpHeader];
//         body : [Nat8];
//     };
//     type IC = actor {
//         http_request : HttpRequestArgs -> async HttpResponsePayload;
//     };

//     let POSTMARK_SERVER_TOKEN = "c96de87a-2dc8-4c8b-8a20-f9d012a8d4ca";

//     public query func transform(raw : TransformArgs) : async CanisterHttpResponsePayload {
//         let transformed : CanisterHttpResponsePayload = {
//             status = raw.response.status;
//             body = raw.response.body;
//             headers = [
//                 {
//                     name = "Content-Security-Policy";
//                     value = "default-src 'self'";
//                 },
//                 { name = "Referrer-Policy"; value = "strict-origin" },
//                 { name = "Permissions-Policy"; value = "geolocation=(self)" },
//                 {
//                     name = "Strict-Transport-Security";
//                     value = "max-age=63072000";
//                 },
//                 { name = "X-Frame-Options"; value = "DENY" },
//                 { name = "X-Content-Type-Options"; value = "nosniff" },
//             ];
//         };
//         transformed;
//     };

//     public func sendEmail() : async Text {
//         let ic : IC = actor ("aaaaa-aa");

//         let url = "https://api.postmarkapp.com/email";
//         let host = "api.postmarkapp.com";

//         let idempotency_key = generateUUID();
//         let request_headers = [
//             { name = "Host"; value = host # ":443" },
//             { name = "Accept"; value = "application/json" },
//             { name = "Content-Type"; value = "application/json" },
//             {
//                 name = "X-Postmark-Server-Token";
//                 value = POSTMARK_SERVER_TOKEN;
//             },
//             { name = "Idempotency-Key"; value = idempotency_key },
//         ];

//         let request_body_json = "{
//             \"From\": \"info@ava.capetown\",
//             \"To\": \"info@ava.capetown\",
//             \"Subject\": \"Postmark test\",
//             \"TextBody\": \"Hello ICP user.\",
//             \"HtmlBody\": \"<html><body><strong>Hello</strong> dear user.</body></html>\",
//             \"MessageStream\": \"outbound\"
//         }";
//         let request_body_as_Blob = Text.encodeUtf8(request_body_json);
//         let request_body_as_nat8 = Blob.toArray(request_body_as_Blob);

//         let transform_context = {
//             function = transform;
//             context = Blob.fromArray([]);
//         };

//         let http_request : HttpRequestArgs = {
//             url = url;
//             max_response_bytes = null;
//             headers = request_headers;
//             body = ?request_body_as_nat8;
//             method = #post;
//             transform = ?transform_context;
//         };

//         Debug.print("sendEmail: Email ready to send");
//         Cycles.add<system>(40_850_258_000);

//         try {
//             let http_response : HttpResponsePayload = await ic.http_request(http_request);

//             let response_body = Blob.fromArray(http_response.body);
//             let decoded_text = switch (Text.decodeUtf8(response_body)) {
//                 case (null) { "No value returned" };
//                 case (?y) { y };
//             };

//             "Status: " # debug_show (http_response.status) # ", Body: " # decoded_text;
//         } catch (error) {
//             "Error: " # Error.message(error);
//         };
//     };

//     func generateUUID() : Text {
//         "UUID-" # debug_show (Blob.hash(Text.encodeUtf8(Int.toText(Time.now()))));
//     };
// };
