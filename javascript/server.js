const express = require('express');
const fs = require('fs');
const { spawn } = require('child_process');
const path = require('path');
const app = express();

app.use(express.json());
app.use('/json', express.static('json'));
app.use('/html', express.static('html'));

// serve item images
app.use('/images', express.static(path.join(__dirname, '../images')));

// Serve static HTML/JSON from the ../html folder
app.use(express.static(path.join(__dirname, '../html')));

const DEFAULT_HTML = path.join(__dirname, '../html/login_create_forgotpass.html');
const MAIN_MENU_HTML = path.join(__dirname, '../html/main_menu.html');
const LOCAL_DATA_PATH = path.join(__dirname, '../json/local/local_data.json');
const ITEMS_PATH = path.join(__dirname, '../json/items.json');
const ACCOUNTS_PATH = path.join(__dirname, '../json/accounts.json');
const LOCATIONS_PATH = path.join(__dirname, '../json/locations.json');

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
    }
    res.sendFile(DEFAULT_HTML);
});

app.post('/run-script', (req, res) => {
    console.log('Received run-script POST:', req.body);

    let { params } = req.body;
    if (!Array.isArray(params)) params = [];

    // Assume first param is script path, others are real params
    const scriptPath = params.shift();
    if (!scriptPath) return res.status(400).send('Missing script path');

    const absoluteScriptPath = path.resolve(path.join(__dirname, '../', scriptPath));

    // Prepare argument array
    const args = params;

    // Use spawn to avoid shell quoting issues
    const child = spawn('bash', [absoluteScriptPath, ...args], { stdio: ['ignore', 'pipe', 'pipe'] });

    let stdout = '';
    let stderr = '';

    child.stdout.on('data', (data) => {
        stdout += data;
    });

    child.stderr.on('data', (data) => {
        stderr += data;
    });

    child.on('close', (code) => {
        if (code !== 0) {
            console.error(stderr);
            return res.status(500).send(`Error: ${stderr || 'Script exited with code ' + code}`);
        }
        res.send(`Script output:\n${stdout}`);
    });
});

// ------------- Eric Added for forgot_password use-case ----------------
app.post('/verify-username', (req, res) => {
    // exec = spawn : require('child_process)
    // 
    //const pythonLocation = "C:\\Python\\python.exe"
    const spawn = require("child_process").spawn;
    const scriptPath = "use_cases/forgot_password/verify_username.py"

    const absoluteScriptPath = path.resolve(path.join(__dirname, '../', scriptPath))

    const enteredUsername = req.body.username;

    const pythonProcess = spawn('python', [absoluteScriptPath, enteredUsername]);
    try {

        pythonProcess.stdout.on('data', (data) => {
            const mystr = data.toString();
            const dataObject = JSON.parse(mystr);
            const responseValue = dataObject.response;
            res.json({ response: responseValue });
        })

    } catch (err) {
        console.log(err);
    }
});

app.post('/verify-security-answer', (req, res) => {
    const spawn = require("child_process").spawn;
    const scriptPath = "use_cases/forgot_password/verify_security_questions.py"
    const absoluteScriptPath = path.resolve(path.join(__dirname, '../', scriptPath))
    const username = req.body.username;
    const sq_question = req.body.selected_sq
    const sq_answer = req.body.sq_answer;
    let accumulatedData = '';

    const pythonProcess = spawn('python', [absoluteScriptPath, username, sq_question, sq_answer]);
    pythonProcess.stdout.on('data', (data) => {
        accumulatedData += data.toString();
    })
    pythonProcess.on('close', (code) => {
        if (code != 0) {
            console.error(`Python script exited with code ${code}`);
            return res.status(500).json({ response: "Server error: python script failed" });
        }
        try {
            const dataObject = JSON.parse(accumulatedData);
            const responseValue = dataObject.result;
            console.log(responseValue); // prints the Success
            res.json({ result: responseValue });
        } catch (err) {
            console.error('Json parsing error:', err.message);
            res.status(500).json({ response: "Server Error: Invalid data received from source" });

        }
    })
})

app.post('/verify-password', (req, res) => {
    username = req.body.username;
    password = req.body.password;
    const checkPasswordScriptPath = "use_cases/check_password_requirements/check_password_requirements.sh"
    const checkPasswordAbsolutePath = path.resolve(path.join(__dirname, '../', checkPasswordScriptPath))

    const { exec } = require('child_process');

    exec(`bash ${checkPasswordAbsolutePath} ${password}`, (error, stdout, stderr) => {
        // if (stdout.includes("8 characters")) {
        //     console.log(stdout);
        //     res.json({ result: stdout });
        // }
        console.log(stdout);
        const errorMessage1 = "Error: Password parameter is required.";
        const errorMessage2 = "Error: Password must be at least 8 characters long.";
        const errorMessage3 = "Error: Password must contain at least 1 uppercase letter.";
        const errorMessage4 = "Error: Password must contain at least 1 digit.";
        let errorCode = "Er0";

        switch (true) {
            case stdout.includes(errorMessage1): errorCode = "Er1"; break;
            case stdout.includes(errorMessage2): errorCode = "Er2"; break;
            case stdout.includes(errorMessage3): errorCode = "Er3"; break;
            case stdout.includes(errorMessage4): errorCode = "Er4"; break;
            default: break;
        }
        if (errorCode !== "Er0") {

            res.send({ response: errorCode });
        } else {
            // read the accounts file for our specific account

            const scriptPath = "use_cases/forgot_password/change_password_main.py"
            const absoluteScriptPath = path.resolve(path.join(__dirname, '../', scriptPath))
            let accumulatedData = '';
            const spawn = require("child_process").spawn;

            const pythonProcess = spawn('python', [absoluteScriptPath, username, password], {
                stdio: ['pipe', 'pipe', 'inherit']
            });

            pythonProcess.stdout.on('data', (returnedData) => {
                accumulatedData += returnedData.toString();
            })

            pythonProcess.stdout.on('close', (code) => {
                const jsonString = accumulatedData.trim()
                console.log(`Accumulated Data: ${jsonString}`);
                const dataObject = JSON.parse(jsonString);
                const responseValue = dataObject.result;
                //console.log(`Response value: ${responseValue}`); // prints the Success
                res.json({ result: responseValue });
            })

        }


    });
});
// ------------------- End of Eric's Additions --------------

// API route to get items
app.get('/api/items', (req, res) => {
    try {
        const rawData = fs.readFileSync(ITEMS_PATH, 'utf8');
        const items = JSON.parse(rawData);
        res.json(items);
    } catch (err) {
        console.error('Error reading items.json:', err);
        res.status(500).json({ error: 'Failed to load items' });
    }
});

// API route to get only the logged-in user's items with bookmark info
app.get('/api/my-items', (req, res) => {
    try {
        const localData = JSON.parse(fs.readFileSync(LOCAL_DATA_PATH, 'utf8'));
        const currentUserId = localData.currentlyLoggedInUserID;

        if (currentUserId === -1) {
            return res.status(401).json({ error: 'No user logged in' });
        }

        const accountsData = fs.readFileSync(ACCOUNTS_PATH, 'utf8');
        const accounts = JSON.parse(accountsData);
        const userAccount = accounts.find(acc => acc.id === currentUserId);

        if (!userAccount) {
            return res.status(404).json({ error: 'User account not found' });
        }

        const userItemIds = userAccount.myItems || [];
        const bookmarkedItems = userAccount.bookmarkedItems || [];

        const itemsData = fs.readFileSync(ITEMS_PATH, 'utf8');
        const allItems = JSON.parse(itemsData);

        const userItems = allItems.filter(item => userItemIds.includes(item.id));

        res.json({
            items: userItems,
            bookmarkedItems: bookmarkedItems
        });
    } catch (err) {
        console.error('Error loading user items:', err);
        res.status(500).json({ error: 'Failed to load user items' });
    }
});

// API route to get cart items for the logged-in user
app.get('/api/cart-items', (req, res) => {
    try {
        const localData = JSON.parse(fs.readFileSync(LOCAL_DATA_PATH, 'utf8'));
        const currentUserId = localData.currentlyLoggedInUserID;

        if (currentUserId === -1) {
            return res.status(401).json({ error: 'No user logged in' });
        }

        const accountsData = fs.readFileSync(ACCOUNTS_PATH, 'utf8');
        const accounts = JSON.parse(accountsData);
        const userAccount = accounts.find(acc => acc.id === currentUserId);

        if (!userAccount) {
            return res.status(404).json({ error: 'User account not found' });
        }

        const cartItemIds = userAccount.itemsInCart || [];
        const bookmarkedItems = userAccount.bookmarkedItems || [];
        const reservedItems = userAccount.reservedItems || [];

        const itemsData = fs.readFileSync(ITEMS_PATH, 'utf8');
        const allItems = JSON.parse(itemsData);

        const cartItems = allItems.filter(item => cartItemIds.includes(item.id));

        // Build map of all reserved items
        const allReservedItems = {};
        accounts.forEach(account => {
            if (Array.isArray(account.reservedItems)) {
                account.reservedItems.forEach(itemId => {
                    allReservedItems[itemId] = account.id;
                });
            }
        });

        res.json({
            items: cartItems,
            bookmarkedItems: bookmarkedItems,
            reservedItems: reservedItems,
            allReservedItems: allReservedItems
        });
    } catch (err) {
        console.error('Error loading cart items:', err);
        res.status(500).json({ error: 'Failed to load cart items' });
    }
});

// API route to get reserved items for the logged-in user
app.get('/api/reserved-items', (req, res) => {
    try {
        // Read local_data.json to get currentlyLoggedInUserID
        const localData = JSON.parse(fs.readFileSync(LOCAL_DATA_PATH, 'utf8'));
        const currentUserId = localData.currentlyLoggedInUserID;

        if (currentUserId === -1) {
            return res.status(401).json({ error: 'No user logged in' });
        }

        // Read accounts.json to find the user account
        const accountsData = fs.readFileSync(ACCOUNTS_PATH, 'utf8');
        const accounts = JSON.parse(accountsData);
        const userAccount = accounts.find(acc => acc.id === currentUserId);

        if (!userAccount) {
            return res.status(404).json({ error: 'User account not found' });
        }

        // Get the reservedItems array from the user account
        const reservedItemIds = userAccount.reservedItems || [];
        const bookmarkedItems = userAccount.bookmarkedItems || [];
        const cartItemIds = userAccount.itemsInCart || [];

        // Read items.json
        const itemsData = fs.readFileSync(ITEMS_PATH, 'utf8');
        const allItems = JSON.parse(itemsData);

        // Filter items whose id matches values in reservedItems array
        const reservedItems = allItems.filter(item => reservedItemIds.includes(item.id));

        // Build map of all reserved items across all accounts
        const allReservedItems = {};
        accounts.forEach(account => {
            if (Array.isArray(account.reservedItems)) {
                account.reservedItems.forEach(itemId => {
                    allReservedItems[itemId] = account.id;
                });
            }
        });

        res.json({
            items: reservedItems,
            bookmarkedItems: bookmarkedItems,
            reservedItems: reservedItemIds,
            itemsInCart: cartItemIds,
            allReservedItems: allReservedItems
        });
    } catch (err) {
        console.error('Error loading reserved items:', err);
        res.status(500).json({ error: 'Failed to load reserved items' });
    }
});

// API route to get store items based on currentStore in local_data.json
app.get('/api/store-items', (req, res) => {
    try {
        const localData = JSON.parse(fs.readFileSync(LOCAL_DATA_PATH, 'utf8'));
        const currentStoreId = localData.currentStore;
        const currentUserId = localData.currentlyLoggedInUserID;

        if (currentStoreId === undefined || currentStoreId === null) {
            return res.status(400).json({ error: 'No store selected' });
        }

        const locationsData = fs.readFileSync(LOCATIONS_PATH, 'utf8');
        const locations = JSON.parse(locationsData);
        const currentStore = locations.find(loc => loc.id === currentStoreId);

        if (!currentStore) {
            return res.status(404).json({ error: 'Store not found' });
        }

        const storeItemIds = currentStore.storeItems || [];

        const itemsData = fs.readFileSync(ITEMS_PATH, 'utf8');
        const allItems = JSON.parse(itemsData);

        const storeItems = allItems.filter(item => storeItemIds.includes(item.id));

        const accountsData = fs.readFileSync(ACCOUNTS_PATH, 'utf8');
        const accounts = JSON.parse(accountsData);
        const userAccount = accounts.find(acc => acc.id === currentUserId);

        const bookmarkedItems = userAccount ? (userAccount.bookmarkedItems || []) : [];
        const reservedItems = userAccount ? (userAccount.reservedItems || []) : [];
        const itemsInCart = userAccount ? (userAccount.itemsInCart || []) : [];

        res.json({
            items: storeItems,
            bookmarkedItems: bookmarkedItems,
            reservedItems: reservedItems,
            itemsInCart: itemsInCart
        });
    } catch (err) {
        console.error('Error loading store items:', err);
        res.status(500).json({ error: 'Failed to load store items' });
    }
});

// API route to get bookmarked items for the logged-in user
app.get('/api/bookmarked-items', (req, res) => {
    try {
        // Read local_data.json to get currentlyLoggedInUserID
        const localData = JSON.parse(fs.readFileSync(LOCAL_DATA_PATH, 'utf8'));
        const currentUserId = localData.currentlyLoggedInUserID;

        if (currentUserId === -1) {
            return res.status(401).json({ error: 'No user logged in' });
        }

        // Read accounts.json to find the user account
        const accountsData = fs.readFileSync(ACCOUNTS_PATH, 'utf8');
        const accounts = JSON.parse(accountsData);
        const userAccount = accounts.find(acc => acc.id === currentUserId);

        if (!userAccount) {
            return res.status(404).json({ error: 'User account not found' });
        }

        // Get the bookmarkedItems array from the user account
        const bookmarkedItemIds = userAccount.bookmarkedItems || [];
        const userItemIds = userAccount.myItems || [];
        const reservedItems = userAccount.reservedItems || [];
        const cartItemIds = userAccount.itemsInCart || [];

        // Read items.json
        const itemsData = fs.readFileSync(ITEMS_PATH, 'utf8');
        const allItems = JSON.parse(itemsData);

        // Read locations.json
        const locationsData = fs.readFileSync(LOCATIONS_PATH, 'utf8');
        const locations = JSON.parse(locationsData);

        // Filter items whose id matches values in bookmarkedItems array
        const bookmarkedItems = allItems.filter(item => bookmarkedItemIds.includes(item.id));

        // For each bookmarked item, determine ownership
        // Priority: Store > Current User > Other User
        const itemsWithOwnership = bookmarkedItems.map(item => {
            let ownership = { type: 'none', name: null, id: null };

            // First check if item belongs to a store (highest priority)
            const ownerStore = locations.find(loc =>
                loc.storeItems && loc.storeItems.includes(item.id)
            );

            if (ownerStore) {
                ownership = { type: 'store', name: ownerStore.name, id: ownerStore.id };
            } else if (userItemIds.includes(item.id)) {
                // Check if item belongs to current user
                ownership = { type: 'user', name: userAccount.username, id: currentUserId };
            } else {
                // Check if item belongs to another user
                const ownerAccount = accounts.find(acc =>
                    acc.myItems && acc.myItems.includes(item.id)
                );

                if (ownerAccount) {
                    ownership = { type: 'other_user', name: ownerAccount.username, id: ownerAccount.id };
                }
            }

            return {
                ...item,
                ownership
            };
        });

        // Filter out items that belong to other users
        const filteredItems = itemsWithOwnership.filter(item =>
            item.ownership.type !== 'other_user'
        );

        // Build map of all reserved items across all accounts
        const allReservedItems = {};
        accounts.forEach(account => {
            if (Array.isArray(account.reservedItems)) {
                account.reservedItems.forEach(itemId => {
                    allReservedItems[itemId] = account.id;
                });
            }
        });

        res.json({
            items: filteredItems,
            bookmarkedItems: bookmarkedItemIds,
            reservedItems: reservedItems,
            itemsInCart: cartItemIds,
            allReservedItems: allReservedItems,
            userItemIds: userItemIds
        });
    } catch (err) {
        console.error('Error loading bookmarked items:', err);
        res.status(500).json({ error: 'Failed to load bookmarked items' });
    }
});

// API route to get order history for the logged-in user
app.get('/api/order-history', (req, res) => {
    try {
        // Read local_data.json to get currentlyLoggedInUserID
        const localData = JSON.parse(fs.readFileSync(LOCAL_DATA_PATH, 'utf8'));
        const currentUserId = localData.currentlyLoggedInUserID;

        if (currentUserId === -1) {
            return res.status(401).json({ error: 'No user logged in' });
        }

        // Read accounts.json to find the user account
        const accountsData = fs.readFileSync(ACCOUNTS_PATH, 'utf8');
        const accounts = JSON.parse(accountsData);
        const userAccount = accounts.find(acc => acc.id === currentUserId);

        if (!userAccount) {
            return res.status(404).json({ error: 'User account not found' });
        }

        // Get the orderHistory array from the user account
        const orderHistory = userAccount.orderHistory || [];

        res.json({
            orders: orderHistory
        });
    } catch (err) {
        console.error('Error loading order history:', err);
        res.status(500).json({ error: 'Failed to load order history' });
    }
});

// API route to get all locations
app.get('/api/all-locations', (req, res) => {
    try {
        const locationsData = fs.readFileSync(LOCATIONS_PATH, 'utf8');
        const locations = JSON.parse(locationsData);

        res.json({
            locations: locations
        });
    } catch (err) {
        console.error('Error loading locations:', err);
        res.status(500).json({ error: 'Failed to load locations' });
    }
});

// API route to get accounts
app.get('/api/accounts', (req, res) => {
    try {
        const rawData = fs.readFileSync(ACCOUNTS_PATH, 'utf8');
        const accounts = JSON.parse(rawData);
        res.json(accounts);
    } catch (err) {
        console.error('Error reading accounts.json:', err);
        res.status(500).json({ error: 'Failed to load accounts' });
    }
});

// API route to get locations
app.get('/api/locations', (req, res) => {
    try {
        const rawData = fs.readFileSync(LOCATIONS_PATH, 'utf8');
        const locations = JSON.parse(rawData);
        res.json(locations);
    } catch (err) {
        console.error('Error reading locations.json:', err);
        res.status(500).json({ error: 'Failed to load locations' });
    }
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));