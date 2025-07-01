# No One's Heart

A 2.5D third-person action game developed with Godot 4.4+, featuring a unique combat system and modular architecture inspired by games like "Forgive me Father" and "Pokemon Emerald Rogue".

![Godot Version](https://img.shields.io/badge/Godot-4.4+-478CBF?style=for-the-badge&logo=godot-engine)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-blue.svg?style=for-the-badge)

## 🎮 About

No One's Heart is an action-adventure game that combines 2.5D graphics with third-person gameplay. The game features a sophisticated combat system built with modular architecture, supporting multiple languages (English/Spanish), and follows SOLID principles for maintainable code.

### Key Features

- **2.5D Visual Style**: 3D world with sprite-based entities that always face the camera
- **Modular Combat System**: Factory pattern implementation for flexible combat mechanics
- **Multi-language Support**: Built-in localization system for English and Spanish
- **AI Behavior System**: Intelligent enemy AI with customizable profiles
- **Health Billboard System**: Dynamic health display for combat entities
- **Move System**: Comprehensive attack, defense, and special move framework

## 🏗️ Architecture

The project follows a modular, SOLID-based architecture:

```
scripts/
├── ai/              # AI behavior and profile systems
├── combat/          # Combat management and factory patterns
├── entities/        # Character and entity management
├── moves/           # Combat move system and presets
├── ui/              # User interface components
└── resources/       # Shared resources and utilities
```

### Design Patterns

- **Factory Pattern**: Used for creating combat entities and moves
- **Component-Based Architecture**: Modular systems for easy extension
- **Signal-Based Communication**: Loose coupling between game systems
- **Resource-Based Configuration**: Flexible data-driven design

## 🚀 Getting Started

### Prerequisites

- Godot Engine 4.4 or higher
- Git (for version control)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/no-ones-heart.git
   cd no-ones-heart
   ```

2. **Open in Godot**

   - Launch Godot Engine 4.4+
   - Click "Import" and select the `project.godot` file
   - Wait for the project to import

3. **Run the project**
   - Press F5 or click the "Play" button in Godot
   - The main menu should appear

## 🎯 Game Controls

- **Combat**: Mouse clicks for different attack types

## 🛠️ Development

### Project Structure

```
NOH/
├── assets/          # Graphics, audio, and 3D models
├── data/            # Configuration and localization files
├── docs/            # Documentation and design documents
├── scenes/          # Godot scene files (.tscn)
├── scripts/         # GDScript source code
└── project.godot    # Godot project configuration
```

### Coding Standards

- **GDScript Conventions**: snake_case for variables/functions, PascalCase for classes
- **File Length**: Maximum 500 lines per file (modularize when needed)
- **SOLID Principles**: Applied throughout the codebase
- **Error Handling**: Comprehensive null checks and error messages
- **Performance**: Object pooling and optimized rendering

### Adding New Features

1. **Combat Moves**: Add new move resources in `scripts/moves/resources/`
2. **AI Behaviors**: Extend `AIBehavior.gd` for new enemy types
3. **UI Components**: Create new scenes in `scenes/` with corresponding scripts
4. **Localization**: Update CSV files in `data/` for new text content

## 🌍 Localization

The game supports multiple languages through a CSV-based system:

- **English**: Default language
- **Spanish**: Full translation support
- **Extensible**: Easy to add more languages

Language files are located in the `data/` directory and follow a key-value format.

## 🎨 Assets

### Included Assets

- **Kenney 3D Models**: Modular 3D assets with multiple color variants
- **Samurai Pixel Art**: 2D character sprites with animation frames
- **Custom Textures**: Project-specific visual assets

### Asset Credits

- 3D Models: [Kenney](https://kenney.nl/) (CC0 License)
- Pixel Art: FREE Samurai 2D Pixel Art Pack

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Follow coding standards**: Use the established conventions
4. **Test thoroughly**: Ensure your changes work correctly
5. **Submit a pull request**: With a clear description of changes

### Development Setup

1. Install Godot 4.4+
2. Clone the repository
3. Open the project in Godot
4. Run tests and verify functionality
5. Make your changes following the established patterns

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Godot Engine**: For the amazing game development platform
- **Kenney**: For the excellent 3D asset pack
- **Community**: For inspiration and support

## 📞 Contact

- **Project Link**: [https://github.com/manuoyaregui/no-ones-heart](https://github.com/manuoyaregui/no-ones-heart)
- **Issues**: [GitHub Issues](https://github.com/manuoyaregui/no-ones-heart/issues)

---

**Made with ❤️ and Godot Engine**
