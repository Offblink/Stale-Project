/**
 * Fish Click Captcha Component
 * A game-based CAPTCHA where users click on a swimming fish
 * 
 * Usage:
 * const captcha = new FishCaptcha({
 *   container: '#captcha-container',
 *   onComplete: () => console.log('Verification complete!'),
 *   onFail: () => console.log('Click missed!')
 * });
 * captcha.init();
 */

class FishCaptcha {
    constructor(options = {}) {
        this.container = document.querySelector(options.container);
        this.onComplete = options.onComplete || (() => {});
        this.onFail = options.onFail || (() => {});
        this.onProgress = options.onProgress || (() => {});
        
        // Configuration
        this.config = {
            containerWidth: 460,
            containerHeight: 280,
            requiredClicks: 3,
            apiBase: '/api/captcha'
        };
        
        // State
        this.fishX = 100;
        this.fishY = 100;
        this.targetX = 100;
        this.targetY = 100;
        this.isCatched = false;
        this.isVerified = false;
        this.clickCount = 0;
        this.moveProgress = 0;
        this.fishFlip = 1;
        this.animationId = null;
        this.bubbles = [];
        
        // Bind methods
        this.catchFish = this.catchFish.bind(this);
        this.handleMiss = this.handleMiss.bind(this);
        this.moveFish = this.moveFish.bind(this);
        this.setNewTarget = this.setNewTarget.bind(this);
        this.initBubbles = this.initBubbles.bind(this);
    }
    
    /**
     * Initialize the captcha
     */
    async init() {
        if (!this.container) {
            console.error('Captcha container not found');
            return;
        }
        
        this.render();
        this.initBubbles();
        await this.generateTarget();
        this.startAnimation();
        
        // Add event listeners
        this.container.addEventListener('click', this.handleMiss);
    }
    
    /**
     * Render the captcha UI
     */
    render() {
        this.container.innerHTML = `
            <style>
                .captcha-container {
                    width: 100%;
                    height: 280px;
                    background: linear-gradient(180deg, #74b9ff 0%, #0984e3 100%);
                    border-radius: 24px;
                    position: relative;
                    overflow: hidden;
                    cursor: crosshair;
                    box-shadow: inset 6px 6px 10px rgba(163,177,198,0.4), inset -6px -6px 10px rgba(255,255,255,0.3);
                }
                .fish-wrapper {
                    position: absolute;
                    cursor: pointer;
                    font-size: 45px;
                    user-select: none;
                    transition: none;
                }
                .fish-wrapper:hover {
                    filter: brightness(1.15);
                }
                .fish-emoji {
                    display: inline-block;
                    animation: fishWiggle 0.5s ease-in-out infinite;
                }
                .fish-emoji.catched {
                    animation: catchPulse 0.6s ease-out;
                }
                .bubble {
                    position: absolute;
                    background: rgba(255, 255, 255, 0.6);
                    border-radius: 50%;
                    bottom: -20px;
                }
                .seaweed {
                    position: absolute;
                    bottom: 0;
                    font-size: 30px;
                    animation: seaweedSway 3s ease-in-out infinite;
                }
                .status-text {
                    text-align: center;
                    margin-top: 20px;
                    color: #6B7280;
                    font-size: 15px;
                    min-height: 24px;
                    transition: all 0.3s;
                }
                .status-text.success {
                    color: #38B2AC;
                    font-weight: 600;
                }
                .status-text.error {
                    color: #E53E3E;
                }
                .progress-bar {
                    width: 100%;
                    height: 12px;
                    background: #E0E5EC;
                    border-radius: 6px;
                    margin-top: 15px;
                    overflow: hidden;
                    box-shadow: inset 3px 3px 6px rgba(163,177,198,0.6), inset -3px -3px 6px rgba(255,255,255,0.5);
                }
                .progress-fill {
                    height: 100%;
                    background: linear-gradient(90deg, #6C63FF 0%, #8B84FF 100%);
                    width: 0%;
                    transition: width 0.3s;
                    border-radius: 6px;
                }
                @keyframes fishWiggle {
                    0%, 100% { transform: rotate(-5deg); }
                    50% { transform: rotate(5deg); }
                }
                @keyframes catchPulse {
                    0% { transform: scale(1); }
                    50% { transform: scale(1.3); opacity: 0.8; }
                    100% { transform: scale(1); opacity: 1; }
                }
                @keyframes bubbleRise {
                    0% { bottom: -20px; opacity: 0.6; }
                    100% { bottom: 300px; opacity: 0; }
                }
                @keyframes seaweedSway {
                    0%, 100% { transform: rotate(-5deg); }
                    50% { transform: rotate(5deg); }
                }
            </style>
            
            <!-- Seaweed decorations -->
            <div class="seaweed" style="left: 5%; animation-delay: 0s;">🌿</div>
            <div class="seaweed" style="left: 20%; animation-delay: 0.3s;">🌿</div>
            <div class="seaweed" style="left: 45%; animation-delay: 0.6s;">🌿</div>
            <div class="seaweed" style="left: 70%; animation-delay: 0.2s;">🌿</div>
            <div class="seaweed" style="left: 85%; animation-delay: 0.5s;">🌿</div>
            
            <!-- Bubbles container -->
            <div id="bubbles-container"></div>
            
            <!-- Fish -->
            <div class="fish-wrapper" id="fish-wrapper" style="left: 100px; top: 100px;">
                <span class="fish-emoji" id="fish-emoji">🐟</span>
            </div>
        `;
        
        // Add progress bar and status outside container
        this.container.insertAdjacentHTML('afterend', `
            <div class="progress-bar">
                <div class="progress-fill" id="progress-fill"></div>
            </div>
            <div class="status-text" id="status-text">点击游动的小鱼开始验证</div>
        `);
        
        this.fishWrapper = this.container.querySelector('#fish-wrapper');
        this.fishEmoji = this.container.querySelector('#fish-emoji');
        this.progressFill = document.querySelector('#progress-fill');
        this.statusText = document.querySelector('#status-text');
        this.bubblesContainer = this.container.querySelector('#bubbles-container');
    }
    
    /**
     * Initialize bubbles
     */
    initBubbles() {
        this.bubbles = Array.from({length: 8}, (_, i) => ({
            id: i,
            size: 8 + Math.random() * 12,
            x: 20 + Math.random() * (this.config.containerWidth - 40),
            delay: Math.random() * 2
        }));
        
        this.bubbles.forEach(bubble => {
            const bubbleEl = document.createElement('div');
            bubbleEl.className = 'bubble';
            bubbleEl.style.width = bubble.size + 'px';
            bubbleEl.style.height = bubble.size + 'px';
            bubbleEl.style.left = bubble.x + 'px';
            bubbleEl.style.animation = `bubbleRise 3s linear infinite`;
            bubbleEl.style.animationDelay = bubble.delay + 's';
            this.bubblesContainer.appendChild(bubbleEl);
        });
    }
    
    /**
     * Generate new target position from server
     */
    async generateTarget() {
        try {
            const response = await fetch(`${this.config.apiBase}/generate`);
            const data = await response.json();
            
            if (data.status === 'success') {
                this.targetX = data.targetX;
                this.targetY = data.targetY;
                this.config.requiredClicks = data.requiredClicks;
            }
        } catch (error) {
            console.error('Failed to generate target:', error);
        }
    }
    
    /**
     * Start fish animation
     */
    startAnimation() {
        this.moveFish();
    }
    
    /**
     * Stop animation
     */
    stopAnimation() {
        if (this.animationId) {
            cancelAnimationFrame(this.animationId);
        }
    }
    
    /**
     * Gaussian easing function
     */
    gaussianEasing(t) {
        const mean = 0.5;
        const sigma = 0.12;
        const exponent = -Math.pow(t - mean, 2) / (2 * Math.pow(sigma, 2));
        return Math.exp(exponent);
    }
    
    /**
     * Move fish with smooth animation
     */
    moveFish() {
        if (this.isVerified) return;
        
        if (!this.isCatched) {
            this.moveProgress += 0.008;
            
            if (this.moveProgress >= 1) {
                this.moveProgress = 0;
                this.setNewTarget();
            }
            
            const easedProgress = this.gaussianEasing(this.moveProgress);
            this.fishX = this.targetX - 22.5 + (this.fishX - this.targetX + 22.5) * (1 - easedProgress);
            this.fishY = this.targetY - 22.5 + (this.fishY - this.targetY + 22.5) * (1 - easedProgress);
            
            // Update fish direction
            const dx = this.targetX - this.fishX;
            if (dx > 5) {
                this.fishFlip = -1;
            } else if (dx < -5) {
                this.fishFlip = 1;
            }
            
            this.updateFishPosition();
        }
        
        this.animationId = requestAnimationFrame(this.moveFish);
    }
    
    /**
     * Update fish position on screen
     */
    updateFishPosition() {
        if (this.fishWrapper) {
            this.fishWrapper.style.left = this.fishX + 'px';
            this.fishWrapper.style.top = this.fishY + 'px';
            this.fishWrapper.style.transform = `scaleX(${this.fishFlip})`;
        }
    }
    
    /**
     * Set new random target position
     */
    async setNewTarget() {
        try {
            const response = await fetch(`${this.config.apiBase}/generate`);
            const data = await response.json();
            
            if (data.status === 'success') {
                const newTargetX = data.targetX;
                const newTargetY = data.targetY;
                
                // Update fish direction based on new target
                const dx = newTargetX - this.fishX;
                if (dx > 10) {
                    this.fishFlip = -1;
                } else if (dx < -10) {
                    this.fishFlip = 1;
                }
                
                this.targetX = newTargetX;
                this.targetY = newTargetY;
            }
        } catch (error) {
            console.error('Failed to set new target:', error);
        }
    }
    
    /**
     * Handle fish click
     */
    async catchFish(e) {
        e.stopPropagation();
        
        if (this.isCatched || this.isVerified) return;
        
        this.isCatched = true;
        this.fishEmoji.classList.add('catched');
        
        // Get click position relative to container
        const rect = this.container.getBoundingClientRect();
        const clickX = e.clientX - rect.left;
        const clickY = e.clientY - rect.top;
        
        try {
            const response = await fetch(`${this.config.apiBase}/verify`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    userX: clickX,
                    userY: clickY
                })
            });
            
            const data = await response.json();
            
            if (data.verified) {
                this.clickCount++;
                const progress = (this.clickCount / this.config.requiredClicks) * 100;
                
                this.statusText.textContent = `🎯 成功捕获! (${this.clickCount}/${this.config.requiredClicks})`;
                this.statusText.className = 'status-text success';
                this.progressFill.style.width = progress + '%';
                
                this.onProgress({
                    currentCount: this.clickCount,
                    requiredClicks: this.config.requiredClicks,
                    progress: progress
                });
                
                setTimeout(() => {
                    this.isCatched = false;
                    this.fishEmoji.classList.remove('catched');
                    this.moveProgress = 0;
                    
                    if (data.complete) {
                        this.isVerified = true;
                        this.stopAnimation();
                        this.statusText.textContent = '🎉 验证成功！';
                        this.onComplete();
                    } else {
                        this.targetX = data.newTargetX;
                        this.targetY = data.newTargetY;
                        this.statusText.textContent = '继续点击小鱼...';
                        this.statusText.className = 'status-text';
                    }
                }, 500);
            } else {
                setTimeout(() => {
                    this.isCatched = false;
                    this.fishEmoji.classList.remove('catched');
                }, 500);
            }
        } catch (error) {
            console.error('Verification failed:', error);
            this.isCatched = false;
            this.fishEmoji.classList.remove('catched');
        }
    }
    
    /**
     * Handle miss click
     */
    handleMiss() {
        if (this.isVerified || this.isCatched) return;
        
        this.statusText.textContent = '😅 没点到！再试一次';
        this.statusText.className = 'status-text error';
        this.onFail();
        
        setTimeout(() => {
            this.statusText.textContent = '点击游动的小鱼';
            this.statusText.className = 'status-text';
        }, 1500);
    }
    
    /**
     * Reset captcha state
     */
    async reset() {
        this.stopAnimation();
        this.clickCount = 0;
        this.moveProgress = 0;
        this.isCatched = false;
        this.isVerified = false;
        this.fishX = 100;
        this.fishY = 100;
        
        try {
            await fetch(`${this.config.apiBase}/reset`, {
                method: 'POST'
            });
            
            await this.generateTarget();
            this.progressFill.style.width = '0%';
            this.statusText.textContent = '点击游动的小鱼开始验证';
            this.statusText.className = 'status-text';
            this.startAnimation();
        } catch (error) {
            console.error('Reset failed:', error);
        }
    }
    
    /**
     * Destroy the captcha
     */
    destroy() {
        this.stopAnimation();
        this.container.removeEventListener('click', this.handleMiss);
        
        if (this.fishWrapper && this.fishWrapper.containsEventListener) {
            this.fishWrapper.removeEventListener('click', this.catchFish);
        }
        
        // Clean up DOM
        const progressBar = document.querySelector('.progress-bar');
        const statusText = document.querySelector('.status-text');
        if (progressBar) progressBar.remove();
        if (statusText) statusText.remove();
    }
}

// Export for use in modules or global scope
if (typeof module !== 'undefined' && module.exports) {
    module.exports = FishCaptcha;
} else {
    window.FishCaptcha = FishCaptcha;
}