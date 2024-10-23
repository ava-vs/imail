module {
    public type User = {
        id : Principal;
        username : Text;
        email : Text;
        telegram : Text;
        createdAt : Nat64;
        updatedAt : Nat64;
    };
};
