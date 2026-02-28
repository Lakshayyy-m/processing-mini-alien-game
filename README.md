# Shooting Game - Processing

A simple shooting game built with Processing Java library where you control a player fighting against an alien enemy.

## Game Features

### Player (Blue Circle - Bottom Left)
- **Health**: 100 HP (displayed with health bar)
- **Ammo**: 30 bullets
- **Controls**: 
  - Move mouse to aim
  - Click to shoot

### Alien (Purple Circle - Top Right)
- **Health**: 100 HP (displayed with health bar above)
- Moves randomly in the top right area
- Auto-shoots at the player every second
- Has slightly inaccurate aim

### Gameplay
- Shoot the alien to reduce its health
- Avoid alien bullets to preserve your health
- Yellow bullets = Player's bullets
- Purple bullets = Alien's bullets
- Game ends when either player or alien health reaches 0
- Press 'R' to restart the game

## How to Run

### Prerequisites
- Install [Processing](https://processing.org/download) (version 3.x or 4.x)

### Steps
1. Open Processing IDE
2. Open the `ShootingGame.pde` file
3. Click the "Run" button (play icon) or press `Ctrl+R` (Windows/Linux) or `Cmd+R` (Mac)

## Game Mechanics

- **Collision Detection**: Uses distance calculation with `dist()` function
- **Gun Rotation**: Uses `atan2()` to calculate angle between player and mouse
- **Smooth Movement**: Alien uses `lerp()` for smooth interpolation
- **Health Bars**: Color-coded (Green > Yellow > Red) based on health percentage

## Controls Summary
- **Mouse Movement**: Aim your gun
- **Mouse Click**: Shoot (costs 1 ammo)
- **R Key**: Restart game after game over

Enjoy the game!
# processing-mini-alien-game
