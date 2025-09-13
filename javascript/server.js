const express = require('express');
const fs = require('fs');
const { exec } = require('child_process');
const path = require('path');
const app = express();

app.use(express.json());

// Serve static HTML/JSON from the ../html folder
app.use(express.static(path.join(__dirname, '../html')));

const DEFAULT_HTML = path.join(__dirname, '../html/login_create_forgotpass.html');

// Route root "/" to default HTML
app.get('/', (req, res) => {
    res.sendFile(DEFAULT_HTML);
});

app.post('/run-script', (req, res) => {
    let { params } = req.body;
    if (!Array.isArray(params)) params = [];
    if (params.length > 10) params = params.slice(0, 10);

    // Assume first param is script path, others are real params
    const scriptPath = params.shift();
    if (!scriptPath) return res.status(400).send('Missing script path');

    const absoluteScriptPath = path.resolve(path.join(__dirname, '../', scriptPath));
    const safeParams = params.map(p => `'${p.replace(/'/g, `'\\''`)}'`).join(' ');

    exec(`bash "${absoluteScriptPath}" ${safeParams}`, (error, stdout, stderr) => {
        if (error) return res.status(500).send(`Error: ${error.message}`);
        if (stderr) console.error(stderr);
        res.send(`Script output:\n${stdout}`);
    });
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));
