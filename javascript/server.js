const express = require('express');
const fs = require('fs');
const { exec } = require('child_process');
const path = require('path');
const app = express();

app.use(express.json());
app.use('/json', express.static('json'));

// Serve static HTML/JSON from the ../html folder
app.use(express.static(path.join(__dirname, '../html')));

const DEFAULT_HTML = path.join(__dirname, '../html/login_create_forgotpass.html');
const MAIN_MENU_HTML = path.join(__dirname, '../html/main_menu.html');
const LOCAL_DATA_PATH = path.join(__dirname, '../json/local/local_data.json');

// Route root "/" to either DEFAULT_HTML or MAIN_MENU_HTML
app.get('/', (req, res) => {
    try {
        const rawData = fs.readFileSync(LOCAL_DATA_PATH, 'utf8');
        const json = JSON.parse(rawData);

        if (json.currentlyLoggedInUserID !== -1) {
            return res.sendFile(MAIN_MENU_HTML);
        }
    } catch (err) {
        console.error('Error reading local_data.json:', err);
        // If there's an error, just fall back to DEFAULT_HTML
    }
    res.sendFile(DEFAULT_HTML);
});

app.post('/run-script', (req, res) => {
    let { params } = req.body;
    if (!Array.isArray(params)) params = [];

    // Assume first param is script path, others are real params
    const scriptPath = params.shift();
    if (!scriptPath) return res.status(400).send('Missing script path');

    const absoluteScriptPath = path.resolve(path.join(__dirname, '../', scriptPath));

    // Replace spaces with ~ and escape single quotes
    const safeParams = params
        .map(p => p.replace(/ /g, '~'))                    // convert spaces to ~
        .map(p => `'${p.replace(/'/g, `'\\''`)}'`)          // escape single quotes
        .join(' ');

    exec(`bash "${absoluteScriptPath}" ${safeParams}`, (error, stdout, stderr) => {
        if (error) return res.status(500).send(`Error: ${error.message}`);
        if (stderr) console.error(stderr);
        res.send(`Script output:\n${stdout}`);
    });
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));
