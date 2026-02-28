// Shooting Game - Player vs Alien
// Player controls: Mouse to aim, Click to shoot

Player player;
Alien alien;
ArrayList<Bullet> playerBullets;
ArrayList<Bullet> alienBullets;

void setup() {
  size(800, 600);
  
  // Initialize player in bottom left corner
  player = new Player(100, height - 100);
  
  // Initialize alien in top right corner
  alien = new Alien(width - 100, 100);
  
  // Initialize bullet lists
  playerBullets = new ArrayList<Bullet>();
  alienBullets = new ArrayList<Bullet>();
}

void draw() {
  background(20, 20, 40);
  
  // Update and display player
  player.update();
  player.display();
  
  // Update and display alien
  alien.update();
  alien.display();
  
  // Update and display player bullets
  for (int i = playerBullets.size() - 1; i >= 0; i--) {
    Bullet b = playerBullets.get(i);
    b.update();
    b.display();
    
    // Check collision with alien
    if (b.hits(alien.x, alien.y, 40)) {
      alien.takeDamage(10);
      playerBullets.remove(i);
    }
    // Remove if off screen
    else if (b.isOffScreen()) {
      playerBullets.remove(i);
    }
  }
  
  // Update and display alien bullets
  for (int i = alienBullets.size() - 1; i >= 0; i--) {
    Bullet b = alienBullets.get(i);
    b.update();
    b.display();
    
    // Check collision with player
    if (b.hits(player.x, player.y, 40)) {
      player.takeDamage(10);
      alienBullets.remove(i);
    }
    // Remove if off screen
    else if (b.isOffScreen()) {
      alienBullets.remove(i);
    }
  }
  
  // Alien shoots periodically
  if (frameCount % 60 == 0 && alien.health > 0) {
    alien.shoot();
  }
  
  // Check game over
  if (player.health <= 0) {
    textAlign(CENTER, CENTER);
    fill(255, 0, 0);
    textSize(48);
    text("GAME OVER", width/2, height/2);
    textSize(24);
    text("Press R to Restart", width/2, height/2 + 50);
    noLoop();
  }
  
  if (alien.health <= 0) {
    textAlign(CENTER, CENTER);
    fill(0, 255, 0);
    textSize(48);
    text("YOU WIN!", width/2, height/2);
    textSize(24);
    text("Press R to Restart", width/2, height/2 + 50);
    noLoop();
  }
}

void mousePressed() {
  if (player.health > 0 && player.ammo > 0) {
    player.shoot();
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    setup();
    loop();
  }
}

// Player class
class Player {
  float x, y;
  int health;
  int ammo;
  float gunAngle;
  
  Player(float x, float y) {
    this.x = x;
    this.y = y;
    this.health = 100;
    this.ammo = 30;
  }
  
  void update() {
    // Calculate gun angle based on mouse position
    gunAngle = atan2(mouseY - y, mouseX - x);
  }
  
  void display() {
    // Draw player body
    fill(0, 150, 255);
    stroke(255);
    strokeWeight(2);
    ellipse(x, y, 40, 40);
    
    // Draw gun
    pushMatrix();
    translate(x, y);
    rotate(gunAngle);
    fill(100);
    rect(0, -5, 30, 10);
    popMatrix();
    
    // Display health bar
    drawHealthBar(20, 20, health, 100);
    
    // Display ammo count
    fill(255);
    textAlign(LEFT);
    textSize(16);
    text("Ammo: " + ammo, 20, 60);
  }
  
  void shoot() {
    if (ammo > 0) {
      float bulletSpeed = 8;
      float vx = cos(gunAngle) * bulletSpeed;
      float vy = sin(gunAngle) * bulletSpeed;
      playerBullets.add(new Bullet(x, y, vx, vy, true));
      ammo--;
    }
  }
  
  void takeDamage(int damage) {
    health -= damage;
    if (health < 0) health = 0;
  }
  
  void drawHealthBar(float x, float y, int current, int max) {
    // Background
    fill(100);
    rect(x, y, 200, 20);
    
    // Health
    float healthWidth = map(current, 0, max, 0, 200);
    if (current > 60) {
      fill(0, 255, 0);
    } else if (current > 30) {
      fill(255, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    rect(x, y, healthWidth, 20);
    
    // Border
    noFill();
    stroke(255);
    strokeWeight(2);
    rect(x, y, 200, 20);
    
    // Text
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(12);
    text("Health: " + current, x + 100, y + 10);
  }
}

// Alien class
class Alien {
  float x, y;
  int health;
  float moveTimer;
  float targetX, targetY;
  
  Alien(float x, float y) {
    this.x = x;
    this.y = y;
    this.health = 100;
    this.targetX = x;
    this.targetY = y;
    this.moveTimer = 0;
  }
  
  void update() {
    // Move alien randomly within top right area
    moveTimer++;
    if (moveTimer > 120) {
      targetX = random(width - 200, width - 50);
      targetY = random(50, 200);
      moveTimer = 0;
    }
    
    // Smooth movement towards target
    x = lerp(x, targetX, 0.05);
    y = lerp(y, targetY, 0.05);
  }
  
  void display() {
    // Draw alien body
    fill(150, 0, 150);
    stroke(255, 0, 255);
    strokeWeight(2);
    
    // Alien head
    ellipse(x, y, 50, 50);
    
    // Alien eyes
    fill(255, 0, 0);
    ellipse(x - 10, y - 5, 10, 10);
    ellipse(x + 10, y - 5, 10, 10);
    
    // Alien antennae
    stroke(150, 0, 150);
    line(x - 15, y - 25, x - 20, y - 40);
    line(x + 15, y - 25, x + 20, y - 40);
    fill(255, 255, 0);
    noStroke();
    ellipse(x - 20, y - 40, 8, 8);
    ellipse(x + 20, y - 40, 8, 8);
    
    // Display health bar above alien
    drawHealthBar(x - 50, y - 50, health, 100);
  }
  
  void shoot() {
    if (health > 0) {
      // Calculate angle to player
      float angle = atan2(player.y - y, player.x - x);
      
      // Add some randomness to alien's aim
      angle += random(-0.2, 0.2);
      
      float bulletSpeed = 6;
      float vx = cos(angle) * bulletSpeed;
      float vy = sin(angle) * bulletSpeed;
      alienBullets.add(new Bullet(x, y, vx, vy, false));
    }
  }
  
  void takeDamage(int damage) {
    health -= damage;
    if (health < 0) health = 0;
  }
  
  void drawHealthBar(float x, float y, int current, int max) {
    // Background
    fill(50);
    noStroke();
    rect(x, y, 100, 10);
    
    // Health
    float healthWidth = map(current, 0, max, 0, 100);
    if (current > 60) {
      fill(0, 255, 0);
    } else if (current > 30) {
      fill(255, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    rect(x, y, healthWidth, 10);
    
    // Border
    noFill();
    stroke(255);
    strokeWeight(1);
    rect(x, y, 100, 10);
  }
}

// Bullet class
class Bullet {
  float x, y;
  float vx, vy;
  boolean isPlayerBullet;
  
  Bullet(float x, float y, float vx, float vy, boolean isPlayerBullet) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.isPlayerBullet = isPlayerBullet;
  }
  
  void update() {
    x += vx;
    y += vy;
  }
  
  void display() {
    noStroke();
    if (isPlayerBullet) {
      fill(255, 255, 0);
    } else {
      fill(255, 0, 255);
    }
    ellipse(x, y, 8, 8);
  }
  
  boolean hits(float targetX, float targetY, float targetSize) {
    float d = dist(x, y, targetX, targetY);
    return d < targetSize / 2;
  }
  
  boolean isOffScreen() {
    return x < 0 || x > width || y < 0 || y > height;
  }
}
