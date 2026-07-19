const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// A simple endpoint for testing
app.get('/api/health', (req, res) => {
    res.json({ status: "healthy", timestamp: new Date() });
});

app.listen(PORT, () => {
    console.log(`Application successfully listening on port ${PORT}`);
});
