# AURA - AI Development Assistant

## Project Overview
AURA is a voice-controlled AI development assistant that runs entirely on-device on Apple Silicon Macs. Think of it as your personal Jarvis for building software.

## Vision
- 100% local, private execution
- Voice-first interaction ("Hey AURA")
- Can build entire applications through conversation
- Self-improving through usage

## Technical Architecture
- Language: Swift 5.9+
- Platform: macOS 13+
- Architecture: Modular with Swift Package Manager
- Testing: TDD with Quick/Nimble
- AI: Local LLMs via MLX
- Voice: Whisper.cpp for STT, AVSpeechSynthesizer for TTS

## Code Style
- Protocol-oriented design
- Async/await for all async operations
- Comprehensive error handling
- Minimum 90% test coverage
- Clear documentation for all public APIs

## Module Structure
- AURACore: Core business logic and protocols
- VoiceEngine: Speech recognition and synthesis
- NLPProcessor: Natural language understanding
- AgentSystem: Multi-agent orchestration
- SandboxEngine: Safe code execution environment

## Current Development Status
- [ ] Project setup and configuration
- [ ] Wake word detection
- [ ] Basic voice loop
- [ ] First agent implementation

## Key Decisions
- Using MLX for local LLM inference
- Whisper.cpp for speech recognition
- Quick/Nimble for testing framework
- OrbStack for containerization (later)

## Development Workflow
1. TDD: Write tests first
2. One feature per conversation/session
3. Clear commit messages with [AI-ASSISTED] tags
4. Update this document after each session