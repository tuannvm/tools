# Tools CLI

A collection of utilities for AWS infrastructure management with focus on Route53 record management.

## Features
- Route53 record deletion
- AWS configuration management
- CLI interface for common operations

## Installation
```bash
go install github.com/tuannvm/tools@latest
```

## Usage
```bash
# Delete Route53 records
tools delete-records --domain example.com --type TXT,A
```

## Configuration
Set AWS credentials via:
- Environment variables
- ~/.aws/credentials file
- IAM roles

## Development
```bash
# Build
go build

# Test
make test
```

## Contributing
PRs welcome! Please include:
- Tests for new features
- Updated documentation
- Signed commits
