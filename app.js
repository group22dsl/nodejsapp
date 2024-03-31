const express = require('express');
const res = require('express/lib/response');

const app = express();

app.get('/', (req, res) => {
    res.send('successfully connected to server');
})

app.listen('3000', () => {
    console.log('App is lisstning to port 3000')
})

//this is test

module.exports = app;