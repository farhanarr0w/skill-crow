const WebSocket = require('ws');
const { MongoClient } = require('mongodb');

const wss = new WebSocket.Server({ port: 8080 });

// MongoDB connection
const url = 'mongodb+srv://admin:abc123ef@cluster0.hq1ekox.mongodb.net/SkillCrow?retryWrites=true&w=majority';
const dbName = 'SkillCrow';

async function connectToMongoDB() {
    const client = new MongoClient(url);
    try {
        await client.connect();
        console.log('Connected to MongoDB');
        const db = client.db(dbName);
        const collection = db.collection('Chat');
        console.log('Collection:', collection.collectionName);

        // Fetch and print all documents in the collection
        const documents = await collection.find({}).toArray();
        console.log('Documents in Chat collection:', documents);

        // Watch for changes in the collection
        const changeStream = collection.watch();

        changeStream.on('change', (change) => {
            console.log('Change detected:', change);
            // Broadcast the change to all connected WebSocket clients
            wss.clients.forEach(client => {
                if (client.readyState === WebSocket.OPEN) {
                    client.send(JSON.stringify(change));
                }
            });
        });

    } catch (err) {
        console.error('Failed to connect to MongoDB', err);
    }
}

connectToMongoDB();

wss.on('connection', ws => {
    console.log('Client connected');
    ws.on('close', () => {
        console.log('Client disconnected');
    });
});
