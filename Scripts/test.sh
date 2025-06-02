#!/bin/bash
# Run tests with coverage

echo "🧪 Running AURA tests..."
swift test --enable-code-coverage

echo "📊 Generating coverage report..."
xcrun llvm-cov export \
    .build/debug/AURAPackageTests.xctest/Contents/MacOS/AURAPackageTests \
    -instr-profile .build/debug/codecov/default.profdata \
    -format="lcov" > coverage.lcov

echo "✅ Tests complete!"