const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// This is the new root route! It handles requests to exactly "http://localhost:3000"
app.get('/', (req, res) => {
    res.send('<h1>Hello from my Docknkxer Container! 🐳</h1><p>My DevOps Assignment is running successfully .</p>');

    res.send('<h1>Testing hte pipeline NO 1 </h1>');
});

// Your existing health check endpoint
app.get('/api/health', (req, res) => {
    res.json({ status: "healthy", timestamp: new Date() });
});

app.listen(PORT, () => {
    console.log(`Application successfully listening on port ${PORT}`);
});
