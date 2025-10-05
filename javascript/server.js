const express = require('express');
const fs = require('fs');
const { exec } = require('child_process');
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
    let { params } = req.body;
    if (!Array.isArray(params)) params = [];

    // Assume first param is script path, others are real params
    const scriptPath = params.shift();
    if (!scriptPath) return res.status(400).send('Missing script path');

    const absoluteScriptPath = path.resolve(path.join(__dirname, '../', scriptPath));

    // Only replace " and $ with their literal forms, leave everything else untouched
    const safeParams = params
        .map(p => 
            p.replace(/"/g, '\\"')  // escape double quotes
             .replace(/\$/g, '\\$') // escape dollar signs
        )
        .map(p => `'${p}'`) // wrap each param safely in single quotes
        .join(' ');

    exec(`bash "${absoluteScriptPath}" ${safeParams}`, (error, stdout, stderr) => {
        if (error) return res.status(500).send(`Error: ${error.message}`);
        if (stderr) console.error(stderr);
        res.send(`Script output:\n${stdout}`);
    });
});

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