# 🐟 Fish Click Captcha API

A game-based CAPTCHA service where users click on a swimming fish to complete verification. Perfect for preventing automated attacks on login/register forms.

## ✨ Features

- **Game-based Verification**: Click on the swimming fish instead of typing distorted text
- **Natural Movement**: Smooth fish swimming animation using Gaussian easing
- **Progressive Challenge**: Requires 3 successful clicks to complete verification
- **Anti-Cheat**: Server-side position verification with tolerance checking
- **Beautiful UI**: Underwater theme with bubbles and seaweed decorations
- **Easy Integration**: Simple JavaScript API for quick integration

## 📁 Project Structure

```
captcha-api/
├── src/main/java/com/example/captcha/
│   ├── CaptchaService.java    # Core service logic
│   └── CaptchaServlet.java    # REST API endpoints
├── src/main/webapp/
│   ├── js/
│   │   └── fish-captcha.js    # Frontend component
│   └── demo.html              # Demo page
├── docs/
│   └── API.md                 # API documentation
└── README.md                  # This file
```

## 🚀 Quick Start

### Backend Setup

1. Add the servlet to your web application
2. Configure the servlet mapping in `web.xml` or use `@WebServlet` annotation

### Frontend Integration

```html
<!-- Add container -->
<div id="captcha-container"></div>

<!-- Include the script -->
<script src="js/fish-captcha.js"></script>

<script>
// Initialize captcha
const captcha = new FishCaptcha({
    container: '#captcha-container',
    onComplete: () => {
        console.log('Verification complete!');
        // Redirect or submit form
    },
    onFail: () => console.log('Missed!'),
    onProgress: (progress) => console.log(progress)
});

captcha.init();
</script>
```

## 🔌 API Endpoints

### GET /api/captcha/generate

Generate a new target position for the fish.

**Response:**
```json
{
  "status": "success",
  "targetX": 150,
  "targetY": 100,
  "requiredClicks": 3
}
```

### POST /api/captcha/verify

Verify user's click position.

**Request:**
```json
{
  "userX": 155,
  "userY": 98
}
```

**Response:**
```json
{
  "status": "success",
  "verified": true,
  "complete": false,
  "currentCount": 1,
  "requiredClicks": 3,
  "newTargetX": 200,
  "newTargetY": 150
}
```

### GET /api/captcha/status

Get current verification status.

**Response:**
```json
{
  "currentCount": 2,
  "requiredClicks": 3,
  "progress": 66.67
}
```

### POST /api/captcha/reset

Reset captcha state.

**Response:**
```json
{
  "status": "success"
}
```

## 📖 JavaScript API

### Constructor Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| container | String | null | CSS selector for captcha container |
| onComplete | Function | () => {} | Callback when verification completes |
| onFail | Function | () => {} | Callback when user misses the fish |
| onProgress | Function | () => {} | Callback on progress update |

### Methods

| Method | Description |
|--------|-------------|
| init() | Initialize the captcha |
| reset() | Reset captcha to initial state |
| destroy() | Clean up and remove captcha |

### Events

**onComplete**
Called when the user successfully completes the verification.

**onFail**
Called when the user clicks outside the fish.

**onProgress**
Called when progress is made. Returns an object with:
- `currentCount`: Number of successful clicks
- `requiredClicks`: Total clicks required
- `progress`: Percentage complete

## 🎨 Design Features

### Animation Effects
- **Fish Wiggle**: Smooth swimming animation
- **Bubble Rise**: Rising bubbles decoration
- **Seaweed Sway**: Gentle swaying motion
- **Catch Pulse**: Pulse effect when fish is caught

### Visual Theme
- Underwater gradient background
- Neumorphism design elements
- Smooth transitions and animations

## 🔧 Configuration

### Server-side

```java
// Container dimensions
int CONTAINER_WIDTH = 460;
int CONTAINER_HEIGHT = 280;

// Verification settings
int REQUIRED_CLICKS = 3;
int TOLERANCE = 15; // Position tolerance in pixels
```

### Client-side

```javascript
const config = {
    containerWidth: 460,
    containerHeight: 280,
    requiredClicks: 3,
    apiBase: '/api/captcha'
};
```

## 🛡️ Security

- **Server-side Verification**: Click positions are validated on the server
- **Session-based**: Target positions are stored in user session
- **Tolerance Checking**: Allows small position variations (±15px)
- **Rate Limiting**: Can be added to prevent abuse

## 📝 License

MIT License

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Contact

For questions or support, please open an issue on GitHub.