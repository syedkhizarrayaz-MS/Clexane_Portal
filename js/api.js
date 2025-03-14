// API endpoints
const API_BASE_URL = 'http://localhost/clexane-store-locator/api';

// Function to get nearby stores
async function getNearbyStores(latitude, longitude) {
    try {
        const response = await fetch(`${API_BASE_URL}/stores/get_nearby_stores.php`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ latitude, longitude })
        });
        
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        
        return await response.json();
    } catch (error) {
        console.error('Error fetching nearby stores:', error);
        throw error;
    }
}

// Function to record store visits
async function recordVisit(storeId, actionType) {
    try {
        const response = await fetch(`${API_BASE_URL}/visits/record_visit.php`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                store_id: storeId,
                action_type: actionType
            })
        });
        
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        
        return await response.json();
    } catch (error) {
        console.error('Error recording visit:', error);
        throw error;
    }
}