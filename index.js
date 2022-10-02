// Load the AWS SDK
var AWS = require('aws-sdk'),
    region = "us-east-2",
    secretName = "mydb_secret",
    secret,
    decodedBinarySecret;

// Create a Secrets Manager client
var client = new AWS.SecretsManager({
    region: region
});
var DB_URI = "";
client.getSecretValue({SecretId: secretName}, function(err, data) {
    if (err) {
        console.log("error in geting secret");
    }
    else {
        // Decrypts secret using the associated KMS key.
        // Depending on whether the secret is a string or binary, one of these fields will be populated.
        if ('SecretString' in data) {
            secret = JSON.parse(data.SecretString);
            DB_URI = secret;
            console.log(DB_URI);
        } else {
            console.log("error in secret");
        }
    }
   
    // Your code goes here. 
});

const mysql = require('mysql2');
const env = require('dotenv').config();
const express = require('express')
require("express-async-errors")
const app = express()
const PORT = process.env.PORT

function connectToMysql() {
    mysqlConnection = mysql.createConnection({
        uri: DB_URI,        // example => mysql://user:password@localhost:port/dbName
    })
    mysqlConnection.connect((err) => {
        if (!err) {
            console.log('DB connection succeeded.');
        } else {
            console.error(err);
        }
    });
}

function isConnectionOk() {
    return new Promise((resolve, reject) => {
        mysqlConnection = mysql.createConnection({
            uri: process.env.DB_URI,        // example => mysql://user:password@localhost:port/dbName
        })
        mysqlConnection.connect((err) => {
            if (!err) {
                console.log('DB connection succeeded.');
            } else {
                console.error(err);
            }
        });
        mysqlConnection.ping((err) => {
            if (err) {
                console.error(err);
                resolve(false)
            } else {
                resolve(true)
            }
        })
    })
}

app.get('/live', async (req, res) => {
    const isOk = await isConnectionOk()
    const response = isOk ? "Well done" : "Maintenance"
    res.send(response)
})

app.use((err, req, res, next) => {
    console.error(err.stack)
    res.status(500).send('Something broke!')
})

//connectToMysql()
app.get('/', async (req, res) => {
    const response = "nothing"
    res.send(response)
})
app.listen(PORT, () => {
    console.log(`Server started on port ${PORT}`)
})