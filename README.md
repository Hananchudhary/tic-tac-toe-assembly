# Tic-Tac-Toe (3-Piece Variant) in x86 Assembly

This repository contains a specialized implementation of the classic Tic-Tac-Toe game, written in **x86 Assembly** for the DOS environment. Unlike the standard game, this version features a "moving piece" mechanic that prevents draws and keeps the gameplay dynamic.

## Game Overview

The program is a two-player, turn-based game played on a 3x3 grid. Players take turns placing their markers (**X** and **O**) by selecting positions numbered **0 to 8**.

### Unique Mechanic: The 3-Piece Rule
To ensure the game eventually reaches a conclusion and to add a layer of strategy, each player is limited to **three pieces** on the board at any given time:
- Once a player has placed their third piece, their next move will automatically **remove their oldest piece** from the board and place it in the new position.
- This "sliding" or "moving" effect requires players to plan ahead, as their earlier moves will eventually disappear.

## Features

- **Direct Video Memory Access**: The game renders the grid and messages by writing directly to the VGA text buffer at segment `0xB800`.
- **Win Detection**: Automatically checks for winning conditions across all rows, columns, and diagonals after every move.
- **Input Validation**: Ensures players can only select valid, available positions on the grid.
- **Dynamic Display**: Clears and updates the screen in real-time to show the current board state and turn prompts.

## Technical Details

| Component | Description |
| :--- | :--- |
| **Architecture** | x86 (16-bit Real Mode) |
| **Format** | DOS COM file (`org 100h`) |
| **Display** | Text Mode (80x25), Segment `0xB800` |
| **Input** | BIOS Interrupt `INT 16h` (Keyboard Input) |
| **Termination** | DOS Interrupt `INT 21h, AH=4Ch` |

### Key Functions
- `prnt_grid`: Iterates through the `grid` array and renders the characters to the screen.
- `check_winner`: Implements the logic to verify if the current player has aligned three pieces.
- `placement`: Manages the `X_list` and `O_list` to handle the 3-piece limit and piece recycling.
- `is_valid_place`: Validates user input to ensure it falls within the '0'-'8' range and is a valid move.

## How to Run

### Prerequisites
You will need an x86 assembler (like **NASM**) and a DOS emulator (like **DOSBox**).

### Assembly Instructions
To assemble the source code into a runnable `.COM` executable:
```bash
nasm -f bin 24001Q1.asm -o game.com
```

### Execution
1. Open **DOSBox**.
2. Mount the directory containing `game.com`.
3. Run the game:
```dos
game.com
```

## Controls
- Use keys **0** through **8** to select the corresponding grid position.
- The game will prompt "Enter position for X:" or "Enter position for O:" based on the current turn.
- When a player wins, the screen displays the winner (e.g., "X wins!") and exits.

---
*Developed as a demonstration of low-level systems programming and BIOS-level interaction.*
