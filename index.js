const mysql = require('mysql2');
const express = require('express')
require("express-async-errors")
const app = express()
const PORT = process.env.PORT

function connectToMysql() {
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
}

function isConnectionOk() {
    return new Promise((resolve, reject) => {
        mysqlConnection.ping((err) => {
            if (err) {
                console.error(err);
                connectToMysql();
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

connectToMysql()
app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server started on port ${PORT}`)
})