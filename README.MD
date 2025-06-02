# AURA - Your Personal AI Development Assistant

AURA is a voice-controlled AI assistant that runs entirely on your Mac, designed to help you build software through natural conversation. Think of it as your personal Jarvis for coding.

## Features

- 🎙️ Voice-controlled interface ("Hey AURA")
- 🔒 100% local execution - your code never leaves your machine
- 🤖 Multi-agent system that can build complete applications
- 🧪 Test-driven development built into its DNA
- 📱 Optimized for Apple Silicon

## Quick Start

```bash
# Clone the repository
git clone [your-repo-url]
cd AURA-v2

# Build the project
swift build

# Run tests
swift test

# Run AURA
swift run aura
```

## Architecture

AURA uses a modular architecture with specialized agents:

- **Conductor Agent**: Orchestrates all other agents
- **Voice Agent**: Handles speech recognition and synthesis
- **Coder Agent**: Writes and refactors code
- **Tester Agent**: Creates comprehensive test suites
- **DevOps Agent**: Manages builds and deployments

## Development

This project follows Test-Driven Development (TDD) principles. Every feature starts with tests.

### Building

```bash
swift build
```

### Testing

```bash
swift test
```

### Code Style

We use SwiftLint for code consistency:

```bash
swiftlint
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests first
4. Implement your feature
5. Ensure all tests pass
6. Submit a pull request

## License

MIT License - see LICENSE file for details