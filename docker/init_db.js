// Crate root user
db.createUser({
    "user": "__ROOT_USER__", 
    "pwd": "__ROOT_PW__", 
    "roles": [ "root" ] 
})
db.auth("__ROOT_USER__", "__ROOT_PW__");

// Create  read-only user
use __DB__;
db.createUser({
    "user": "__READ_USER__",
    "pwd": "__READ_PW__",
    "roles": ["read"]
});
